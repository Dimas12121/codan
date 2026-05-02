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
