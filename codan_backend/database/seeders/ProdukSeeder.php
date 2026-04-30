<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Category;
use App\Models\Produk;
use App\Models\ProdukImage;
use Illuminate\Support\Str;

class ProdukSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::first() ?? User::factory()->create([
            'name' => 'Gusti Adiba',
            'email' => 'gusti@example.com',
            'password' => bcrypt('password'),
        ]);

        $categories = Category::all();

        $produks = [
            [
                'title' => 'Toyota Avanza 2022 G Manual - Mulus Terawat',
                'category_slug' => 'mobil',
                'price' => 185000000,
                'location' => 'Jakarta Selatan',
                'image' => 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?q=80&w=800',
            ],
            [
                'title' => 'iPhone 15 Pro Max 256GB Titanium - Ibox Official',
                'category_slug' => 'elektronik-gadget',
                'price' => 21500000,
                'location' => 'Bandung, Jawa Barat',
                'image' => 'https://images.unsplash.com/photo-1696446701796-da61225697cc?q=80&w=800',
            ],
            [
                'title' => 'Rumah Mewah Cluster Minimalis 2 Lantai - Siap Huni',
                'category_slug' => 'properti',
                'price' => 1250000000,
                'location' => 'Tangerang Selatan',
                'image' => 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?q=80&w=800',
            ],
            [
                'title' => 'Kawasaki Ninja ZX25R 2023 Low KM - Modifikasi Ringan',
                'category_slug' => 'motor',
                'price' => 98000000,
                'location' => 'Surabaya, Jawa Timur',
                'image' => 'https://images.unsplash.com/photo-1558981403-c5f91ebefc25?q=80&w=800',
            ],
        ];

        foreach ($produks as $item) {
            $cat = $categories->where('slug', $item['category_slug'])->first();
            $slug = Str::slug($item['title']);
            
            Produk::firstOrCreate(
                ['slug' => $slug],
                [
                    'user_id' => $user->id,
                    'category_id' => $cat->id,
                    'title' => $item['title'],
                    'description' => 'Dijual unit berkualitas dengan kondisi ' . ($cat->slug == 'mobil' ? 'sangat terawat.' : 'mulus seperti baru.') . ' Nego tipis sampai jadi.',
                    'price' => $item['price'],
                    'condition' => 'used',
                    'location' => $item['location'],
                    'status' => 'active',
                ]
            );

            $produk = Produk::where('slug', $slug)->first();

            ProdukImage::firstOrCreate(
                ['produk_id' => $produk->id, 'image_path' => $item['image']],
                ['is_featured' => true]
            );
        }
    }
}
