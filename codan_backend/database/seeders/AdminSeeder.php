<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@codean.com'],
            [
                'name' => 'Super Admin CODean',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_active' => true,
                'phone' => '08123456789',
                'location' => 'Jakarta Central',
            ]
        );
        
        User::updateOrCreate(
            ['email' => 'admin2@codean.com'],
            [
                'name' => 'Admin Support',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_active' => true,
                'phone' => '08123456780',
                'location' => 'Bandung',
            ]
        );
        
        User::updateOrCreate(
            ['email' => 'moderator@codean.com'],
            [
                'name' => 'Content Moderator',
                'password' => Hash::make('moderator123'),
                'role' => 'admin',
                'is_active' => true,
                'phone' => '08123456781',
                'location' => 'Surabaya',
            ]
        );
    }
}
