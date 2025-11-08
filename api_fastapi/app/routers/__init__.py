from .auth import router as auth_router
from .plats import router as plats_router
from .reservations import router as reservations_router

__all__ = ["auth_router", "plats_router", "reservations_router"]
