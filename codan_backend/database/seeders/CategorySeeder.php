<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            ['name' => 'Mobil', 'slug' => 'mobil', 'icon' => 'car'],
            ['name' => 'Motor', 'slug' => 'motor', 'icon' => 'bike'],
            ['name' => 'Properti', 'slug' => 'properti', 'icon' => 'home'],
            ['name' => 'Elektronik & Gadget', 'slug' => 'elektronik-gadget', 'icon' => 'smartphone'],
            ['name' => 'Hobi & Olahraga', 'slug' => 'hobi-olahraga', 'icon' => 'trophy'],
            ['name' => 'Rumah Tangga', 'slug' => 'rumah-tangga', 'icon' => 'lamp'],
            ['name' => 'Jasa & Lowongan Kerja', 'slug' => 'jasa-lowongan-kerja', 'icon' => 'briefcase'],
        ];

        foreach ($categories as $category) {
            \App\Models\Category::updateOrCreate(
                ['slug' => $category['slug']],
                ['name' => $category['name'], 'icon' => $category['icon']]
            );
        }
    }
}
