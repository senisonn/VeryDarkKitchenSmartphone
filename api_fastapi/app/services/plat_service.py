from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from app.models.plat import Plat, CategoriePlat
from app.schemas.plat import PlatDTO


class PlatService:
    """Service for dish/menu operations"""

    @staticmethod
    def get_all(db: Session) -> list[PlatDTO]:
        """Get all dishes"""
        plats = db.query(Plat).all()
        return [PlatDTO.from_orm(plat) for plat in plats]

    @staticmethod
    def get_by_id(db: Session, plat_id: int) -> PlatDTO:
        """Get dish by ID"""
        plat = db.query(Plat).filter(Plat.id == plat_id).first()
        if not plat:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Plat with id {plat_id} not found"
            )
        return PlatDTO.from_orm(plat)

    @staticmethod
    def get_by_categorie(db: Session, categorie: CategoriePlat) -> list[PlatDTO]:
        """Get dishes by category"""
        plats = db.query(Plat).filter(Plat.categorie == categorie).all()
        return [PlatDTO.from_orm(plat) for plat in plats]

    @staticmethod
    def get_disponibles(db: Session) -> list[PlatDTO]:
        """Get only available dishes"""
        plats = db.query(Plat).filter(Plat.disponible == True).all()
        return [PlatDTO.from_orm(plat) for plat in plats]
