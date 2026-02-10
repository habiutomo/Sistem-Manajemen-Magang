# 🌐 Sistem Manajemen Magang

Sistem Manajemen Magang adalah aplikasi berbasis web untuk **mengelola proses magang secara terintegrasi** — mulai dari pendaftaran, penempatan, monitoring kegiatan, evaluasi, hingga laporan akhir peserta magang. Sistem ini dirancang untuk mendukung kebutuhan **admin, mahasiswa, mentor, dan supervisor** dalam aktivitas magang.

📌 Sistem ini merupakan *fork* dari project sebelumnya dengan struktur backend dan frontend terpisah, lengkap dengan skema database untuk kebutuhan operasional magang. 

---

## 🚀 Fitur Utama

Sistem menyediakan fitur-fitur berikut:

### 🔐 Autentikasi & Pengguna
- Login & Register pengguna  
- Role pengguna: **admin, mentor, mahasiswa, supervisor**  
- Profil pengguna

### 📊 Manajemen Data
- **Mahasiswa** — Profil akademik, info kontak  
- **Perusahaan & Mitra Magang** — Lokasi, kontak, jenis industri  
- **Posisi Magang** — Lowongan dengan deskripsi, persyaratan, kuota, durasi  
- **Pendaftaran Magang** — Mahasiswa bisa daftar posisi magang

### 📅 Penempatan & Monitoring
- Alokasi **penempatan magang** ke mentor/supervisor  
- **Logbook aktivitas harian** peserta magang  
- Laporan progres kegiatan

### 📝 Evaluasi & Laporan
- Penilaian (kehadiran, kualitas kerja, komunikasi, kerjasama, dll)  
- Laporan akhir magang  
- Pengaturan status pendaftaran & penempatan

### 📢 Pengumuman & Dokumen
- Pengumuman sistem untuk pengguna  
- Upload/kelola **dokumen magang** seperti surat izin, CV, sertifikat, dll

---

## 📦 Struktur Repository
├── Backend/ # Kode backend (API, logika server)
├── Frontend/ # Kode frontend (UI/UX)
├── simagang.sql # Skema database dan sample setup
└── README.md # Dokumen ini


Database telah terdokumentasi lengkap di file `simagang.sql`, mencakup tabel-tabel seperti `users`, `mahasiswa`, `perusahaan`, `posisi_magang`, `pendaftaran_magang`, `penempatan_magang`, `logbook`, `evaluasi`, `laporan_akhir`, dan lainnya. :contentReference[oaicite:2]{index=2}

---

## 🧠 Instalasi

### 1. Clone Repository
```bash
git clone https://github.com/habiutomo/Sistem-Manajemen-Magang.git
cd Sistem-Manajemen-Magang

2. Setup Database

Import file simagang.sql ke database MySQL / MariaDB:

mysql -u root -p < simagang.sql

3. Backend

Masuk ke folder backend

Install dependencies (mis. dengan Composer untuk PHP/Laravel):

composer install


Buat file konfigurasi environment (.env) dan sesuaikan koneksi database

Jalankan server

php artisan serve

4. Frontend

Masuk ke folder frontend

Install dependencies (mis. npm install)

Jalankan development server

npm run dev


Catatan: Sesuaikan perintah di atas dengan stack yang digunakan (Laravel, Node, Vue/React, dll). Kalau ada dokumentasi tambahan pada folder masing-masing, ikuti petunjuk itu terlebih dahulu.

🧪 Testing

Gunakan tool seperti Postman untuk testing API.

Pastikan semua endpoint autentikasi dan CRUD berfungsi sebelum deploy.

📃 Kontribusi

Contributions sangat welcome! Caranya:

Fork repo ini

Buat branch fitur kamu (git checkout -b fitur-xyz)

Commit perubahan

Push dan buka Pull Request

📜 Lisensi

Lisensi dari repository ini mengikuti lisensi original dari fork asalnya. Pastikan cek apakah ada file LICENSE di repo.



