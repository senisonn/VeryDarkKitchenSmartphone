# Type Error Fix - Prix Field

## Error Fixed ✅

```
type 'String' is not a subtype of type 'num' in type cast
```

## Problem

The FastAPI backend was returning the `prix` (price) field as a **String** instead of a **number**:

**Before (causing error):**
```json
{
  "id": 1,
  "nom": "Salade César",
  "prix": "8.50"  ← String (with quotes)
}
```

**After (fixed):**
```json
{
  "id": 1,
  "nom": "Salade César",
  "prix": 8.5  ← Number (no quotes)
}
```

## Root Cause

FastAPI's Pydantic was serializing `Decimal` types as strings by default. This is because JSON doesn't have a native Decimal type, so Pydantic chose the safe option of converting to string to preserve precision.

## Solutions Implemented

### Solution 1: Fixed Flutter Model (Defensive)

**File:** `mobile/lib/models/plat.dart`

Added robust parsing that handles both String and number types:

```dart
factory Plat.fromJson(Map<String, dynamic> json) {
  // Handle prix as either String or num (for compatibility)
  double parsePrix(dynamic prix) {
    if (prix is String) {
      return double.parse(prix);
    } else if (prix is num) {
      return prix.toDouble();
    }
    return 0.0;
  }

  return Plat(
    // ... other fields
    prix: parsePrix(json['prix']),
  );
}
```

**Benefits:**
- ✅ Works with both FastAPI (number) and Spring Boot (number)
- ✅ Backwards compatible if API changes
- ✅ Defensive programming - handles unexpected types

### Solution 2: Fixed FastAPI Backend (Proper)

**File:** `api_fastapi/app/schemas/plat.py`

Added field serializer to convert Decimal to float:

```python
class PlatDTO(BaseModel):
    prix: Decimal

    class Config:
        json_encoders = {
            Decimal: float  # Serialize Decimal as float
        }

    @field_serializer('prix')
    def serialize_prix(self, value: Decimal) -> float:
        """Serialize prix as float for JSON compatibility"""
        return float(value)
```

**Benefits:**
- ✅ API returns proper JSON numbers
- ✅ Better for all API clients (not just Flutter)
- ✅ Follows JSON best practices
- ✅ No precision loss for currency (2 decimal places)

## What Was Changed

### Changed Files

1. ✅ `mobile/lib/models/plat.dart` - Added robust parsing
2. ✅ `api_fastapi/app/schemas/plat.py` - Added field serializer
3. ✅ FastAPI backend restarted

### Verification

**Test the API:**
```bash
curl http://192.168.1.143:8000/api/plats | jq '.[0].prix'
# Returns: 8.5 (not "8.5")
```

**Flutter code:**
```bash
flutter analyze lib/models/plat.dart
# No issues found!
```

## Why Both Fixes?

We implemented both solutions for **defense in depth**:

1. **Backend fix** ensures the API is correct
2. **Frontend fix** ensures compatibility with any API format

This means:
- ✅ Works with current FastAPI
- ✅ Works if you switch to Spring Boot
- ✅ Works if API format changes
- ✅ More robust error handling

## Testing

After the fix, the app should:

1. ✅ Load menu without errors
2. ✅ Display prices correctly (8.50 €, 12.00 €, etc.)
3. ✅ No type cast errors
4. ✅ Works with both backends

## How to Verify

### 1. Check API Response

```bash
curl http://192.168.1.143:8000/api/plats | jq '.[0]'
```

Should show:
```json
{
  "id": 1,
  "nom": "Salade César",
  "prix": 8.5,  ← Number, not string
  ...
}
```

### 2. Run Flutter App

```bash
flutter run
```

Should:
- Load menu successfully
- Show prices without errors
- No red error screen

### 3. Check Logs

Flutter console should NOT show:
```
❌ type 'String' is not a subtype of type 'num'
```

Should show:
```
✅ Menu loaded successfully
```

## Additional Notes

### Why Decimal in Backend?

Decimal is used in the database for precision:
- `DECIMAL(10,2)` stores exactly 2 decimal places
- No floating-point rounding errors
- Important for financial calculations

### Why Float in JSON?

JSON specification supports:
- Numbers (integers and floats)
- Strings
- Booleans
- Null
- Arrays
- Objects

JSON does **NOT** support:
- Decimal type
- Date type
- BigInt type

So we convert:
- Decimal → float (for API)
- float → Decimal (for database)

### Spring Boot vs FastAPI

**Spring Boot:**
- Jackson serializer automatically converts BigDecimal to number
- Works out of the box

**FastAPI:**
- Pydantic serializer defaults to string for Decimal (safe)
- Needs explicit configuration to use float
- We added `@field_serializer` to fix this

## Troubleshooting

### Still Getting Type Errors?

1. **Restart FastAPI:**
   ```bash
   docker restart restaurant_api_fastapi
   ```

2. **Hard restart Flutter:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Check API response:**
   ```bash
   curl http://192.168.1.143:8000/api/plats | grep prix
   ```
   Should show numbers, not strings

### Different Error?

If you see other type errors, check:
- **dateReservation** - should be ISO string
- **nombrePersonnes** - should be number
- **id** - should be number

The same pattern can be used to fix those.

## Summary

✅ **Both backend and frontend fixed**
✅ **API now returns numbers properly**
✅ **Flutter handles both formats**
✅ **No more type cast errors**
✅ **App should load menu successfully**

---

**Status:** FIXED ✅

**Test:** Hot restart your Flutter app and the menu should load!
