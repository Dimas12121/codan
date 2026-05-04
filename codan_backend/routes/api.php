<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProdukController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\OfferController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\WishlistController;
use App\Http\Controllers\Api\MessageController;
use App\Http\Controllers\Api\OTPController;
use App\Http\Controllers\Api\HealthController;

// Health Routes
Route::get('/health', [HealthController::class, 'index']);
Route::get('/health/db', [HealthController::class, 'dbCheck']);
Route::get('/health/api', [HealthController::class, 'apiStatus']);

// Auth Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/register-with-phone', [AuthController::class, 'registerWithPhone']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/login-phone', [AuthController::class, 'loginPhone']);

// OTP Routes
Route::post('/send-otp-whatsapp', [OTPController::class, 'sendOTPviaWhatsApp']);
Route::post('/verify-otp', [OTPController::class, 'verifyOTP']);
Route::post('/check-phone', [OTPController::class, 'checkPhoneAvailability']);

Route::middleware('auth:sanctum')->group(function () {
    // Profile Routes
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/profile/update', [AuthController::class, 'updateProfile']);
    Route::post('/profile/change-password', [AuthController::class, 'changePassword']);
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // OTP Protected Routes
    Route::put('/update-phone', [OTPController::class, 'updatePhone']);
    Route::post('/verify-phone', [AuthController::class, 'verifyPhone']);
    
    // Protected Produk Routes
    Route::get('/produks/my', [ProdukController::class, 'myproduks']);
    Route::post('/produks', [ProdukController::class, 'store']);
    Route::patch('/produks/{id}', [ProdukController::class, 'update']);
    Route::patch('/produks/{id}/status', [ProdukController::class, 'updateStatus']);
    Route::delete('/produks/{id}', [ProdukController::class, 'destroy']);

    // Notification Routes
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/unread-count', [NotificationController::class, 'unreadCount']);
    Route::patch('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::post('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);

    // Offer Routes
    Route::get('/offers', [OfferController::class, 'index']);
    Route::post('/offers', [OfferController::class, 'store']);
    Route::patch('/offers/{id}/status', [OfferController::class, 'updateStatus']);

    // Review Routes
    Route::post('/reviews', [ReviewController::class, 'store']);

    // Wishlist Routes
    Route::get('/wishlists', [WishlistController::class, 'index']);
    Route::post('/wishlists/toggle', [WishlistController::class, 'toggle']);

    // Message Routes
    Route::get('/messages', [MessageController::class, 'index']);
    Route::get('/messages/{produkId}/{partnerId}', [MessageController::class, 'show']);
    Route::post('/messages', [MessageController::class, 'store']);
    Route::post('/messages/read/{produkId}/{partnerId}', [MessageController::class, 'markAsRead']);
    Route::delete('/messages/clear/{produkId}/{partnerId}', [MessageController::class, 'clear']);
    Route::delete('/messages/{id}', [MessageController::class, 'destroy']);
});

// Review Public Routes
Route::get('/reviews/user/{id}', [ReviewController::class, 'index']);

// Public Routes
Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/produks', [ProdukController::class, 'index']);
Route::get('/produks/{identifier}', [ProdukController::class, 'show']);
