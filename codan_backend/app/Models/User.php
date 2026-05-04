<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

use Laravel\Sanctum\HasApiTokens;

#[Fillable(['name', 'email', 'avatar', 'google_id', 'google_token', 'google_refresh_token', 'password', 'role', 'is_active', 'phone', 'is_phone_verified', 'phone_verified_at', 'location', 'latitude', 'longitude', 'bio'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    protected $appends = ['wa_link'];

    public function getWaLinkAttribute()
    {
        if (!$this->phone) {
            return null;
        }

        $digits = preg_replace('/[^0-9]/', '', $this->phone);
        
        // Convert leading 0 to 62
        if (str_starts_with($digits, '0')) {
            $digits = '62' . substr($digits, 1);
        }

        return "https://wa.me/" . $digits;
    }

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function produks()
    {
        return $this->hasMany(Produk::class);
    }

    public function offers()
    {
        return $this->hasMany(Offer::class);
    }

    public function reviewsReceived()
    {
        return $this->hasMany(Review::class, 'reviewee_id');
    }

    public function reviewsGiven()
    {
        return $this->hasMany(Review::class, 'reviewer_id');
    }

    public function wishlists()
    {
        return $this->hasMany(Wishlist::class);
    }

    public function isAdmin()
    {
        return $this->role === 'admin' && $this->is_active;
    }

    public function isSeller()
    {
        return $this->role === 'seller' && $this->is_active;
    }

    public function isBuyer()
    {
        return $this->role === 'buyer' && $this->is_active;
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeInactive($query)
    {
        return $query->where('is_active', false);
    }

    public function scopeAdmins($query)
    {
        return $query->where('role', 'admin')->where('is_active', true);
    }

    public function scopeSellers($query)
    {
        return $query->where('role', 'seller')->where('is_active', true);
    }

    public function scopeBuyers($query)
    {
        return $query->where('role', 'buyer')->where('is_active', true);
    }
}
