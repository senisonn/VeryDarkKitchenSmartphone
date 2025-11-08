# Quick Start Guide - FastAPI Backend

## Fastest way to get started (Docker)

```bash
cd api_fastapi
docker-compose up --build
```

That's it! The API will be running at:
- API: http://localhost:8000
- Swagger docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Local development (without Docker)

### 1. Install dependencies

```bash
cd api_fastapi

# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate  # macOS/Linux
# OR
venv\Scripts\activate     # Windows

# Install packages
pip install -r requirements.txt
```

### 2. Set up database

Make sure PostgreSQL is running, then create the database:

```bash
createdb restaurant_db
```

Or use the existing database from your Spring Boot setup.

### 3. Initialize the database

```bash
python init_db.py
```

This creates tables and adds sample data (users, dishes, reservations).

### 4. Run the server

```bash
uvicorn app.main:app --reload
```

Or use the helper script:

```bash
chmod +x run.sh
./run.sh
```

## Testing the API

### 1. Login to get a token

```bash
curl -X POST "http://localhost:8000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'
```

Response:
```json
{
  "token": "eyJhbGc...",
  "role": "ADMIN",
  "userId": 1,
  "username": "admin"
}
```

### 2. Use the token

```bash
TOKEN="your-token-here"

curl -X GET "http://localhost:8000/api/reservations" \
  -H "Authorization: Bearer $TOKEN"
```

### 3. Or use the interactive docs

Open http://localhost:8000/docs in your browser:
1. Click the "Authorize" button
2. Enter: `Bearer your-token-here`
3. Try out all endpoints interactively!

## Default Credentials

- Admin: `admin` / `admin`
- User: `user` / `user`

## Common Commands

```bash
# Run with auto-reload
uvicorn app.main:app --reload

# Run on different port
uvicorn app.main:app --port 8080

# Reset database
python init_db.py

# With Docker
docker-compose up -d          # Run in background
docker-compose logs -f api    # View logs
docker-compose down           # Stop
```

## Switching from Spring Boot

The FastAPI backend is **100% compatible** with your Flutter app. Just change the API URL from:

```dart
// From Spring Boot
final baseUrl = 'http://localhost:8080/api';

// To FastAPI
final baseUrl = 'http://localhost:8000/api';
```

All endpoints, request/response formats, and authentication are identical!

## Troubleshooting

**Database connection error?**
- Make sure PostgreSQL is running
- Check DATABASE_URL in `.env`

**Port already in use?**
- Change PORT in `.env` or use `--port 8080`

**Import errors?**
- Make sure you activated the virtual environment
- Run `pip install -r requirements.txt` again

## Next Steps

- Read the full [README.md](README.md)
- Check out the API docs at http://localhost:8000/docs
- Explore the code in `app/` directory
- Modify `.env` for your configuration
