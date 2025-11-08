import enum
from sqlalchemy import Column, BigInteger, String, Enum
from sqlalchemy.orm import relationship
from app.database import Base


class Role(str, enum.Enum):
    """User roles"""
    USER = "USER"
    ADMIN = "ADMIN"


class User(Base):
    """User model"""
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    username = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    role = Column(Enum(Role), nullable=False, default=Role.USER)

    # Relationships
    reservations = relationship("Reservation", back_populates="user")

    def __repr__(self):
        return f"<User {self.username}>"
