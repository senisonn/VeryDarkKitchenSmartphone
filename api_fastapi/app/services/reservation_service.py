from datetime import datetime
from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.reservation import Reservation, StatutReservation
from app.models.plat import Plat
from app.schemas.reservation import (
    ReservationRequest,
    ReservationResponse,
    UpdateReservationRequest,
    AvailabilityRequest,
)
from app.services.availability_service import AvailabilityService


class ReservationService:
    """Service for reservation operations"""

    @staticmethod
    def create(db: Session, request: ReservationRequest) -> ReservationResponse:
        """Create a new reservation"""
        # Validate future date
        if request.dateReservation < datetime.now():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="La date de réservation doit être dans le futur"
            )

        # Check availability
        availability_request = AvailabilityRequest(
            dateReservation=request.dateReservation,
            nombrePersonnes=request.nombrePersonnes
        )
        availability = AvailabilityService.check_availability(db, availability_request)

        if not availability.available:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Pas assez de places disponibles. Places restantes: {availability.availableSeats}"
            )

        # Get dishes if provided
        plats = []
        if request.platIds:
            plats = db.query(Plat).filter(Plat.id.in_(request.platIds)).all()
            if len(plats) != len(request.platIds):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Un ou plusieurs plats n'existent pas"
                )

        # Create reservation
        reservation = Reservation(
            user_id=request.idClient,
            email=request.email,
            telephone=request.telephone,
            date_reservation=request.dateReservation,
            nombre_personnes=request.nombrePersonnes,
            statut=StatutReservation.EN_ATTENTE,
            commentaire=request.commentaire,
            date_creation=datetime.now(),
            plats=plats
        )

        db.add(reservation)
        db.commit()
        db.refresh(reservation)

        return ReservationResponse.from_orm(reservation)

    @staticmethod
    def get_all(db: Session) -> list[ReservationResponse]:
        """Get all reservations"""
        reservations = db.query(Reservation).all()
        return [ReservationResponse.from_orm(r) for r in reservations]

    @staticmethod
    def get_by_id(db: Session, reservation_id: int) -> ReservationResponse:
        """Get reservation by ID"""
        reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
        if not reservation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Réservation avec id {reservation_id} non trouvée"
            )
        return ReservationResponse.from_orm(reservation)

    @staticmethod
    def get_by_email(db: Session, email: str) -> list[ReservationResponse]:
        """Get reservations by email"""
        reservations = db.query(Reservation).filter(Reservation.email == email).all()
        return [ReservationResponse.from_orm(r) for r in reservations]

    @staticmethod
    def get_by_user_id(db: Session, user_id: int) -> list[ReservationResponse]:
        """Get reservations by user ID"""
        reservations = db.query(Reservation).filter(Reservation.user_id == user_id).all()
        return [ReservationResponse.from_orm(r) for r in reservations]

    @staticmethod
    def get_by_status(db: Session, statut: StatutReservation) -> list[ReservationResponse]:
        """Get reservations by status"""
        reservations = db.query(Reservation).filter(Reservation.statut == statut).all()
        return [ReservationResponse.from_orm(r) for r in reservations]

    @staticmethod
    def get_pending(db: Session) -> list[ReservationResponse]:
        """Get all pending reservations"""
        return ReservationService.get_by_status(db, StatutReservation.EN_ATTENTE)

    @staticmethod
    def update(
        db: Session,
        reservation_id: int,
        request: UpdateReservationRequest
    ) -> ReservationResponse:
        """Update an existing reservation"""
        reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
        if not reservation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Réservation avec id {reservation_id} non trouvée"
            )

        # Check availability if date or number of people is being changed
        if request.dateReservation or request.nombrePersonnes:
            new_date = request.dateReservation or reservation.date_reservation
            new_people = request.nombrePersonnes or reservation.nombre_personnes

            availability_request = AvailabilityRequest(
                dateReservation=new_date,
                nombrePersonnes=new_people
            )
            availability = AvailabilityService.check_availability(
                db, availability_request, exclude_reservation_id=reservation_id
            )

            if not availability.available:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Pas assez de places disponibles. Places restantes: {availability.availableSeats}"
                )

        # Update fields
        if request.email:
            reservation.email = request.email
        if request.telephone:
            reservation.telephone = request.telephone
        if request.dateReservation:
            reservation.date_reservation = request.dateReservation
        if request.nombrePersonnes:
            reservation.nombre_personnes = request.nombrePersonnes
        if request.commentaire is not None:
            reservation.commentaire = request.commentaire

        # Update dishes if provided
        if request.platIds is not None:
            plats = db.query(Plat).filter(Plat.id.in_(request.platIds)).all()
            if len(plats) != len(request.platIds):
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Un ou plusieurs plats n'existent pas"
                )
            reservation.plats = plats

        db.commit()
        db.refresh(reservation)

        return ReservationResponse.from_orm(reservation)

    @staticmethod
    def update_status(
        db: Session,
        reservation_id: int,
        statut: StatutReservation
    ) -> ReservationResponse:
        """Update reservation status"""
        reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
        if not reservation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Réservation avec id {reservation_id} non trouvée"
            )

        reservation.statut = statut
        db.commit()
        db.refresh(reservation)

        return ReservationResponse.from_orm(reservation)

    @staticmethod
    def cancel(db: Session, reservation_id: int) -> None:
        """Cancel a reservation (soft delete)"""
        reservation = db.query(Reservation).filter(Reservation.id == reservation_id).first()
        if not reservation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Réservation avec id {reservation_id} non trouvée"
            )

        reservation.statut = StatutReservation.ANNULEE
        db.commit()

    @staticmethod
    def approve(db: Session, reservation_id: int) -> ReservationResponse:
        """Approve a pending reservation"""
        return ReservationService.update_status(db, reservation_id, StatutReservation.CONFIRMEE)

    @staticmethod
    def reject(db: Session, reservation_id: int) -> ReservationResponse:
        """Reject a pending reservation"""
        return ReservationService.update_status(db, reservation_id, StatutReservation.ANNULEE)
