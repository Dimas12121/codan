# Integrasi Flutter dengan Laravel Backend

## Konfigurasi Laravel untuk Flutter

### 1. Install Laravel CORS Package
```bash
composer require fruitcake/laravel-cors
```

### 2. Konfigurasi CORS di Laravel
Edit file `config/cors.php`:

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://localhost:8000',
        'http://10.0.2.2:8000',
        'http://localhost', // Untuk web
        'http://127.0.0.1', // Untuk iOS simulator
        'http://<IP_KOMPUTER>:8000', // Untuk physical device
    ],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

### 3. Middleware di Kernel
Pastikan di `app/Http/Kernel.php`:

```php
protected $middleware = [
    \Fruitcake\Cors\HandleCors::class,
    // ... middleware lainnya
];
```

## API Endpoint yang Dibutuhkan

### 1. Authentication Endpoints (Laravel Sanctum/Sanctum)
```php
// routes/api.php
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/user', [AuthController::class, 'user'])->middleware('auth:sanctum');
Route::post('/refresh-token', [AuthController::class, 'refreshToken']);
```

### 2. Response Format Laravel
```php
// Contoh response di Controller
return response()->json([
    'success' => true,
    'message' => 'Login successful',
    'data' => [
        'user' => $user,
        'access_token' => $token,
        'token_type' => 'Bearer',
        'expires_in' => 3600,
    ]
], 200);

// Error response
return response()->json([
    'success' => false,
    'message' => 'Validation failed',
    'errors' => $validator->errors()
], 422);
```

## Konfigurasi Flutter

### 1. Base URL
Sesuaikan di `lib/core/constants/app_constants.dart`:

```dart
// Untuk development
static const baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
// static const baseUrl = 'http://localhost:8000/api'; // iOS simulator & web
// static const baseUrl = 'http://192.168.1.100:8000/api'; // Physical device

// Untuk production
// static const baseUrl = 'https://api.domain-anda.com/api';
```

### 2. Testing Koneksi
Untuk testing koneksi, buat endpoint test di Laravel:

```php
// routes/api.php
Route::get('/test-connection', function() {
    return response()->json([
        'success' => true,
        'message' => 'Laravel API is working',
        'timestamp' => now(),
        'version' => '1.0.0'
    ]);
});
```

Lalu test dari Flutter:
```dart
final response = await dio.get('/test-connection');
print(response.data);
```

## Troubleshooting

### 1. Connection Refused
- Pastikan Laravel server running: `php artisan serve`
- Cek port: Default adalah 8000
- Untuk Android emulator: Gunakan `10.0.2.2` bukan `localhost`

### 2. CORS Errors
- Pastikan CORS package terinstall
- Clear cache: `php artisan config:clear`
- Restart Laravel server

### 3. SSL Certificate Errors (HTTPS)
Untuk development, tambahkan di `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">10.0.2.2</domain>
        <domain includeSubdomains="true">localhost</domain>
        <domain includeSubdomains="true">192.168.1.100</domain>
    </domain-config>
</network-security-config>
```

Dan di `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

## Best Practices

1. **Environment Variables**: Gunakan `.env` untuk konfigurasi URL
2. **Error Handling**: Implementasi error handling yang baik di kedua sisi
3. **Validation**: Validasi input di Laravel dan Flutter
4. **Security**: Gunakan HTTPS di production
5. **Testing**: Test API endpoints dengan Postman/Insomnia sebelum integrasi

## Contoh Laravel Controller

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => [
                    'user' => $user,
                    'access_token' => $token,
                    'token_type' => 'Bearer',
                ]
            ], 200);
        }

        return response()->json([
            'success' => false,
            'message' => 'Invalid credentials',
        ], 401);
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registration successful',
            'data' => [
                'user' => $user,
                'access_token' => $token,
                'token_type' => 'Bearer',
            ]
        ], 201);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout successful',
        ], 200);
    }

    public function user(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => $request->user(),
        ], 200);
    }
}
```