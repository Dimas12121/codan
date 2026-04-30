# API Messaging Integration Guide (Laravel to Flutter)

Dokumentasi ini menjelaskan cara mengintegrasikan fitur pesan (messaging) dari backend Laravel ke aplikasi Flutter Anda.

## 1. Konfigurasi Dasar
Semua request memerlukan header berikut untuk keamanan menggunakan **Laravel Sanctum**:

| Header | Value | Keterangan |
| :--- | :--- | :--- |
| `Accept` | `application/json` | Wajib untuk respons JSON |
| `Authorization` | `Bearer YOUR_ACCESS_TOKEN` | Token didapat setelah login |

**Base URL:** `http://your-domain.com/api` atau `http://10.0.2.2:8000/api` (untuk emulator Android).

---

## 2. Daftar Endpoint

### A. List Percakapan (Inbox)
Mengambil daftar semua chat yang dimiliki oleh user.
- **Method:** `GET`
- **URL:** `/messages`
- **Response Sample:**
```json
[
  {
    "id": 10,
    "produk": {
      "id": 1,
      "title": "MacBook Pro M2",
      "image": "http://domain.com/storage/chat/sample.jpg"
    },
    "partner": {
      "id": 5,
      "name": "Budi"
    },
    "last_message": "Berapa harganya bos?",
    "unread_count": 2,
    "timestamp": "2 minutes ago"
  }
]
```

### B. Detail Percakapan
Mengambil riwayat pesan antara user dengan partner untuk barang tertentu.
- **Method:** `GET`
- **URL:** `/messages/{produkId}/{partnerId}`
- **Response Sample:**
```json
{
  "produk": { "id": 1, "title": "MacBook Pro", "price": 15000000, "image": "..." },
  "partner": { "id": 5, "name": "Budi" },
  "messages": [
    {
      "id": 1,
      "sender_id": 1,
      "message": "Halo!",
      "image_path": null,
      "latitude": null,
      "is_read": true,
      "created_at": "2026-04-16 20:00:00"
    }
  ]
}
```

### C. Kirim Pesan
Mengirim pesan baru. Gunakan `multipart/form-data` jika menyertakan gambar.
- **Method:** `POST`
- **URL:** `/messages`
- **Body Params:**
  - `produk_id` (Integer) - Wajib
  - `receiver_id` (Integer) - Wajib
  - `message` (String) - Optional
  - `image` (File/Binary) - Optional
  - `latitude` (Double) - Optional
  - `longitude` (Double) - Optional

### D. Batal Kirim (Unsend)
- **Method:** `DELETE`
- **URL:** `/messages/{id}`

---

## 3. Real-Time dengan Laravel Reverb (Pusher)
Untuk mendapatkan pesan secara instan di Flutter tanpa refresh, gunakan package `flutter_pusher_client` atau `laravel_echo`.

**Private Channel Name:**
`chat.{produkId}.{minUserId}.{maxUserId}`

> **Catatan:** ID User harus diurutkan dari yang terkecil ke terbesar. Contoh jika User ID 1 chat dengan User ID 5 di barang ID 10, channel-nya adalah: `chat.10.1.5`

**Event Listeners:**
1. `MessageSent`: Pesan baru masuk.
2. `MessageDeleted`: Pesan dihapus oleh pengirim.

---

## 4. Tips Flutter Implementation
*   **Model Class**: Gunakan `json_serializable` untuk mapping response JSON ke Class Dart.
*   **Loading State**: Tampilkan `CircularProgressIndicator` saat memanggil `GET /messages/{id}/{id}`.
*   **Auto Scroll**: Gunakan `ScrollController.jumpTo(scrollController.position.maxScrollExtent)` setiap kali pesan baru ditambahkan ke list view.
*   **Image Handling**: Gunakan `CachedNetworkImage` agar performa list pesan lebih mulus.
