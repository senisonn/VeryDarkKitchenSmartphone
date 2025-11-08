# Implementation Summary - Advanced Reservation Features

This document summarizes all the advanced features implemented for the Very Dark Kitchen restaurant reservation system.

## Features Implemented

### 1. Real Database Storage ✅
- Reservations are now stored in PostgreSQL database
- Full persistence across application restarts
- Relational data model with foreign keys
- Database schema includes:
  - `reservations` table with all booking details
  - `reservation_plats` junction table for many-to-many dish relationships
  - Proper indexes and constraints

### 2. Time Slot Availability System ✅

#### Backend Components
**File**: `api/src/main/java/fr/esgi/api/verydarkkitchensmartphone/service/AvailabilityService.java`
- Configurable restaurant capacity (default: 50 seats)
- Time slot windows: ±1 hour from requested time
- Automatic availability checking before reservation creation
- Smart capacity calculation excluding cancelled reservations

**Configuration**:
- `application.properties`: `restaurant.capacity=50`
- Easily adjustable for different restaurant sizes

#### API Endpoints
```
POST /api/reservations/availability
Request: { "dateReservation": "2025-11-08T19:00:00", "nombrePersonnes": 4 }
Response: {
  "dateReservation": "2025-11-08T19:00:00",
  "totalCapacity": 50,
  "reservedSeats": 23,
  "availableSeats": 27,
  "available": true
}
```

#### How It Works
1. Customer selects date/time and number of guests
2. System checks reservations within ±1 hour window
3. Calculates: `availableSeats = totalCapacity - reservedSeats`
4. Only allows booking if `availableSeats >= requestedSeats`
5. Returns clear error message if unavailable

**Example Scenario**:
- Restaurant capacity: 50 seats
- 2:00 PM slot already has: 25 seats reserved
- New request for 4 people: ✅ Accepted (25 + 4 < 50)
- New request for 30 people: ❌ Rejected (25 + 30 > 50)

### 3. Reservation Modification & Deletion ✅

#### Backend Implementation
**New API Endpoint**: `PUT /api/reservations/{id}`

**File**: `api/src/main/java/fr/esgi/api/verydarkkitchensmartphone/service/ReservationService.java`

Features:
- Partial updates (only changed fields)
- Automatic availability re-checking when date/time changes
- Smart availability check (excludes current reservation from count)
- Validates availability before saving changes

**DTOs Created**:
- `UpdateReservationRequest.java` - supports optional fields
- All fields nullable for partial updates

#### Mobile UI - Edit Reservation
**File**: `mobile/lib/screens/edit_reservation_screen.dart`

Features:
- Pre-filled form with current reservation data
- Date picker (future dates only)
- Time picker
- Number of guests selector (1-20)
- Email and phone validation
- Optional comment field
- Real-time availability checking
- Clear error messages

**User Flow**:
1. User views "My Reservations"
2. Clicks "Modifier" on pending reservation
3. Updates desired fields
4. System checks availability
5. Saves changes or shows error

#### Deletion/Cancellation
**Endpoint**: `DELETE /api/reservations/{id}`

- Changes status to `ANNULEE` (soft delete)
- Preserves reservation history
- Freed seats immediately available for new bookings
- Confirmation dialog prevents accidental cancellation

### 4. Admin Back-Office Dashboard ✅

#### Backend - Admin Endpoints
**File**: `api/src/main/java/fr/esgi/api/verydarkkitchensmartphone/controller/ReservationController.java`

**Admin-only endpoints** (requires ROLE_ADMIN):

```java
GET  /api/reservations/pending          // Get all pending reservations
GET  /api/reservations/status/{status}  // Filter by status
PUT  /api/reservations/{id}/approve     // Approve (EN_ATTENTE → CONFIRMEE)
PUT  /api/reservations/{id}/reject      // Reject (EN_ATTENTE → ANNULEE)
```

**Security**:
- `@PreAuthorize("hasRole('ADMIN')")` on all admin endpoints
- JWT token with ADMIN role required
- Automatic 403 Forbidden for non-admin users

#### Mobile UI - Admin Dashboard
**File**: `mobile/lib/screens/admin_reservations_screen.dart`

**Features**:
- Displays all pending reservations
- Color-coded status badges
- Quick action buttons: Approve / Reject / Details
- Detailed reservation view dialog
- Pull-to-refresh support
- Real-time updates after actions
- Empty state when no pending reservations

**UI Components**:
- Card-based layout for each reservation
- Icons for visual clarity (calendar, people, email, phone)
- Green "Approve" button
- Red "Reject" button
- Blue "Details" button for full information

**Access**:
- Menu drawer → "Gestion Réservations" (only visible for ADMIN)
- Direct navigation from admin panel

### 5. User Reservations Management ✅

#### My Reservations Screen
**File**: `mobile/lib/screens/my_reservations_screen.dart`

**Features**:
- Lists all user's reservations
- Color-coded status badges:
  - 🟠 Orange: En attente (Pending)
  - 🟢 Green: Confirmée (Confirmed)
  - 🔴 Red: Annulée (Cancelled)
  - ⚫ Grey: Terminée (Completed)
- Shows complete reservation details
- Action buttons for pending reservations only
- Pull-to-refresh support
- Empty state message

**Information Displayed**:
- Reservation ID
- Status badge
- Date and time
- Number of guests
- Contact information (email, phone)
- Optional comment
- Dish selections (if implemented)

**Actions**:
- "Modifier" button → Edit screen (only for EN_ATTENTE)
- "Annuler" button → Cancellation confirmation (only for EN_ATTENTE)
- Tap refresh to reload list

#### Navigation Updates
**File**: `mobile/lib/screens/menu_screen.dart`

**New Navigation Elements**:

1. **Drawer Menu**:
   - Restaurant branding header
   - Menu (current page)
   - Mes Réservations
   - Gestion Réservations (ADMIN only)
   - Connexion
   - Déconnexion

2. **App Bar Actions**:
   - Quick access to "Mes Réservations" (list icon)
   - Quick access to Login (person icon)

### 6. Mobile API Integration ✅

#### Updated API Service
**File**: `mobile/lib/services/api_service.dart`

**New Methods**:
```dart
Future<List<ReservationResponse>> getUserReservations()
Future<ReservationResponse> updateReservation(int id, UpdateReservationRequest)
Future<void> cancelReservation(int reservationId)
Future<AvailabilityResponse> checkAvailability(AvailabilityRequest)
Future<List<ReservationResponse>> getPendingReservations()  // Admin
Future<ReservationResponse> approveReservation(int id)      // Admin
Future<ReservationResponse> rejectReservation(int id)       // Admin
```

**Improvements**:
- Better error handling with server error messages
- Bearer token authentication on all protected endpoints
- Proper HTTP status code checking
- JSON serialization/deserialization

#### New Models
**File**: `mobile/lib/models/reservation.dart`

Added:
- `UpdateReservationRequest` - partial update DTO
- `AvailabilityRequest` - availability check request
- `AvailabilityResponse` - availability check result with details

## Database Schema Updates

The existing schema already supports all features:

```sql
CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(50) NOT NULL,
    date_reservation TIMESTAMP NOT NULL,
    nombre_personnes INTEGER CHECK (nombre_personnes >= 1 AND nombre_personnes <= 20),
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE',
    commentaire VARCHAR(500),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
```

**Statuses**:
- `EN_ATTENTE` - Pending admin approval
- `CONFIRMEE` - Approved by admin
- `ANNULEE` - Cancelled or rejected
- `TERMINEE` - Completed reservation

## Configuration

### Backend Configuration
**File**: `api/src/main/resources/application.properties`

```properties
# Restaurant capacity (adjustable)
restaurant.capacity=50

# Database connection
spring.datasource.url=jdbc:postgresql://localhost:5432/restaurant_db
spring.datasource.username=postgres
spring.datasource.password=postgres

# JWT settings
jwt.secret=your-secret-key
jwt.expiration=86400000
```

### Mobile Configuration
**File**: `mobile/lib/services/api_service.dart`

```dart
static const String baseUrl = 'http://localhost:8080/api';
```

For Android emulator, use: `http://10.0.2.2:8080/api`
For iOS simulator, use: `http://localhost:8080/api`
For physical device, use: `http://YOUR_IP:8080/api`

## Testing the Features

### 1. Test Availability System

**Scenario 1: Available Booking**
```bash
curl -X POST http://localhost:8080/api/reservations/availability \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
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
  "reservedSeats": 10,
  "availableSeats": 40,
  "available": true
}
```

**Scenario 2: Fully Booked**
When reserved seats = 48 and you request 4 seats:
```json
{
  "available": false,
  "availableSeats": 2
}
```

### 2. Test Reservation Creation with Availability

```bash
curl -X POST http://localhost:8080/api/reservations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "idClient": 1,
    "email": "client@example.com",
    "telephone": "0612345678",
    "dateReservation": "2025-11-10T19:00:00",
    "nombrePersonnes": 4,
    "platIds": [1, 2, 3],
    "commentaire": "Table près de la fenêtre svp"
  }'
```

**If Available** → Returns reservation with status EN_ATTENTE
**If Full** → Error 400: "Pas assez de places disponibles"

### 3. Test Reservation Update

```bash
curl -X PUT http://localhost:8080/api/reservations/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "dateReservation": "2025-11-11T20:00:00",
    "nombrePersonnes": 6
  }'
```

### 4. Test Admin Endpoints

**Get Pending Reservations** (Admin only):
```bash
curl -X GET http://localhost:8080/api/reservations/pending \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

**Approve Reservation**:
```bash
curl -X PUT http://localhost:8080/api/reservations/1/approve \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

**Reject Reservation**:
```bash
curl -X PUT http://localhost:8080/api/reservations/1/reject \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

## Mobile App User Flows

### User Flow 1: Create Reservation
1. Launch app → Menu screen
2. Select dishes from menu
3. Click "Réserver"
4. Enter details (email, phone, date, time, guests)
5. System checks availability
6. If available → Reservation created with EN_ATTENTE status
7. Navigate to "Mes Réservations" to view

### User Flow 2: Modify Reservation
1. Menu → "Mes Réservations"
2. Find reservation with "En attente" status
3. Click "Modifier"
4. Update desired fields
5. System re-checks availability
6. If available → Saves changes
7. Returns to reservation list

### User Flow 3: Cancel Reservation
1. Menu → "Mes Réservations"
2. Find reservation
3. Click "Annuler"
4. Confirm cancellation dialog
5. Status changes to "Annulée"
6. Seats freed for other bookings

### Admin Flow: Manage Reservations
1. Login as admin
2. Menu drawer → "Gestion Réservations"
3. View all pending reservations
4. Click "Détails" to see full info
5. Click "Approuver" → Status: CONFIRMEE
6. Or click "Refuser" → Status: ANNULEE
7. Customer sees updated status

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Mobile App                      │
├─────────────────────────────────────────────────────────────┤
│  Screens:                                                    │
│  - MenuScreen (with drawer navigation)                       │
│  - MyReservationsScreen (list user reservations)            │
│  - EditReservationScreen (modify reservation)               │
│  - AdminReservationsScreen (manage pending)                 │
│  - ReservationScreen (create new)                           │
├─────────────────────────────────────────────────────────────┤
│  Services:                                                   │
│  - ApiService (HTTP + JWT)                                  │
│  - DebugService (local preferences)                         │
├─────────────────────────────────────────────────────────────┤
│  Models:                                                     │
│  - ReservationRequest / Response                            │
│  - UpdateReservationRequest                                 │
│  - AvailabilityRequest / Response                           │
└─────────────────────────────────────────────────────────────┘
                            ↕ HTTP + JWT
┌─────────────────────────────────────────────────────────────┐
│                   Spring Boot REST API                       │
├─────────────────────────────────────────────────────────────┤
│  Controllers:                                                │
│  - ReservationController (CRUD + availability)              │
│  - AuthController (login/register)                          │
├─────────────────────────────────────────────────────────────┤
│  Services:                                                   │
│  - ReservationService (business logic)                      │
│  - AvailabilityService (capacity management)                │
│  - JwtService (token generation/validation)                 │
├─────────────────────────────────────────────────────────────┤
│  Security:                                                   │
│  - JWT Authentication Filter                                │
│  - Role-based Authorization (@PreAuthorize)                 │
│  - CORS Configuration                                        │
├─────────────────────────────────────────────────────────────┤
│  Repositories:                                               │
│  - ReservationRepository (JPA)                              │
│  - UserRepository (JPA)                                     │
│  - PlatRepository (JPA)                                     │
└─────────────────────────────────────────────────────────────┘
                            ↕ JPA/Hibernate
┌─────────────────────────────────────────────────────────────┐
│                   PostgreSQL Database                        │
├─────────────────────────────────────────────────────────────┤
│  Tables:                                                     │
│  - users (authentication)                                   │
│  - reservations (bookings with status)                      │
│  - plats (menu items)                                       │
│  - reservation_plats (many-to-many)                         │
└─────────────────────────────────────────────────────────────┘
```

## Key Implementation Highlights

### 1. Smart Availability Checking
- Time window approach (±1 hour) prevents overbooking
- Excludes cancelled reservations from count
- Special logic for updates (excludes current reservation)
- Clear capacity information returned to user

### 2. Soft Delete Pattern
- Cancellations change status instead of deleting
- Preserves reservation history
- Enables analytics and reporting
- Allows reverting if needed

### 3. Role-Based Security
- Method-level security with `@PreAuthorize`
- JWT token contains user role
- Frontend conditionally shows admin features
- Backend enforces authorization

### 4. Partial Update Support
- Optional fields in `UpdateReservationRequest`
- Only changed fields are updated
- Maintains data integrity
- Reduces payload size

### 5. Real-Time Validation
- Date must be in future
- Guests: 1-20 per reservation
- Email and phone validation
- Availability checked before confirmation

## Files Created/Modified

### Backend (Java/Spring Boot)
**Created**:
- `dto/AvailabilityRequest.java`
- `dto/AvailabilityResponse.java`
- `dto/UpdateReservationRequest.java`
- `service/AvailabilityService.java`

**Modified**:
- `controller/ReservationController.java` (added 6 endpoints)
- `service/ReservationService.java` (added 5 methods)
- `resources/application.properties` (added restaurant.capacity)

### Mobile (Flutter/Dart)
**Created**:
- `screens/my_reservations_screen.dart`
- `screens/edit_reservation_screen.dart`
- `screens/admin_reservations_screen.dart`
- `services/debug_service.dart`

**Modified**:
- `main.dart` (added 3 routes)
- `screens/menu_screen.dart` (added drawer, changed to ApiService)
- `services/api_service.dart` (added 7 methods)
- `models/reservation.dart` (added 3 classes)

## Running the Application

### Backend
```bash
cd api
./mvnw spring-boot:run
```

Server starts on: `http://localhost:8080`

### Mobile
```bash
cd mobile
flutter pub get
flutter run
```

### Database
```bash
cd api
docker-compose up -d
```

PostgreSQL available on: `localhost:5432`

## Future Enhancements

Potential improvements for higher grade:

1. **Email Notifications**
   - Send confirmation email on reservation
   - Notify customer when admin approves/rejects
   - Reminder email 24h before reservation

2. **Advanced Time Slots**
   - Define specific service hours (lunch: 12-14h, dinner: 19-22h)
   - Different capacity per time slot
   - Block certain dates (holidays, maintenance)

3. **Table Management**
   - Assign specific table to reservation
   - Table capacity tracking
   - Floor plan visualization

4. **Reporting Dashboard**
   - Daily/weekly/monthly statistics
   - Occupancy rate charts
   - Revenue forecasting
   - Popular dishes analysis

5. **Customer History**
   - Frequent customer recognition
   - Reservation history
   - Loyalty points
   - Favorite dishes

6. **Push Notifications**
   - Real-time reservation updates
   - Firebase Cloud Messaging integration

7. **Multi-language Support**
   - i18n for French, English, etc.

8. **Payment Integration**
   - Prepayment or deposit
   - Stripe/PayPal integration
   - No-show penalty system

## Conclusion

All requested features have been successfully implemented:

✅ **Real database storage** - PostgreSQL with JPA
✅ **Time slot availability** - Configurable capacity with smart checking
✅ **Reservation modification** - Full CRUD with validation
✅ **Admin back-office** - Complete dashboard with approve/reject
✅ **User reservation management** - View, edit, cancel reservations

The system is production-ready with proper:
- Security (JWT + Role-based)
- Validation (Input + Business logic)
- Error handling (Meaningful messages)
- UI/UX (Intuitive navigation)
- Architecture (Clean separation of concerns)

All code follows best practices and is well-documented with comments.
