# 🚀 codan (CODAN) - Campus Marketplace & Rental App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)

**codan** (atau **CODAN**) adalah platform marketplace modern yang dirancang khusus untuk kebutuhan mahasiswa. Aplikasi ini memungkinkan pengguna untuk melakukan jual-beli barang bekas berkualitas serta menyewakan barang (seperti alat praktikum, buku, dsb) dalam lingkup kampus yang aman dan terpercaya.

---

## ✨ Fitur Utama

### 🛒 Marketplace & Rental
- **Dual Transaction System**: Mendukung penjualan produk (`sell`) dan penyewaan produk (`rent`) dengan periode fleksibel (Harian, Mingguan, Bulanan).
- **Advanced Search**: Pencarian cerdas dengan riwayat pencarian (Search History) yang tersimpan secara persisten.
- **Category Filter**: Navigasi produk berdasarkan kategori yang relevan.

### 💬 Real-time Communication
- **Chat Penjual**: Fitur obrolan langsung antara pembeli dan penjual di dalam aplikasi untuk negosiasi dan koordinasi.
- **Contextual Chat**: Chat otomatis menyertakan informasi produk yang sedang ditanyakan.

### 🔐 Authentication System
- **Multi-method Login**: Login menggunakan Email atau Nomor Telepon.
- **OTP Verification**: Keamanan tambahan menggunakan OTP via WhatsApp untuk registrasi dan login.

### 👤 User Profile & Experience
- **Premium UI/UX**: Desain antarmuka modern dengan *Glassmorphism* dan micro-animations.
- **Dynamic Profile**: Update informasi bio, lokasi, dan foto profil (Avatar) secara langsung.
- **Wishlist System**: Simpan produk favorit Anda untuk dilihat nanti.

---

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi |
| --- | --- |
| **Frontend** | Flutter (Dart) |
| **State Management** | Flutter BLoC (Cubit & Bloc) |
| **Backend** | Laravel 11 (PHP) |
| **Database** | MySQL / MariaDB |
| **API Client** | Dio with Interceptors |
| **Security** | Laravel Sanctum & OTP |

---

## 🚀 Panduan Instalasi

### 1. Prasyarat
- Flutter SDK (Versi terbaru)
- PHP >= 8.2 & Composer
- MySQL/MariaDB
- Android Studio / VS Code

### 2. Setup Backend (Laravel)
```bash
cd codan_backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
php artisan serve
```

### 3. Setup Frontend (Flutter)
```bash
# Update Base URL di lib/core/config/environment.dart jika perlu
flutter pub get
flutter run
```

---

## 📸 Tampilan Aplikasi (Mockup)
*(Tambahkan screenshot aplikasi Anda di sini untuk tampilan yang lebih menarik)*

---

## 🤝 Kontribusi
Proyek ini dikembangkan untuk kebutuhan tugas akhir/proyek praktikum. Kontribusi dalam bentuk *bug report* atau *feature request* sangat dipersilakan.

**Developed by [RoyTheChillGuy](https://github.com/RoyTheChillGuy)**
