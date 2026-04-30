<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProdukImage extends Model
{
    protected $fillable = ['produk_id', 'image_path', 'is_featured'];

    public function produk()
    {
        return $this->belongsTo(Produk::class);
    }
}
