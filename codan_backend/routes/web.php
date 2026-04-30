<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProdukController;
use Illuminate\Support\Facades\Route;
use App\Models\Category;
use App\Models\Produk;

Route::get('/', [ProdukController::class, 'index'])->name('home');
Route::get('/produk/{slug}', [ProdukController::class, 'show'])->name('produks.show');

Route::get('/dashboard', function (Illuminate\Http\Request $request) {
    $user = auth()->user();
    
    if ($user->role == 'admin') {
        return redirect()->route('admin.dashboard');
    }

    // Device detection for dashboard view
    $view = (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/Mobile|Android|iPhone/i', $_SERVER['HTTP_USER_AGENT'])) ? 'mobile.dashboard' : 'dashboard';

    if ($user->role == 'buyer') {
        $categories = Category::withCount(['produks' => function($q) {
            $q->where('status', 'active');
        }])->get();
        $query = Produk::with(['featuredImage', 'category'])->where('status', 'active');
        
        if ($request->has('category')) {
            $query->whereHas('category', function($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        if ($request->has('search')) {
            $query->where('title', 'like', '%' . $request->search . '%');
        }

        $recommendations = $query->latest()->paginate(12);
        return view($view, compact('categories', 'recommendations'));
    }

    // Seller Logic
    $status = $request->get('status', 'active');
    $produksQuery = $user->produks()->with(['featuredImage', 'category']);
    
    if ($status === 'sold') {
        $produksQuery->where('status', 'sold');
    } else {
        $produksQuery->where('status', 'active');
    }

    $produks = $produksQuery->latest()->get();
    
    // Stats calculation
    $totalViews = $user->produks()->sum('views');
    $activeChats = \App\Models\Message::where('receiver_id', $user->id)
        ->orWhere('sender_id', $user->id)
        ->get()
        ->groupBy(function($msg) use ($user) {
            $partnerId = $msg->sender_id == $user->id ? $msg->receiver_id : $msg->sender_id;
            return $msg->produk_id . '-' . $partnerId;
        })
        ->count();

    return view($view, compact('produks', 'totalViews', 'activeChats', 'status'));
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/sell', [ProdukController::class, 'create'])->name('produks.create');
    Route::post('/sell', [ProdukController::class, 'store'])->name('produks.store');
    Route::get('/produk/{id}/edit', [ProdukController::class, 'edit'])->name('produks.edit');
    Route::put('/produk/{id}', [ProdukController::class, 'update'])->name('produks.update');
    Route::patch('/produk/{id}/status', [ProdukController::class, 'updateStatus'])->name('produks.status');
    Route::delete('/produk/{id}', [ProdukController::class, 'destroy'])->name('produks.destroy');
    
    Route::get('/profile', [ProfileController::class, 'show'])->name('profile.show');
    Route::get('/profile/settings', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    Route::get('/inbox', [\App\Http\Controllers\MessageController::class, 'index'])->name('inbox.index');
    Route::get('/inbox/{produk}/{partner}', [\App\Http\Controllers\MessageController::class, 'show'])->name('inbox.show');
    Route::post('/messages', [\App\Http\Controllers\MessageController::class, 'store'])->name('messages.store');
    Route::post('/messages/read/{produk}/{partner}', [\App\Http\Controllers\MessageController::class, 'markAsRead'])->name('messages.read');
    Route::delete('/messages/{id}', [\App\Http\Controllers\MessageController::class, 'destroy'])->name('messages.destroy');
    Route::post('/offers', [\App\Http\Controllers\OfferController::class, 'store'])->name('offers.store');

    Route::post('/produk/{produk}/report', [\App\Http\Controllers\ReportController::class, 'store'])->name('reports.store');

    // Notifications
    Route::get('/notifications', [\App\Http\Controllers\NotificationController::class, 'index'])->name('notifications.index');
    Route::post('/notifications/{id}/read', [\App\Http\Controllers\NotificationController::class, 'markAsRead'])->name('notifications.read');
    Route::post('/notifications/read-all', [\App\Http\Controllers\NotificationController::class, 'markAllAsRead'])->name('notifications.read-all');
    Route::get('/notifications/unread', [\App\Http\Controllers\NotificationController::class, 'getUnread'])->name('notifications.unread');

    // Wishlist
    Route::get('/wishlist', [\App\Http\Controllers\WishlistController::class, 'index'])->name('wishlist.index');
    Route::post('/wishlist/{produk}/toggle', [\App\Http\Controllers\WishlistController::class, 'toggle'])->name('wishlist.toggle');
});

// Admin Routes
Route::middleware(['auth', 'admin'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/dashboard', [\App\Http\Controllers\Admin\AdminController::class, 'index'])->name('dashboard');
    Route::get('/produk', [\App\Http\Controllers\Admin\AdminController::class, 'listings'])->name('produk');
    Route::get('/users', [\App\Http\Controllers\Admin\AdminController::class, 'users'])->name('users');
    Route::get('/users/active', [\App\Http\Controllers\Admin\AdminController::class, 'activeUsers'])->name('users.active');
    Route::get('/users/inactive', [\App\Http\Controllers\Admin\AdminController::class, 'inactiveUsers'])->name('users.inactive');
    Route::get('/users/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'userDetail'])->name('users.detail');
    Route::delete('/produk/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'deleteListing'])->name('produk.delete');
    Route::delete('/users/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'deleteUser'])->name('users.delete');
    Route::patch('/users/{id}/role', [\App\Http\Controllers\Admin\AdminController::class, 'updateRole'])->name('users.role');
    Route::patch('/users/{id}/toggle-status', [\App\Http\Controllers\Admin\AdminController::class, 'toggleUserStatus'])->name('users.toggle-status');
    Route::patch('/produk/{id}/status', [\App\Http\Controllers\Admin\AdminController::class, 'updateListingStatus'])->name('produk.update-status');
    
    // Categories
    Route::get('/categories', [\App\Http\Controllers\Admin\AdminController::class, 'categories'])->name('categories');
    Route::post('/categories', [\App\Http\Controllers\Admin\AdminController::class, 'storeCategory'])->name('categories.store');
    Route::patch('/categories/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'updateCategory'])->name('categories.update');
    Route::delete('/categories/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'deleteCategory'])->name('categories.delete');

    // Reports
    Route::get('/reports', [\App\Http\Controllers\Admin\AdminController::class, 'reports'])->name('reports');
    Route::patch('/reports/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'updateReportStatus'])->name('reports.update-status');
    Route::delete('/reports/{id}', [\App\Http\Controllers\Admin\AdminController::class, 'deleteReport'])->name('reports.delete');
});

// Google Authentication
Route::get('auth/google', [\App\Http\Controllers\Auth\GoogleController::class, 'redirectToGoogle'])->name('auth.google');
Route::get('auth/google/callback', [\App\Http\Controllers\Auth\GoogleController::class, 'handleGoogleCallback']);

require __DIR__.'/auth.php';
