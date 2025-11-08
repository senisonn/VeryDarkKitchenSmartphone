# Restaurant API - FastAPI Version

This is a FastAPI implementation of the restaurant reservation and menu management API. It mirrors the functionality of the Spring Boot backend.

## Features

- JWT-based authentication
- User registration and login
- Menu/dish management
- Reservation system with availability checking
- Role-based access control (USER, ADMIN)
- PostgreSQL database
- Docker support

## Tech Stack

- **FastAPI** - Modern, fast web framework
- **SQLAlchemy** - SQL toolkit and ORM
- **PostgreSQL** - Database
- **Pydantic** - Data validation
- **Python-JOSE** - JWT handling
- **Passlib** - Password hashing with BCrypt
- **Uvicorn** - ASGI server

## Project Structure

```
api_fastapi/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI application entry point
│   ├── config.py            # Application settings
│   ├── database.py          # Database connection and session
│   ├── models/              # SQLAlchemy models
│   │   ├── user.py
│   │   ├── plat.py
│   │   └── reservation.py
│   ├── schemas/             # Pydantic schemas (DTOs)
│   │   ├── auth.py
│   │   ├── plat.py
│   │   └── reservation.py
│   ├── routers/             # API endpoints
│   │   ├── auth.py
│   │   ├── plats.py
│   │   └── reservations.py
│   ├── services/            # Business logic
│   │   ├── auth_service.py
│   │   ├── plat_service.py
│   │   ├── reservation_service.py
│   │   └── availability_service.py
│   └── utils/               # Utilities
│       └── auth.py          # JWT and password utilities
├── init_db.py               # Database initialization script
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── .env.example
```

## Installation

### Option 1: Docker (Recommended)

1. Clone the repository and navigate to the fastapi directory:
```bash
cd api_fastapi
```

2. Copy the environment file:
```bash
cp .env.example .env
```

3. Start with Docker Compose:
```bash
docker-compose up --build
```

The API will be available at `http://localhost:8000`

### Option 2: Local Development

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up PostgreSQL database (make sure PostgreSQL is running):
```bash
createdb restaurant_db
```

4. Copy and configure environment:
```bash
cp .env.example .env
# Edit .env with your settings
```

5. Initialize the database:
```bash
python init_db.py
```

6. Run the application:
```bash
uvicorn app.main:app --reload
```

Or use Python directly:
```bash
python -m app.main
```

The API will be available at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Default Credentials

After running the database initialization:

- **Admin**: username=`admin`, password=`admin`
- **User**: username=`user`, password=`user`

## API Endpoints

### Authentication (`/api/auth`)

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and get JWT token

### Menu/Dishes (`/api/plats`)

- `GET /api/plats` - Get all dishes
- `GET /api/plats/{id}` - Get dish by ID
- `GET /api/plats/categorie/{categorie}` - Get dishes by category
- `GET /api/plats/disponibles` - Get available dishes

### Reservations (`/api/reservations`)

All reservation endpoints require authentication (JWT token).

- `POST /api/reservations` - Create new reservation
- `GET /api/reservations` - Get all reservations
- `GET /api/reservations/{id}` - Get reservation by ID
- `GET /api/reservations/email/{email}` - Get reservations by email
- `GET /api/reservations/user/{userId}` - Get reservations by user
- `PUT /api/reservations/{id}` - Update reservation
- `PUT /api/reservations/{id}/statut?statut={status}` - Update status
- `DELETE /api/reservations/{id}` - Cancel reservation
- `POST /api/reservations/availability` - Check availability

#### Admin-only endpoints:
- `GET /api/reservations/pending` - Get pending reservations
- `GET /api/reservations/status/{status}` - Get by status
- `PUT /api/reservations/{id}/approve` - Approve reservation
- `PUT /api/reservations/{id}/reject` - Reject reservation

## Authentication

Use JWT tokens for authenticated endpoints:

1. Login or register to get a token
2. Include the token in the Authorization header:
```
Authorization: Bearer <your-token>
```

## Configuration

Edit `.env` file to configure:

- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY` - JWT secret key (change in production!)
- `ACCESS_TOKEN_EXPIRE_MINUTES` - Token expiration (default: 1440 = 24 hours)
- `RESTAURANT_CAPACITY` - Total seats (default: 50)
- `PORT` - Server port (default: 8000)
- `HOST` - Server host (default: 0.0.0.0)

## Database Schema

The application uses the same PostgreSQL schema as the Spring Boot version:

- **users** - User accounts and authentication
- **plats** - Menu items/dishes
- **reservations** - Customer reservations
- **reservation_plats** - Many-to-many relationship

## Business Logic

### Availability Checking

- Restaurant capacity: 50 seats (configurable)
- Time window: ±1 hour from requested time
- Excludes cancelled reservations
- Supports updates without counting existing booking

### Reservation Status Flow

1. `EN_ATTENTE` - Pending (initial state)
2. `CONFIRMEE` - Confirmed
3. `ANNULEE` - Cancelled
4. `TERMINEE` - Completed

## Development

### Running tests
```bash
pytest
```

### Code formatting
```bash
black app/
```

### Linting
```bash
flake8 app/
```

## Comparison with Spring Boot Backend

This FastAPI implementation provides the same functionality as the Spring Boot version:

✅ Same database schema
✅ Same API endpoints
✅ Same authentication (JWT)
✅ Same business logic
✅ Same validation rules
✅ Compatible with the same Flutter mobile app

### Key Differences:

- **Language**: Python vs Java
- **Framework**: FastAPI vs Spring Boot
- **ORM**: SQLAlchemy vs Hibernate/JPA
- **Server**: Uvicorn (ASGI) vs Tomcat (Servlet)
- **Auto-docs**: Swagger/ReDoc built-in vs Springdoc

## License

MIT
