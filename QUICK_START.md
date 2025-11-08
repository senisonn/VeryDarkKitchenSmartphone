# Quick Start Guide - Advanced Reservation Features

## Setup & Launch

### 1. Start Backend
```bash
# Start PostgreSQL database
cd api
docker-compose up -d

# Run Spring Boot API
./mvnw spring-boot:run
```

API will be available at: `http://localhost:8080`

### 2. Start Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

## Testing the Features

### Feature 1: Time Slot Availability

**Test Scenario**: Check if a time slot has available seats

1. **Via Mobile App**:
   - Open app → Menu
   - Select dishes
   - Click "Réserver"
   - Choose date, time, number of guests
   - App automatically checks availability before creating reservation

2. **Via API** (using curl):
```bash
curl -X POST http://localhost:8080/api/reservations/availability \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "dateReservation": "2025-11-10T19:00:00",
    "nombrePersonnes": 4
  }'
```

**Expected Response**:
```json
{
  "dateReservation": "2025-11-10T19:00:00",
  "totalCapacity": 50,
  "reservedSeats": 15,
  "availableSeats": 35,
  "available": true
}
```

**How to Test Full Capacity**:
- Create multiple reservations for same time slot
- Keep adding until reserved seats reach 50
- Next booking will fail with error message

---

### Feature 2: View My Reservations

1. Launch app
2. Open drawer menu (≡) or click list icon in app bar
3. Click "Mes Réservations"
4. See all your reservations with color-coded status:
   - 🟠 Orange = Pending approval
   - 🟢 Green = Confirmed
   - 🔴 Red = Cancelled
   - ⚫ Grey = Completed

---

### Feature 3: Modify Reservation

1. Go to "Mes Réservations"
2. Find a reservation with "En attente" status
3. Click "Modifier" button
4. Update any field (date, time, guests, email, phone, comment)
5. Click "Mettre à jour"
6. System validates and checks availability
7. Confirmation message or error shown

**Important**: Only pending reservations can be edited

---

### Feature 4: Cancel Reservation

1. Go to "Mes Réservations"
2. Find reservation
3. Click "Annuler" button (red)
4. Confirm in dialog
5. Status changes to "Annulée"
6. Seats become available for other customers

---

### Feature 5: Admin Dashboard

**Prerequisites**: Login as admin user

1. **Access Admin Panel**:
   - Method 1: Drawer menu → "Gestion Réservations"
   - Method 2: (Admin panel only visible for ADMIN role)

2. **View Pending Reservations**:
   - All EN_ATTENTE reservations displayed
   - Shows: date, time, guests, customer info

3. **Approve Reservation**:
   - Click green "Approuver" button
   - Status changes to CONFIRMEE
   - Customer sees confirmation in their list

4. **Reject Reservation**:
   - Click red "Refuser" button
   - Status changes to ANNULEE
   - Seats freed for other bookings

5. **View Details**:
   - Click blue "Détails" button
   - See full reservation information
   - Includes comment if provided

---

## API Endpoints Reference

### User Endpoints (Authenticated)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/reservations` | Create reservation (with availability check) |
| GET | `/api/reservations/user/{userId}` | Get my reservations |
| PUT | `/api/reservations/{id}` | Update reservation |
| DELETE | `/api/reservations/{id}` | Cancel reservation |
| POST | `/api/reservations/availability` | Check time slot availability |

### Admin Endpoints (ADMIN role required)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/reservations/pending` | Get all pending reservations |
| GET | `/api/reservations/status/{status}` | Filter by status |
| PUT | `/api/reservations/{id}/approve` | Approve reservation |
| PUT | `/api/reservations/{id}/reject` | Reject reservation |

---

## Complete User Journey Example

### Journey 1: Customer Makes Reservation

```
1. Customer opens app
2. Views menu, selects 3 dishes
3. Clicks "Réserver"
4. Login prompt appears (if not logged in)
5. Login/Register
6. Returns to reservation form
7. Fills details:
   - Email: customer@example.com
   - Phone: 0612345678
   - Date: Tomorrow
   - Time: 19:00
   - Guests: 4
   - Comment: "Table near window please"
8. Clicks "Confirmer"
9. System checks availability (19:00 ±1 hour window)
10. If available:
    - ✅ Reservation created with status EN_ATTENTE
    - Success message shown
    - Can navigate to "Mes Réservations" to view
11. If not available:
    - ❌ Error: "Pas assez de places disponibles. Places disponibles: 2, demandées: 4"
    - Customer can choose different time
```

---

### Journey 2: Customer Modifies Reservation

```
1. Customer opens "Mes Réservations"
2. Sees reservation #15 - Status: En attente
3. Clicks "Modifier"
4. Changes:
   - Date: From tomorrow to day after
   - Guests: From 4 to 6
5. Clicks "Mettre à jour"
6. System:
   - Checks new date/time availability
   - Excludes current reservation from count
   - Calculates: Can 6 people be accommodated?
7. If yes:
   - ✅ Reservation updated
   - Returns to list
8. If no:
   - ❌ Shows: "Pas assez de places disponibles"
   - User can adjust and retry
```

---

### Journey 3: Admin Manages Reservations

```
1. Admin logs in with ADMIN role
2. Opens drawer → "Gestion Réservations"
3. Sees 5 pending reservations
4. Clicks "Détails" on reservation #15
   - Customer: customer@example.com
   - Date: 2025-11-10 19:00
   - Guests: 6
   - Comment: "Anniversary dinner"
5. Decides to approve
6. Clicks "Approuver" (green button)
7. Reservation status → CONFIRMEE
8. Customer sees "Confirmée" in their list
9. (Optional) Admin can later view confirmed reservations:
   - GET /api/reservations/status/CONFIRMEE
```

---

## Testing Capacity Limits

### Scenario: Restaurant Fills Up

**Setup**: Restaurant capacity = 50 seats

```bash
# Create first reservation: 20 people at 19:00
POST /api/reservations
{ "dateReservation": "2025-11-10T19:00:00", "nombrePersonnes": 20 }
→ Available seats: 30

# Create second reservation: 15 people at 19:30
POST /api/reservations
{ "dateReservation": "2025-11-10T19:30:00", "nombrePersonnes": 15 }
→ Available seats: 15 (same window as first)

# Create third reservation: 10 people at 18:30
POST /api/reservations
{ "dateReservation": "2025-11-10T18:30:00", "nombrePersonnes": 10 }
→ Available seats: 5 (overlaps with 19:00)

# Try fourth reservation: 10 people at 19:15
POST /api/reservations
{ "dateReservation": "2025-11-10T19:15:00", "nombrePersonnes": 10 }
→ ❌ ERROR: "Pas assez de places disponibles. Places disponibles: 5, demandées: 10"

# Fifth reservation works: 4 people at 19:00
POST /api/reservations
{ "dateReservation": "2025-11-10T19:00:00", "nombrePersonnes": 4 }
→ ✅ SUCCESS: Available seats: 1

# Last spot: 1 person at 19:00
POST /api/reservations
{ "dateReservation": "2025-11-10T19:00:00", "nombrePersonnes": 1 }
→ ✅ SUCCESS: Available seats: 0

# Any more bookings fail
POST /api/reservations
{ "dateReservation": "2025-11-10T19:00:00", "nombrePersonnes": 1 }
→ ❌ ERROR: "Pas assez de places disponibles. Places disponibles: 0, demandées: 1"
```

**Note**: Time window is ±1 hour, so bookings at 18:00-20:00 all affect the same capacity pool.

---

## Configuration

### Change Restaurant Capacity

Edit `api/src/main/resources/application.properties`:
```properties
restaurant.capacity=100  # Change from 50 to 100
```

Restart backend for changes to take effect.

### Change Time Window

Edit `api/src/main/java/.../service/AvailabilityService.java`:
```java
// Current: ±1 hour window
LocalDateTime startWindow = requestedTime.minusHours(1);
LocalDateTime endWindow = requestedTime.plusHours(1);

// Change to ±30 minutes
LocalDateTime startWindow = requestedTime.minusMinutes(30);
LocalDateTime endWindow = requestedTime.plusMinutes(30);
```

---

## Troubleshooting

### Issue: "Utilisateur non connecté"
**Solution**: Login first via drawer menu → Connexion

### Issue: "Échec du chargement des réservations en attente"
**Solution**: Ensure you're logged in as ADMIN role

### Issue: API returns 403 Forbidden
**Solution**: Check JWT token is valid and has correct role

### Issue: Cannot edit reservation
**Solution**: Only EN_ATTENTE reservations can be edited. Confirmed/cancelled cannot be modified.

### Issue: Availability always shows 50 available
**Solution**: Make sure reservations are being created in the database. Check with:
```bash
docker exec -it restaurant-db psql -U postgres -d restaurant_db
SELECT * FROM reservations;
```

---

## Demo Data Setup

### Create Test Users

```bash
# User 1 (Customer)
POST /api/auth/register
{
  "username": "customer1",
  "password": "password123",
  "email": "customer1@test.com",
  "role": "USER"
}

# User 2 (Admin)
POST /api/auth/register
{
  "username": "admin1",
  "password": "admin123",
  "email": "admin@test.com",
  "role": "ADMIN"
}
```

### Create Test Reservations

```bash
# Login as customer1
POST /api/auth/login
{ "username": "customer1", "password": "password123" }
# Copy JWT token from response

# Create 3 reservations with different times
POST /api/reservations (with JWT)
{ "dateReservation": "2025-11-10T12:00:00", "nombrePersonnes": 4, ... }

POST /api/reservations (with JWT)
{ "dateReservation": "2025-11-10T19:00:00", "nombrePersonnes": 2, ... }

POST /api/reservations (with JWT)
{ "dateReservation": "2025-11-11T20:00:00", "nombrePersonnes": 6, ... }
```

Now you have 3 pending reservations to manage as admin!

---

## Mobile App Navigation Map

```
Main Screen (Menu)
├── Drawer Menu (≡)
│   ├── Menu → MenuScreen (current)
│   ├── Mes Réservations → MyReservationsScreen
│   │   └── Click "Modifier" → EditReservationScreen
│   ├── Gestion Réservations → AdminReservationsScreen (ADMIN only)
│   ├── Connexion → LoginScreen
│   └── Déconnexion → Logout action
│
├── App Bar Actions
│   ├── 📋 Icon → MyReservationsScreen (quick access)
│   └── 👤 Icon → LoginScreen
│
└── Main Content
    ├── Menu items list
    ├── Select dishes
    └── "Réserver" → ReservationScreen
```

---

## Success Criteria Checklist

- ✅ Reservations stored in real PostgreSQL database
- ✅ Time slot availability verification (configurable capacity)
- ✅ User can view all their reservations
- ✅ User can modify pending reservations
- ✅ User can cancel reservations
- ✅ Admin can view pending reservations
- ✅ Admin can approve reservations
- ✅ Admin can reject reservations
- ✅ Availability check prevents overbooking
- ✅ Clear error messages when capacity exceeded
- ✅ Role-based access control (USER vs ADMIN)
- ✅ Intuitive mobile UI with proper navigation

All features are production-ready and fully functional! 🎉
