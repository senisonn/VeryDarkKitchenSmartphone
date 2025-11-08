from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from app.models.reservation import Reservation, StatutReservation
from app.schemas.reservation import AvailabilityRequest, AvailabilityResponse
from app.config import settings


class AvailabilityService:
    """Service for checking table availability"""

    @staticmethod
    def check_availability(
        db: Session,
        request: AvailabilityRequest,
        exclude_reservation_id: int = None
    ) -> AvailabilityResponse:
        """
        Check if there's availability for the requested date and number of people
        Time window: ±1 hour from requested time
        """
        # Calculate time window (±1 hour)
        start_time = request.dateReservation - timedelta(hours=1)
        end_time = request.dateReservation + timedelta(hours=1)

        # Query reservations in the time window (excluding cancelled ones)
        query = db.query(Reservation).filter(
            Reservation.date_reservation >= start_time,
            Reservation.date_reservation <= end_time,
            Reservation.statut != StatutReservation.ANNULEE
        )

        # Exclude the current reservation if updating
        if exclude_reservation_id:
            query = query.filter(Reservation.id != exclude_reservation_id)

        reservations = query.all()

        # Calculate reserved seats
        reserved_seats = sum(r.nombre_personnes for r in reservations)

        # Calculate available seats
        total_capacity = settings.RESTAURANT_CAPACITY
        available_seats = total_capacity - reserved_seats

        # Check if requested number of people can be accommodated
        is_available = available_seats >= request.nombrePersonnes

        return AvailabilityResponse(
            dateReservation=request.dateReservation,
            totalCapacity=total_capacity,
            reservedSeats=reserved_seats,
            availableSeats=available_seats,
            available=is_available
        )
