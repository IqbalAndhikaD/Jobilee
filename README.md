![alt text](https://github.com/IqbalAndhikaD/Jobilee/blob/master/assets/Jobilee%20Porto.png?raw=true)

# Jobilee 🚀

**Jobilee** adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempermudah pencarian kerja dan manajemen lamaran. Aplikasi ini menghubungkan pencari kerja dengan berbagai peluang karir dari berbagai perusahaan secara efisien.

## ✨ Fitur Utama

- **Pencarian Lowongan Kerja**: Cari pekerjaan berdasarkan judul, nama perusahaan, atau lokasi.
- **Lamaran Instan**: Ajukan lamaran kerja langsung melalui aplikasi dengan satu klik.
- **Simpan Lowongan**: Tandai lowongan kerja favorit Anda untuk dilihat atau dilamar nanti.
- **Notifikasi Real-time**: Dapatkan update status lamaran dan info lowongan terbaru melalui Push Notifications.
- **Manajemen Profil**: Kelola informasi pribadi, foto profil, dan status karir (seperti Fresh Graduate).
- **Integrasi Peta**: Lihat lokasi perusahaan secara visual menggunakan fitur peta terintegrasi.
- **Autentikasi Aman**: Login menggunakan Google, Apple, atau Email melalui Firebase Authentication.

## 🛠️ Tech Stack

Aplikasi ini dibangun menggunakan teknologi modern:

- **Frontend**: [Flutter](https://flutter.dev/) (Dart)
- **Backend/Database**: [Supabase](https://supabase.com/)
- **Authentication**: [Firebase Auth](https://firebase.google.com/products/auth)
- **Push Notifications**: [Firebase Cloud Messaging (FCM)](https://firebase.google.com/products/cloud-messaging)
- **Maps**: [Flutter Map](https://pub.dev/packages/flutter_map)
- **State Management**: Flutter StatefulWidget & FutureBuilder

## 🚀 Cara Menjalankan Project

### Prasyarat

- Pastikan Anda sudah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Pastikan Anda memiliki editor seperti VS Code atau Android Studio.

### Langkah-langkah

1. **Clone Repository**

   ```bash
   git clone <repository-url>
   cd Jobilee
   ```

2. **Instal Dependensi**

   ```bash
   flutter pub get
   ```

3. **Konfigurasi Firebase & Supabase**
   - Pastikan file `lib/firebase_options.dart` dan `lib/supabase_options.dart` sudah dikonfigurasi dengan API Key yang valid.

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

## 📂 Struktur Folder Utama

```text
lib/
├── authentication/    # Layanan login, register, dan notifikasi
├── services/          # Logika backend (JobService untuk Supabase)
├── rsc/               # Resource seperti warna, gambar, dan log
├── home.dart          # Halaman Dashboard Utama
├── find.dart          # Halaman Pencarian Kerja
├── apply.dart         # Logika Lamaran Kerja
├── saved.dart         # Halaman Lowongan Tersimpan
└── main.dart          # Entry point aplikasi
```

## ⚠️ Baru Tersedia Untuk Android, IoS Belum Tersedia

- Saat ini hanya tersedia untuk Android, IoS akan tersedia segera.

---

Dibuat dengan ❤️ oleh Tim Jobilee.
