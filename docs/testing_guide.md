# Panduan Testing Koneksi Flutter-Laravel

## Masalah yang Telah Diperbaiki

### 1. **Type Error di `getCurrentUser()`**
**Masalah**: Method `getCurrentUser()` mengharapkan `Future<User?>` tetapi `remoteDataSource.getUser()` mengembalikan `Future<ApiResponse<User>>`.

**Solusi**: Memperbarui `AuthRepositoryImpl` untuk:
- Meng-extract data dari `ApiResponse<User>`
- Mengembalikan `User` jika `apiResponse.success == true`
- Mengembalikan `null` jika `apiResponse.success == false`
- Membersihkan token jika terjadi error

### 2. **Konsistensi API Response**
Semua method di `AuthRemoteDataSource` sekarang mengembalikan `ApiResponse<T>`:
- `login()` → `Future<ApiResponse<Map<String, dynamic>>>`
- `register()` → `Future<ApiResponse<Map<String, dynamic>>>`
- `logout()` → `Future<ApiResponse<void>>`
- `getUser()` → `Future<ApiResponse<User>>`

## Cara Testing Koneksi

### 1. **Test Connection Screen**
Gunakan screen yang sudah dibuat:
```dart
// Navigasi ke TestConnectionScreen
Navigator.push(context, MaterialPageRoute(
  builder: (context) => TestConnectionScreen(),
));
```

### 2. **Endpoint Test di Laravel**
Tambahkan endpoint test di Laravel `routes/api.php`:
```php
Route::get('/test-connection', function() {
    return response()->json([
        'success' => true,
        'message' => 'Laravel API is working',
        'data' => [
            'timestamp' => now(),
            'version' => app()->version(),
            'environment' => app()->environment(),
        ]
    ]);
});
```

### 3. **Run Laravel Server**
```bash
php artisan serve
```

### 4. **Test dari Flutter**
- Android Emulator: `http://10.0.2.2:8000/api/test-connection`
- iOS Simulator: `http://localhost:8000/api/test-connection`
- Web: `http://localhost:8000/api/test-connection`
- Physical Device: `http://<IP_KOMPUTER>:8000/api/test-connection`

## Troubleshooting

### 1. **Connection Refused**
- Pastikan Laravel server running: `php artisan serve`
- Cek port (default: 8000)
- Untuk Android emulator gunakan `10.0.2.2` bukan `localhost`

### 2. **CORS Errors**
```bash
# Install CORS package
composer require fruitcake/laravel-cors

# Konfigurasi di config/cors.php
'allowed_origins' => [
    'http://localhost:8000',
    'http://10.0.2.2:8000',
    'http://localhost',
    'http://127.0.0.1',
],

# Clear cache
php artisan config:clear
```

### 3. **Type Errors di Flutter**
Jika masih ada type errors:
1. Stop Flutter app
2. Clean build: `flutter clean`
3. Get packages: `flutter pub get`
4. Run: `flutter run`

## Struktur Response yang Diharapkan

### Login Success Response (Laravel)
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    },
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "token_type": "Bearer"
  }
}
```

### Get User Success Response
```json
{
  "success": true,
  "message": "User retrieved successfully",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Invalid credentials",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

## Next Steps

1. **Test koneksi dasar** dengan `TestConnectionScreen`
2. **Implementasi authentication flow** lengkap
3. **Add error handling** untuk berbagai skenario
4. **Implementasi refresh token** jika menggunakan JWT
5. **Add loading states** dan user feedback