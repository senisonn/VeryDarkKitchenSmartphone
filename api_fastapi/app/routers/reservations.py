from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.reservation import (
    ReservationRequest,
    ReservationResponse,
    UpdateReservationRequest,
    AvailabilityRequest,
    AvailabilityResponse,
)
from app.models.reservation import StatutReservation
from app.models.user import User
from app.services.reservation_service import ReservationService
from app.services.availability_service import AvailabilityService
from app.utils.auth import get_current_user, get_current_admin_user

router = APIRouter(prefix="/api/reservations", tags=["Reservations"])


@router.post("", response_model=ReservationResponse, status_code=status.HTTP_201_CREATED)
def create_reservation(
    request: ReservationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new reservation (requires authentication)"""
    return ReservationService.create(db, request)


@router.get("", response_model=list[ReservationResponse])
def get_all_reservations(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all reservations (requires authentication)"""
    return ReservationService.get_all(db)


@router.get("/pending", response_model=list[ReservationResponse])
def get_pending_reservations(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Get all pending reservations (ADMIN only)"""
    return ReservationService.get_pending(db)


@router.get("/status/{statut}", response_model=list[ReservationResponse])
def get_by_status(
    statut: StatutReservation,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Get reservations by status (ADMIN only)"""
    return ReservationService.get_by_status(db, statut)


@router.get("/email/{email}", response_model=list[ReservationResponse])
def get_by_email(
    email: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get reservations by email"""
    return ReservationService.get_by_email(db, email)


@router.get("/user/{user_id}", response_model=list[ReservationResponse])
def get_by_user_id(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get reservations for specific user"""
    return ReservationService.get_by_user_id(db, user_id)


@router.get("/{id}", response_model=ReservationResponse)
def get_reservation_by_id(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get specific reservation"""
    return ReservationService.get_by_id(db, id)


@router.put("/{id}", response_model=ReservationResponse)
def update_reservation(
    id: int,
    request: UpdateReservationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update existing reservation"""
    return ReservationService.update(db, id, request)


@router.put("/{id}/statut", response_model=ReservationResponse)
def update_status(
    id: int,
    statut: StatutReservation,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update reservation status"""
    return ReservationService.update_status(db, id, statut)


@router.put("/{id}/approve", response_model=ReservationResponse)
def approve_reservation(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Approve pending reservation (ADMIN only)"""
    return ReservationService.approve(db, id)


@router.put("/{id}/reject", response_model=ReservationResponse)
def reject_reservation(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Reject pending reservation (ADMIN only)"""
    return ReservationService.reject(db, id)


@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
def cancel_reservation(
    id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Cancel reservation (soft delete - sets status to ANNULEE)"""
    ReservationService.cancel(db, id)
    return None


@router.post("/availability", response_model=AvailabilityResponse)
def check_availability(
    request: AvailabilityRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Check table availability for date/time"""
    return AvailabilityService.check_availability(db, request)
