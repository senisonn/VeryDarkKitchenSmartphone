import enum
from sqlalchemy import Column, BigInteger, String, Numeric, Boolean, Enum
from app.database import Base


class CategoriePlat(str, enum.Enum):
    """Dish categories"""
    ENTREE = "ENTREE"
    PLAT_PRINCIPAL = "PLAT_PRINCIPAL"
    DESSERT = "DESSERT"
    BOISSON = "BOISSON"


class Plat(Base):
    """Dish/Menu item model"""
    __tablename__ = "plats"

    id = Column(BigInteger, primary_key=True, index=True, autoincrement=True)
    nom = Column(String, nullable=False)
    description = Column(String)
    prix = Column(Numeric(10, 2), nullable=False)
    categorie = Column(Enum(CategoriePlat), nullable=False)
    image_url = Column(String)
    disponible = Column(Boolean, default=True, nullable=False)

    def __repr__(self):
        return f"<Plat {self.nom}>"
