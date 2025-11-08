from pydantic import BaseModel, field_serializer
from decimal import Decimal
from app.models.plat import CategoriePlat


class PlatDTO(BaseModel):
    """DTO for dish/menu item"""
    id: int
    nom: str
    description: str | None = None
    prix: Decimal
    categorie: CategoriePlat
    imageUrl: str | None = None
    disponible: bool

    class Config:
        from_attributes = True
        json_encoders = {
            Decimal: float  # Serialize Decimal as float, not string
        }

    @field_serializer('prix')
    def serialize_prix(self, value: Decimal) -> float:
        """Serialize prix as float for JSON compatibility"""
        return float(value)

    @classmethod
    def from_orm(cls, obj):
        """Convert ORM object to DTO"""
        return cls(
            id=obj.id,
            nom=obj.nom,
            description=obj.description,
            prix=obj.prix,
            categorie=obj.categorie,
            imageUrl=obj.image_url,
            disponible=obj.disponible,
        )
