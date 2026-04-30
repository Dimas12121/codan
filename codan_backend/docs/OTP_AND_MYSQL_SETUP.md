# OTP via WhatsApp dan MySQL Setup Guide

## 1. MySQL Database Setup

### Prerequisites:
- MySQL Server installed dan running
- Database `codean_db` dibuat

### Steps:

1. **Start MySQL Server**:
   ```bash
   # Windows (XAMPP/WAMP)
   # Start MySQL service dari XAMPP/WAMP Control Panel

   # Linux/Mac
   sudo systemctl start mysql
   # atau
   sudo service mysql start
   ```

2. **Create Database**:
   ```sql
   CREATE DATABASE codean_db;
   ```

3. **Update Laravel .env**:
   File `.env` sudah dikonfigurasi dengan:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=codean_db
   DB_USERNAME=root
   DB_PASSWORD=  # sesuaikan dengan password MySQL Anda
   ```

4. **Run Migrations**:
   ```bash
   cd codan_backend
   php artisan migrate
   ```

### Alternatif: Gunakan SQLite untuk Development
Jika MySQL belum tersedia, gunakan SQLite:
1. Update `.env`:
   ```env
   DB_CONNECTION=sqlite
   # Comment semua setting MySQL
   ```

2. Pastikan file `database/database.sqlite` ada

## 2. OTP via WhatsApp dengan Fonnte

### Prerequisites:
- Token Fonnte sudah dikonfigurasi di `.env`:
  ```env
  FONNTE_TOKEN=RsQpQtgS158S7AYMgyJr
  ```

### API Endpoints yang Tersedia:

#### 1. Send OTP via WhatsApp
```
POST /api/send-otp-whatsapp
```
**Request Body:**
```json
{
  "phone": "081234567890",
  "otp": "123456",
  "email": "user@example.com",
  "purpose": "register",
  "channel": "whatsapp",
  "provider": "fonnte"
}
```

#### 2. Verify OTP
```
POST /api/verify-otp
```
**Request Body:**
```json
{
  "phone": "081234567890",
  "otp": "123456",
  "purpose": "register"
}
```

#### 3. Check Phone Availability
```
POST /api/check-phone
```
**Request Body:**
```json
{
  "phone": "081234567890"
}
```

#### 4. Update Phone (Protected - requires authentication)
```
PUT /api/update-phone
```
**Headers:**
```
Authorization: Bearer {token}
```
**Request Body:**
```json
{
  "phone": "081234567890",
  "otp": "123456"
}
```

#### 5. Verify Phone (Protected - after OTP verification)
```
POST /api/verify-phone
```
**Headers:**
```
Authorization: Bearer {token}
```
**Request Body:**
```json
{
  "phone": "081234567890"
}
```

## 3. Database Schema Updates

### New Tables:
1. **otp_logs** - untuk menyimpan log pengiriman OTP
2. **New fields in users table**:
   - `is_phone_verified` (boolean)
   - `phone_verified_at` (timestamp)

### Migrations yang dibuat:
1. `2026_04_29_000000_create_otp_logs_table.php`
2. `2026_04_29_000001_add_phone_verification_to_users_table.php`

## 4. Flutter Integration

### AppConstants Update:
File `CODean/lib/core/constants/app_constants.dart` sudah diupdate dengan endpoint OTP:
```dart
// OTP Endpoints
static const sendOtpEndpoint = '/send-otp-whatsapp';
static const verifyOtpEndpoint = '/verify-otp';
static const checkPhoneEndpoint = '/check-phone';
static const updatePhoneEndpoint = '/update-phone';
```

### New Features di Flutter:
1. **Register dengan OTP Page** (`register_with_otp_page.dart`)
2. **OTP Service** (`otp_service.dart`)
3. **Phone field di Register Page** (`register_page.dart`)
4. **Updated AuthRepository** dengan method OTP

## 5. Testing OTP Flow

### Step-by-Step Testing:
1. **Register dengan OTP**:
   - Buka `/register-otp` di Flutter app
   - Isi form dengan nomor WhatsApp
   - Klik "Kirim OTP via WhatsApp"
   - Cek WhatsApp untuk OTP
   - Masukkan OTP dan verifikasi
   - User akan diregister secara otomatis

2. **Register biasa dengan phone**:
   - Buka `/register` di Flutter app
   - Isi form (phone optional)
   - User dibuat tanpa verifikasi phone

3. **Update phone dengan OTP**:
   - Login terlebih dahulu
   - Kirim OTP ke nomor baru
   - Verifikasi OTP
   - Update phone number

## 6. Troubleshooting

### MySQL Connection Error:
```
SQLSTATE[HY000] [2002] No connection could be made because the target machine actively refused it
```
**Solution:**
- Pastikan MySQL server running
- Cek port 3306 tidak diblok firewall
- Update `.env` dengan kredensial yang benar

### Fonnte API Error:
```
Gagal mengirim OTP: [error message]
```
**Solution:**
- Cek `FONNTE_TOKEN` di `.env`
- Pastikan token valid di Fonnte dashboard
- Cek saldo Fonnte (jika menggunakan paid plan)

### OTP Not Received:
- Cek nomor WhatsApp sudah benar
- Pastikan nomor aktif dan bisa menerima pesan
- Cek spam folder di WhatsApp
- Tunggu beberapa menit (kadang delay)

## 7. Security Considerations

1. **Rate Limiting**: OTP memiliki limit 5 attempts per 30 menit
2. **Expiration**: OTP berlaku 5 menit
3. **Verification Cache**: OTP verified cache 10 menit
4. **Audit Trail**: Semua pengiriman OTP dicatat di `otp_logs`
5. **Phone Validation**: Format nomor Indonesia (+62) diverifikasi

## 8. Deployment Notes

### Production:
1. Update `FONNTE_TOKEN` dengan token production
2. Set `APP_ENV=production` di `.env`
3. Enable SSL untuk API endpoints
4. Setup proper MySQL credentials
5. Configure Redis untuk cache (optional)

### Development:
1. Gunakan SQLite untuk development cepat
2. Mock Fonnte API untuk testing
3. Gunakan nomor testing untuk OTP