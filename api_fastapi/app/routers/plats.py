from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.plat import PlatDTO
from app.services.plat_service import PlatService
from app.models.plat import CategoriePlat

router = APIRouter(prefix="/api/plats", tags=["Plats/Menu"])


@router.get("", response_model=list[PlatDTO])
def get_all_plats(db: Session = Depends(get_db)):
    """Get all dishes"""
    return PlatService.get_all(db)


@router.get("/disponibles", response_model=list[PlatDTO])
def get_disponibles(db: Session = Depends(get_db)):
    """Get only available dishes"""
    return PlatService.get_disponibles(db)


@router.get("/categorie/{categorie}", response_model=list[PlatDTO])
def get_by_categorie(categorie: CategoriePlat, db: Session = Depends(get_db)):
    """Get dishes by category"""
    return PlatService.get_by_categorie(db, categorie)


@router.get("/{id}", response_model=PlatDTO)
def get_plat_by_id(id: int, db: Session = Depends(get_db)):
    """Get specific dish by ID"""
    return PlatService.get_by_id(db, id)
