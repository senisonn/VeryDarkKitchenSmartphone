"""
Database initialization script
Run this to create tables and populate with initial data
"""
from datetime import datetime, timedelta
from app.database import SessionLocal, engine, Base
from app.models.user import User, Role
from app.models.plat import Plat, CategoriePlat
from app.models.reservation import Reservation, StatutReservation
from app.utils.auth import get_password_hash


def init_db():
    """Initialize database with tables and sample data"""
    print("Creating database tables...")
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        # Check if data already exists
        if db.query(User).first() is not None:
            print("Database already initialized. Skipping...")
            return

        print("Inserting sample data...")

        # Create users
        users = [
            User(
                username="admin",
                password=get_password_hash("admin"),
                email="admin@restaurant.com",
                role=Role.ADMIN
            ),
            User(
                username="user",
                password=get_password_hash("user"),
                email="user@restaurant.com",
                role=Role.USER
            ),
        ]
        db.add_all(users)
        db.commit()
        print(f"Created {len(users)} users")

        # Create dishes
        plats = [
            Plat(
                nom="Salade César",
                description="Laitue romaine, parmesan, croûtons, sauce César",
                prix=8.50,
                categorie=CategoriePlat.ENTREE,
                disponible=True
            ),
            Plat(
                nom="Soupe à l'oignon",
                description="Soupe traditionnelle gratinée au fromage",
                prix=7.00,
                categorie=CategoriePlat.ENTREE,
                disponible=True
            ),
            Plat(
                nom="Steak Frites",
                description="Entrecôte de bœuf, frites maison",
                prix=18.00,
                categorie=CategoriePlat.PLAT_PRINCIPAL,
                disponible=True
            ),
            Plat(
                nom="Saumon Grillé",
                description="Filet de saumon, légumes de saison",
                prix=16.50,
                categorie=CategoriePlat.PLAT_PRINCIPAL,
                disponible=True
            ),
            Plat(
                nom="Pizza Margherita",
                description="Tomate, mozzarella, basilic",
                prix=12.00,
                categorie=CategoriePlat.PLAT_PRINCIPAL,
                disponible=True
            ),
            Plat(
                nom="Tiramisu",
                description="Dessert italien classique",
                prix=6.00,
                categorie=CategoriePlat.DESSERT,
                disponible=True
            ),
            Plat(
                nom="Mousse au Chocolat",
                description="Mousse légère au chocolat noir",
                prix=5.50,
                categorie=CategoriePlat.DESSERT,
                disponible=True
            ),
            Plat(
                nom="Coca-Cola",
                description="33cl",
                prix=3.00,
                categorie=CategoriePlat.BOISSON,
                disponible=True
            ),
        ]
        db.add_all(plats)
        db.commit()
        print(f"Created {len(plats)} dishes")

        # Refresh to get IDs
        for user in users:
            db.refresh(user)
        for plat in plats:
            db.refresh(plat)

        # Create sample reservations
        now = datetime.now()
        reservations = [
            Reservation(
                user_id=users[1].id,
                email="user@restaurant.com",
                telephone="0123456789",
                date_reservation=now + timedelta(days=1, hours=19),
                nombre_personnes=2,
                statut=StatutReservation.EN_ATTENTE,
                commentaire="Table près de la fenêtre si possible",
                date_creation=now,
                plats=[plats[0], plats[2], plats[5]]
            ),
            Reservation(
                user_id=users[1].id,
                email="user@restaurant.com",
                telephone="0123456789",
                date_reservation=now + timedelta(days=3, hours=20),
                nombre_personnes=4,
                statut=StatutReservation.CONFIRMEE,
                date_creation=now,
                plats=[plats[1], plats[3], plats[6]]
            ),
            Reservation(
                email="guest@example.com",
                telephone="0987654321",
                date_reservation=now + timedelta(days=5, hours=18, minutes=30),
                nombre_personnes=3,
                statut=StatutReservation.EN_ATTENTE,
                commentaire="Allergique aux fruits de mer",
                date_creation=now,
                plats=[plats[0], plats[4]]
            ),
            Reservation(
                user_id=users[1].id,
                email="user@restaurant.com",
                telephone="0123456789",
                date_reservation=now - timedelta(days=1),
                nombre_personnes=2,
                statut=StatutReservation.TERMINEE,
                date_creation=now - timedelta(days=2),
                plats=[plats[2], plats[5]]
            ),
        ]
        db.add_all(reservations)
        db.commit()
        print(f"Created {len(reservations)} reservations")

        print("\n=== Database initialized successfully! ===")
        print("\nDefault users:")
        print("- Admin: username=admin, password=admin")
        print("- User: username=user, password=user")
        print(f"\nCreated {len(plats)} dishes and {len(reservations)} sample reservations")

    except Exception as e:
        print(f"Error initializing database: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    init_db()
