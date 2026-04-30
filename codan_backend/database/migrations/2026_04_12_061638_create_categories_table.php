<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Membuat tabel categories beserta data awal (seed).
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('icon')->nullable();
            $table->foreignId('parent_id')->nullable()->constrained('categories')->onDelete('cascade');
            $table->timestamps();
        });

        // Insert data kategori awal
        DB::table('categories')->insert([
            ['name' => 'Mobil',              'slug' => 'mobil',              'icon' => 'car',        'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Motor',              'slug' => 'motor',              'icon' => 'bike',       'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Properti',           'slug' => 'properti',           'icon' => 'home',       'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Elektronik & Gadget','slug' => 'elektronik-gadget',  'icon' => 'smartphone', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Hobi & Olahraga',   'slug' => 'hobi-olahraga',      'icon' => 'trophy',     'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Rumah Tangga',       'slug' => 'rumah-tangga',       'icon' => 'lamp',       'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Jasa & Lowongan Kerja','slug' => 'jasa-lowongan-kerja','icon' => 'briefcase','created_at' => now(), 'updated_at' => now()],
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};
