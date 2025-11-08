from pydantic import BaseModel, EmailStr, Field, validator
from app.models.user import Role


class RegisterRequest(BaseModel):
    """Request schema for user registration"""
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=6)
    email: EmailStr
    role: Role = Role.USER

    class Config:
        from_attributes = True


class AuthRequest(BaseModel):
    """Request schema for authentication"""
    username: str
    password: str


class AuthResponse(BaseModel):
    """Response schema for authentication"""
    token: str
    role: str
    userId: int
    username: str

    class Config:
        from_attributes = True
