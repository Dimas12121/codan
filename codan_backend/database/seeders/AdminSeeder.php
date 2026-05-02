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
            ['email' => 'admin@codan.com'],
            [
                'name' => 'Super Admin codan',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_active' => true,
                'phone' => '08123456789',
                'location' => 'Jakarta Central',
            ]
        );
        
        User::updateOrCreate(
            ['email' => 'admin2@codan.com'],
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
            ['email' => 'moderator@codan.com'],
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
