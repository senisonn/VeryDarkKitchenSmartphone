#!/bin/bash

# Simple script to test the FastAPI backend
# Run this after starting the server to verify it's working

echo "======================================"
echo "Testing FastAPI Restaurant API"
echo "======================================"
echo ""

BASE_URL="http://localhost:8000"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Health check
echo -e "${YELLOW}[1/6] Testing health endpoint...${NC}"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/health")
if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓ Health check passed${NC}"
else
    echo -e "${RED}✗ Health check failed (HTTP $response)${NC}"
    exit 1
fi
echo ""

# Test 2: Get menu
echo -e "${YELLOW}[2/6] Testing menu endpoint (GET /api/plats)...${NC}"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/plats")
if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓ Menu endpoint working${NC}"
    dishes=$(curl -s "$BASE_URL/api/plats" | grep -o '"id"' | wc -l)
    echo "  Found $dishes dishes"
else
    echo -e "${RED}✗ Menu endpoint failed (HTTP $response)${NC}"
fi
echo ""

# Test 3: Login
echo -e "${YELLOW}[3/6] Testing login endpoint (POST /api/auth/login)...${NC}"
login_response=$(curl -s -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin"}')

token=$(echo "$login_response" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -n "$token" ]; then
    echo -e "${GREEN}✓ Login successful${NC}"
    echo "  Token: ${token:0:30}..."
else
    echo -e "${RED}✗ Login failed${NC}"
    echo "  Response: $login_response"
    exit 1
fi
echo ""

# Test 4: Create reservation (requires auth)
echo -e "${YELLOW}[4/6] Testing create reservation (POST /api/reservations)...${NC}"

# Get current date + 2 days for reservation
reservation_date=$(date -u -v+2d +"%Y-%m-%dT19:00:00" 2>/dev/null || date -u -d "+2 days" +"%Y-%m-%dT19:00:00" 2>/dev/null || echo "2025-12-01T19:00:00")

reservation_response=$(curl -s -X POST "$BASE_URL/api/reservations" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "{
        \"idClient\": 1,
        \"email\": \"test@example.com\",
        \"telephone\": \"0123456789\",
        \"dateReservation\": \"$reservation_date\",
        \"nombrePersonnes\": 4,
        \"platIds\": [1, 2],
        \"commentaire\": \"Test reservation from script\"
    }")

reservation_id=$(echo "$reservation_response" | grep -o '"id":[0-9]*' | cut -d':' -f2)

if [ -n "$reservation_id" ]; then
    echo -e "${GREEN}✓ Reservation created${NC}"
    echo "  Reservation ID: $reservation_id"
else
    echo -e "${RED}✗ Reservation creation failed${NC}"
    echo "  Response: $reservation_response"
fi
echo ""

# Test 5: Get user reservations
echo -e "${YELLOW}[5/6] Testing get reservations (GET /api/reservations/user/1)...${NC}"
response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/reservations/user/1" \
    -H "Authorization: Bearer $token")

if [ "$response" = "200" ]; then
    echo -e "${GREEN}✓ Get reservations successful${NC}"
    count=$(curl -s "$BASE_URL/api/reservations/user/1" -H "Authorization: Bearer $token" | grep -o '"id"' | wc -l)
    echo "  Found $count reservations for user"
else
    echo -e "${RED}✗ Get reservations failed (HTTP $response)${NC}"
fi
echo ""

# Test 6: Check availability
echo -e "${YELLOW}[6/6] Testing availability check (POST /api/reservations/availability)...${NC}"
availability_response=$(curl -s -X POST "$BASE_URL/api/reservations/availability" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d "{
        \"dateReservation\": \"$reservation_date\",
        \"nombrePersonnes\": 2
    }")

available=$(echo "$availability_response" | grep -o '"available":[a-z]*' | cut -d':' -f2)

if [ "$available" = "true" ] || [ "$available" = "false" ]; then
    echo -e "${GREEN}✓ Availability check successful${NC}"
    echo "  Available: $available"
    seats=$(echo "$availability_response" | grep -o '"availableSeats":[0-9]*' | cut -d':' -f2)
    echo "  Available seats: $seats"
else
    echo -e "${RED}✗ Availability check failed${NC}"
    echo "  Response: $availability_response"
fi
echo ""

# Summary
echo "======================================"
echo -e "${GREEN}All tests completed!${NC}"
echo "======================================"
echo ""
echo "API Documentation available at:"
echo "  - Swagger UI: $BASE_URL/docs"
echo "  - ReDoc: $BASE_URL/redoc"
echo ""
echo "Default credentials:"
echo "  - Admin: admin/admin"
echo "  - User: user/user"
echo ""
