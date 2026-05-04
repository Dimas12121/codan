<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Produk extends Model
{
    protected $table = 'produks';

    protected $fillable = [
        'user_id', 'category_id', 'title', 'slug', 'description', 'price', 
        'rental_period', 'type', 'condition', 'location', 'latitude', 
        'longitude', 'status'
    ];

    protected $appends = ['wa_link'];

    public function getWaLinkAttribute()
    {
        if (!$this->user || !$this->user->phone) {
            return null;
        }

        $phone = $this->user->phone;
        
        // Remove non-digit characters
        $digits = preg_replace('/[^0-9]/', '', $phone);

        // Convert leading 0 to 62 (Indonesian country code)
        if (str_starts_with($digits, '0')) {
            $digits = '62' . substr($digits, 1);
        }

        $message = "Halo, saya tertarik dengan produk *" . $this->title . "* yang Anda posting di " . config('app.name') . ".\n\nHarga: Rp " . number_format($this->price, 0, ',', '.') . "\nLink: " . config('app.url') . "/produks/" . ($this->slug ?? $this->id);

        return "https://wa.me/" . $digits . "?text=" . urlencode($message);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function images()
    {
        return $this->hasMany(ProdukImage::class);
    }

    public function featuredImage()
    {
        return $this->hasOne(ProdukImage::class)->where('is_featured', true)->withDefault([
            'image_path' => 'placeholder.png'
        ]);
    }

    public function offers()
    {
        return $this->hasMany(Offer::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function messages()
    {
        return $this->hasMany(Message::class);
    }

    public function wishlists()
    {
        return $this->hasMany(Wishlist::class);
    }
}
