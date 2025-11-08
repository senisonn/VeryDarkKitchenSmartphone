from pydantic import BaseModel, EmailStr, Field, field_validator
from datetime import datetime
from typing import Optional
from app.models.reservation import StatutReservation
from app.schemas.plat import PlatDTO


class ReservationRequest(BaseModel):
    """Request schema for creating a reservation"""
    idClient: Optional[int] = None
    email: EmailStr
    telephone: str
    dateReservation: datetime
    nombrePersonnes: int = Field(..., ge=1, le=20)
    platIds: list[int] = []
    commentaire: Optional[str] = None

    @field_validator('dateReservation')
    @classmethod
    def validate_future_date(cls, v):
        """Ensure reservation date is in the future"""
        if v < datetime.now():
            raise ValueError("La date de réservation doit être dans le futur")
        return v


class UpdateReservationRequest(BaseModel):
    """Request schema for updating a reservation"""
    email: Optional[EmailStr] = None
    telephone: Optional[str] = None
    dateReservation: Optional[datetime] = None
    nombrePersonnes: Optional[int] = Field(None, ge=1, le=20)
    platIds: Optional[list[int]] = None
    commentaire: Optional[str] = None


class ReservationResponse(BaseModel):
    """Response schema for reservation"""
    id: int
    userId: Optional[int] = None
    email: str
    telephone: str
    dateReservation: datetime
    nombrePersonnes: int
    statut: StatutReservation
    commentaire: Optional[str] = None
    dateCreation: datetime
    plats: list[PlatDTO] = []

    class Config:
        from_attributes = True

    @classmethod
    def from_orm(cls, obj):
        """Convert ORM object to DTO"""
        return cls(
            id=obj.id,
            userId=obj.user_id,
            email=obj.email,
            telephone=obj.telephone,
            dateReservation=obj.date_reservation,
            nombrePersonnes=obj.nombre_personnes,
            statut=obj.statut,
            commentaire=obj.commentaire,
            dateCreation=obj.date_creation,
            plats=[PlatDTO.from_orm(plat) for plat in obj.plats],
        )


class AvailabilityRequest(BaseModel):
    """Request schema for checking availability"""
    dateReservation: datetime
    nombrePersonnes: int = Field(..., ge=1, le=20)


class AvailabilityResponse(BaseModel):
    """Response schema for availability check"""
    dateReservation: datetime
    totalCapacity: int
    reservedSeats: int
    availableSeats: int
    available: bool

    class Config:
        from_attributes = True
