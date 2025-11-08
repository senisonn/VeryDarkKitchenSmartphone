from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.user import User
from app.schemas.auth import RegisterRequest, AuthRequest, AuthResponse
from app.utils.auth import get_password_hash, verify_password, create_access_token


class AuthService:
    """Service for authentication operations"""

    @staticmethod
    def register(db: Session, request: RegisterRequest) -> AuthResponse:
        """Register a new user"""
        # Check if username already exists
        if db.query(User).filter(User.username == request.username).first():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Username already registered"
            )

        # Check if email already exists
        if db.query(User).filter(User.email == request.email).first():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )

        # Create new user
        hashed_password = get_password_hash(request.password)
        user = User(
            username=request.username,
            password=hashed_password,
            email=request.email,
            role=request.role
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        # Create access token
        access_token = create_access_token(
            data={"sub": user.username, "role": user.role.value, "userId": user.id}
        )

        return AuthResponse(
            token=access_token,
            role=user.role.value,
            userId=user.id,
            username=user.username
        )

    @staticmethod
    def login(db: Session, request: AuthRequest) -> AuthResponse:
        """Authenticate user and return token"""
        # Find user by username
        user = db.query(User).filter(User.username == request.username).first()

        if not user or not verify_password(request.password, user.password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect username or password",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Create access token
        access_token = create_access_token(
            data={"sub": user.username, "role": user.role.value, "userId": user.id}
        )

        return AuthResponse(
            token=access_token,
            role=user.role.value,
            userId=user.id,
            username=user.username
        )
