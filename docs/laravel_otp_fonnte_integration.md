# Integrasi OTP WhatsApp dengan Fonnte di Laravel

**Status: Sudah Diimplementasikan ✅**

## 1. **Konfigurasi Fonnte di Laravel**

### Sudah dikonfigurasi di `.env`
```env
FONNTE_TOKEN=RsQpQtgS158S7AYMgyJr
```

### Tidak perlu install package tambahan
Gunakan Laravel HTTP Client bawaan (sudah tersedia)

## 2. **Controller OTP yang Sudah Dibuat**

### `codan_backend/app/Http/Controllers/Api/OTPController.php`
Controller sudah dibuat dengan fitur lengkap:
- Send OTP via WhatsApp menggunakan Fonnte
- Verify OTP dengan cache expiration
- Check phone availability
- Update phone dengan OTP verification
- Rate limiting (5 attempts per 30 menit)
- Audit trail dengan OTPLog

## 3. **Model dan Migration yang Sudah Dibuat**

### 1. OTPLog Model (`codan_backend/app/Models/OTPLog.php`)
Untuk menyimpan log pengiriman OTP

### 2. Migration OTP Logs (`codan_backend/database/migrations/2026_04_29_000000_create_otp_logs_table.php`)
```php
Schema::create('otp_logs', function (Blueprint $table) {
    $table->id();
    $table->string('phone', 20);
    $table->string('otp', 6);
    $table->enum('purpose', ['register', 'login', 'reset_password', 'update_phone']);
    $table->enum('channel', ['whatsapp', 'sms']);
    $table->enum('provider', ['fonnte']);
    $table->enum('status', ['sent', 'failed', 'error']);
    $table->json('response')->nullable();
    $table->timestamps();
});
```

### 3. Phone Verification Fields (`codan_backend/database/migrations/2026_04_29_000001_add_phone_verification_to_users_table.php`)
```php
Schema::table('users', function (Blueprint $table) {
    $table->boolean('is_phone_verified')->default(false)->after('phone');
    $table->timestamp('phone_verified_at')->nullable()->after('is_phone_verified');
});
```

## 4. **Routes yang Sudah Ditambahkan**

### `codan_backend/routes/api.php`
```php
// OTP Routes
Route::post('/send-otp-whatsapp', [OTPController::class, 'sendOTPviaWhatsApp']);
Route::post('/verify-otp', [OTPController::class, 'verifyOTP']);
Route::post('/check-phone', [OTPController::class, 'checkPhoneAvailability']);

Route::middleware('auth:sanctum')->group(function () {
    // OTP Protected Routes
    Route::put('/update-phone', [OTPController::class, 'updatePhone']);
    Route::post('/verify-phone', [AuthController::class, 'verifyPhone']);
});
```

## 5. **MySQL Database Configuration**

### Sudah dikonfigurasi di `.env`
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=codean_db
DB_USERNAME=root
DB_PASSWORD=
```

## 6. **Flutter Integration**

### AppConstants Update (`CODean/lib/core/constants/app_constants.dart`)
```dart
// OTP Endpoints
static const sendOtpEndpoint = '/send-otp-whatsapp';
static const verifyOtpEndpoint = '/verify-otp';
static const checkPhoneEndpoint = '/check-phone';
static const updatePhoneEndpoint = '/update-phone';
```

### Fitur yang Sudah Diimplementasikan:
1. **RegisterWithOTPPage** (`register_with_otp_page.dart`) - Halaman registrasi dengan OTP WhatsApp
2. **OTPService** (`otp_service.dart`) - Service untuk generate, validate, dan manage OTP
3. **Phone field di RegisterPage** (`register_page.dart`) - Field telepon opsional
4. **Updated AuthRepository** dengan method OTP
5. **Updated AuthRemoteDataSource** dengan API calls untuk OTP

## 7. **Testing OTP Flow**

### Step-by-Step Testing:
1. **Start Laravel Server**:
   ```bash
   cd codan_backend
   php artisan serve
   ```

2. **Run Migrations**:
   ```bash
   php artisan migrate
   ```

3. **Test dengan Flutter**:
   - Buka Flutter app
   - Navigasi ke `/register-otp`
   - Isi form dengan nomor WhatsApp
   - Klik "Kirim OTP via WhatsApp"
   - Cek WhatsApp untuk OTP
   - Masukkan OTP dan verifikasi
   - User akan diregister secara otomatis

## 8. **API Endpoints**

### 1. Send OTP via WhatsApp
```
POST /api/send-otp-whatsapp
```
**Request:**
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

### 2. Verify OTP
```
POST /api/verify-otp
```
**Request:**
```json
{
  "phone": "081234567890",
  "otp": "123456",
  "purpose": "register"
}
```

### 3. Check Phone Availability
```
POST /api/check-phone
```
**Request:**
```json
{
  "phone": "081234567890"
}
```

### 4. Update Phone (Protected)
```
PUT /api/update-phone
```
**Headers:** `Authorization: Bearer {token}`
**Request:**
```json
{
  "phone": "081234567890",
  "otp": "123456"
}
```

### 5. Verify Phone (Protected)
```
POST /api/verify-phone
```
**Headers:** `Authorization: Bearer {token}`
**Request:**
```json
{
  "phone": "081234567890"
}
```

## 9. **Security Features**

1. **OTP Expiration**: 5 menit
2. **Max Attempts**: 5 percobaan per OTP
3. **Rate Limiting**: Cache-based rate limiting
4. **Verified Cache**: OTP verified cache 10 menit
5. **Audit Trail**: Semua OTP attempts dicatat di database
6. **Phone Validation**: Format nomor Indonesia (+62)

## 10. **Troubleshooting**

### MySQL Connection Error:
```
SQLSTATE[HY000] [2002] No connection could be made because the target machine actively refused it
```
**Solution:**
- Pastikan MySQL server running
- Cek port 3306 tidak diblok firewall
- Untuk development cepat, gunakan SQLite:
  ```env
  DB_CONNECTION=sqlite
  # Comment semua setting MySQL
  ```

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

## 11. **Deployment Notes**

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

## 12. **File yang Sudah Diupdate**

### Laravel Backend:
1. `codan_backend/.env` - MySQL & Fonnte configuration
2. `codan_backend/app/Http/Controllers/Api/OTPController.php` - OTP controller
3. `codan_backend/app/Http/Controllers/Api/AuthController.php` - Updated auth controller
4. `codan_backend/app/Models/OTPLog.php` - OTP log model
5. `codan_backend/app/Models/User.php` - Updated user model
6. `codan_backend/routes/api.php` - Added OTP routes
7. `codan_backend/database/migrations/2026_04_29_000000_create_otp_logs_table.php` - OTP logs migration
8. `codan_backend/database/migrations/2026_04_29_000001_add_phone_verification_to_users_table.php` - Phone verification migration
9. `codan_backend/docs/OTP_AND_MYSQL_SETUP.md` - Setup documentation

### Flutter App:
1. `CODean/lib/core/constants/app_constants.dart` - Added OTP endpoints
2. `CODean/lib/features/auth/data/repositories/auth_repository_impl.dart` - OTP methods
3. `CODean/lib/features/auth/data/datasources/auth_remote_data_source.dart` - OTP API calls
4. `CODean/lib/features/auth/presentation/pages/register_with_otp_page.dart` - OTP registration page
5. `CODean/lib/features/auth/presentation/pages/register_page.dart` - Added phone field
6. `CODean/lib/features/auth/presentation/services/otp_service.dart` - OTP service
7. `CODean/lib/features/auth/presentation/providers/auth_provider.dart` - Fixed provider
8. `CODean/lib/features/auth/domain/repositories/auth_repository.dart` - OTP interface
9. `CODean/lib/features/auth/domain/entities/user.dart` - Added phone fields
10. `CODean/lib/main.dart` - Cleaned imports

**Implementasi sudah selesai dan siap untuk testing!**