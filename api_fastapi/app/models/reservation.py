import enum
from datetime import datetime
from sqlalchemy import Column, BigInteger, String, Integer, DateTime, Enum, ForeignKey, Table
from sqlalchemy.orm import relationship
from app.database import Base


class StatutReservation(str, enum.Enum):
    """Reservation status"""
    EN_ATTENTE = "EN_ATTENTE"
    CONFIRMEE = "CONFIRMEE"
    ANNULEE = "ANNULEE"
    TERMINEE = "TERMINEE"


# Association table for many-to-many relationship
reservation_plats = Table(
    'reservation_plats',
    Base.metadata,
    Column('reservation_id', BigInteger, ForeignKey('reservations.id'), primary_key=True),
    Column('plat_id', BigInteger, ForeignKey('plats.id'), primary_key=True)
)


class Reservation(Base):
    """Reservation model"""
    __tablename__ = "reservations"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    user_id = Column(BigInteger, ForeignKey('users.id'), nullable=True)
    email = Column(String, nullable=False, index=True)
    telephone = Column(String, nullable=False)
    date_reservation = Column(DateTime, nullable=False, index=True)
    nombre_personnes = Column(Integer, nullable=False)
    statut = Column(Enum(StatutReservation), nullable=False, default=StatutReservation.EN_ATTENTE)
    commentaire = Column(String)
    date_creation = Column(DateTime, nullable=False, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="reservations")
    plats = relationship("Plat", secondary=reservation_plats)

    def __repr__(self):
        return f"<Reservation {self.id} - {self.email}>"
