-- ============================================
-- SISTEM MANAJEMEN MAGANG - DATABASE SCHEMA
-- ============================================

-- Drop existing database if it exists
DROP DATABASE IF EXISTS magang_db;

-- Create database
CREATE DATABASE magang_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE magang_db;

-- ============================================
-- 1. TABEL PENGGUNA (USERS)
-- ============================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    role ENUM('admin', 'mentor', 'mahasiswa', 'supervisor') NOT NULL,
    phone VARCHAR(15),
    profile_picture VARCHAR(255),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- ============================================
-- 2. TABEL MAHASISWA (STUDENTS)
-- ============================================
CREATE TABLE mahasiswa (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    nim VARCHAR(20) UNIQUE NOT NULL,
    universitas VARCHAR(100) NOT NULL,
    program_studi VARCHAR(100) NOT NULL,
    tahun_akademik VARCHAR(20),
    semester INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_nim (nim),
    INDEX idx_universitas (universitas)
);

-- ============================================
-- 3. TABEL PERUSAHAAN (COMPANIES)
-- ============================================
CREATE TABLE perusahaan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_perusahaan VARCHAR(150) NOT NULL UNIQUE,
    alamat TEXT NOT NULL,
    kota VARCHAR(50) NOT NULL,
    provinsi VARCHAR(50) NOT NULL,
    kode_pos VARCHAR(10),
    telepon VARCHAR(15),
    email VARCHAR(100),
    website VARCHAR(100),
    industri VARCHAR(100),
    jumlah_karyawan INT,
    contact_person VARCHAR(100),
    cp_phone VARCHAR(15),
    cp_email VARCHAR(100),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nama (nama_perusahaan),
    INDEX idx_kota (kota)
);

-- ============================================
-- 4. TABEL MENTOR (MENTORS)
-- ============================================
CREATE TABLE mentor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    nip VARCHAR(20) UNIQUE,
    perusahaan_id INT NOT NULL,
    bidang_keahlian VARCHAR(150),
    departemen VARCHAR(100),
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (perusahaan_id) REFERENCES perusahaan(id),
    INDEX idx_perusahaan (perusahaan_id)
);

-- ============================================
-- 5. TABEL POSISI/LOWONGAN MAGANG (INTERNSHIP POSITIONS)
-- ============================================
CREATE TABLE posisi_magang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    perusahaan_id INT NOT NULL,
    judul_posisi VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    requirement TEXT,
    kuota INT NOT NULL DEFAULT 1,
    durasi_minggu INT NOT NULL,
    bidang VARCHAR(100),
    tipe_magang ENUM('online', 'offline', 'hybrid') DEFAULT 'offline',
    gaji_stipend DECIMAL(10, 2),
    status ENUM('aktif', 'nonaktif', 'tertutup') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (perusahaan_id) REFERENCES perusahaan(id),
    INDEX idx_perusahaan (perusahaan_id),
    INDEX idx_status (status)
);

-- ============================================
-- 6. TABEL PENDAFTARAN MAGANG (INTERNSHIP REGISTRATION)
-- ============================================
CREATE TABLE pendaftaran_magang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mahasiswa_id INT NOT NULL,
    posisi_magang_id INT NOT NULL,
    perusahaan_id INT NOT NULL,
    status ENUM('draft', 'submitted', 'reviewed', 'accepted', 'rejected', 'completed') DEFAULT 'draft',
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tanggal_mulai DATE,
    tanggal_selesai DATE,
    letter_file VARCHAR(255),
    cv_file VARCHAR(255),
    alasan_penolakan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id) ON DELETE CASCADE,
    FOREIGN KEY (posisi_magang_id) REFERENCES posisi_magang(id),
    FOREIGN KEY (perusahaan_id) REFERENCES perusahaan(id),
    INDEX idx_mahasiswa (mahasiswa_id),
    INDEX idx_status (status),
    INDEX idx_perusahaan (perusahaan_id),
    UNIQUE KEY unique_registration (mahasiswa_id, posisi_magang_id)
);

-- ============================================
-- 7. TABEL PENEMPATAN MAGANG (INTERNSHIP PLACEMENT)
-- ============================================
CREATE TABLE penempatan_magang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pendaftaran_magang_id INT NOT NULL UNIQUE,
    mahasiswa_id INT NOT NULL,
    mentor_id INT NOT NULL,
    supervisor_id INT,
    perusahaan_id INT NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    divisi VARCHAR(100),
    posisi_kerja VARCHAR(100),
    status_penempatan ENUM('aktif', 'selesai', 'dibatalkan') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (pendaftaran_magang_id) REFERENCES pendaftaran_magang(id),
    FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id),
    FOREIGN KEY (mentor_id) REFERENCES mentor(id),
    FOREIGN KEY (supervisor_id) REFERENCES users(id),
    FOREIGN KEY (perusahaan_id) REFERENCES perusahaan(id),
    INDEX idx_mahasiswa (mahasiswa_id),
    INDEX idx_mentor (mentor_id),
    INDEX idx_status (status_penempatan)
);

-- ============================================
-- 8. TABEL LOGBOOK (ACTIVITY LOG)
-- ============================================
CREATE TABLE logbook (
    id INT PRIMARY KEY AUTO_INCREMENT,
    penempatan_magang_id INT NOT NULL,
    tanggal DATE NOT NULL,
    aktivitas TEXT NOT NULL,
    output VARCHAR(255),
    jam_mulai TIME,
    jam_selesai TIME,
    notes TEXT,
    dokumen_file VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penempatan_magang_id) REFERENCES penempatan_magang(id) ON DELETE CASCADE,
    INDEX idx_penempatan (penempatan_magang_id),
    INDEX idx_tanggal (tanggal)
);

-- ============================================
-- 9. TABEL PENILAIAN/EVALUASI (EVALUATION)
-- ============================================
CREATE TABLE evaluasi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    penempatan_magang_id INT NOT NULL,
    evaluasi_oleh INT NOT NULL,
    tipe_evaluasi ENUM('mentor', 'supervisor') DEFAULT 'mentor',
    tanggal_evaluasi DATE NOT NULL,
    
    -- Kriteria Penilaian
    kehadiran INT CHECK (kehadiran >= 0 AND kehadiran <= 100),
    inisiatif INT CHECK (inisiatif >= 0 AND inisiatif <= 100),
    kualitas_kerja INT CHECK (kualitas_kerja >= 0 AND kualitas_kerja <= 100),
    komunikasi INT CHECK (komunikasi >= 0 AND komunikasi <= 100),
    kerjasama INT CHECK (kerjasama >= 0 AND kerjasama <= 100),
    kepemimpinan INT CHECK (kepemimpinan >= 0 AND kepemimpinan <= 100),
    
    nilai_akhir DECIMAL(5, 2),
    komentar TEXT,
    rekomendasi TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penempatan_magang_id) REFERENCES penempatan_magang(id) ON DELETE CASCADE,
    FOREIGN KEY (evaluasi_oleh) REFERENCES users(id),
    INDEX idx_penempatan (penempatan_magang_id),
    INDEX idx_evaluasi_oleh (evaluasi_oleh)
);

-- ============================================
-- 10. TABEL LAPORAN AKHIR (FINAL REPORT)
-- ============================================
CREATE TABLE laporan_akhir (
    id INT PRIMARY KEY AUTO_INCREMENT,
    penempatan_magang_id INT NOT NULL UNIQUE,
    mahasiswa_id INT NOT NULL,
    judul_laporan VARCHAR(255) NOT NULL,
    ringkasan TEXT,
    file_laporan VARCHAR(255),
    tanggal_submit DATE,
    status ENUM('draft', 'submitted', 'revised', 'approved', 'rejected') DEFAULT 'draft',
    catatan_revisi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penempatan_magang_id) REFERENCES penempatan_magang(id) ON DELETE CASCADE,
    FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id),
    INDEX idx_status (status)
);

-- ============================================
-- 11. TABEL NILAI AKHIR (FINAL GRADE)
-- ============================================
CREATE TABLE nilai_akhir (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mahasiswa_id INT NOT NULL,
    penempatan_magang_id INT NOT NULL,
    nilai_akademik DECIMAL(5, 2),
    nilai_mentor DECIMAL(5, 2),
    nilai_laporan DECIMAL(5, 2),
    nilai_akhir DECIMAL(5, 2),
    grade VARCHAR(5),
    status ENUM('belum_dinilai', 'dinilai', 'disetujui') DEFAULT 'belum_dinilai',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mahasiswa_id) REFERENCES mahasiswa(id),
    FOREIGN KEY (penempatan_magang_id) REFERENCES penempatan_magang(id),
    UNIQUE KEY unique_nilai (mahasiswa_id, penempatan_magang_id),
    INDEX idx_status (status)
);

-- ============================================
-- 12. TABEL SURAT/DOKUMEN (DOCUMENTS)
-- ============================================
CREATE TABLE dokumen (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipe_dokumen ENUM('surat_izin', 'surat_penerimaan', 'surat_selesai', 'sertifikat') NOT NULL,
    penempatan_magang_id INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    nomor_dokumen VARCHAR(50),
    tanggal_dokumen DATE,
    status ENUM('draft', 'terbit', 'dibatalkan') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (penempatan_magang_id) REFERENCES penempatan_magang(id) ON DELETE CASCADE,
    INDEX idx_tipe (tipe_dokumen),
    INDEX idx_penempatan (penempatan_magang_id)
);

-- ============================================
-- 13. TABEL PENGUMUMAN (ANNOUNCEMENTS)
-- ============================================
CREATE TABLE pengumuman (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judul VARCHAR(255) NOT NULL,
    konten TEXT NOT NULL,
    dibuat_oleh INT NOT NULL,
    tipe_pengumuman ENUM('umum', 'mahasiswa', 'mentor', 'admin') DEFAULT 'umum',
    tanggal_mulai DATE,
    tanggal_selesai DATE,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dibuat_oleh) REFERENCES users(id),
    INDEX idx_active (is_active),
    INDEX idx_created (created_at)
);

-- ============================================
-- 14. TABEL LOG AKTIVITAS SISTEM (SYSTEM LOG)
-- ============================================
CREATE TABLE system_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100),
    entity_type VARCHAR(50),
    entity_id INT,
    description TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_created (created_at)
);

-- ============================================
-- 15. TABEL PENGATURAN (SETTINGS)
-- ============================================
CREATE TABLE pengaturan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    deskripsi VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- INSERT DATA SAMPLE
-- ============================================

-- Insert admin user
INSERT INTO users (username, email, password, fullname, role, phone, is_active) VALUES
('admin', 'admin@magang.com', MD5('admin123'), 'Administrator', 'admin', '081234567890', 1),
('supervisor1', 'supervisor@univ.edu', MD5('pass123'), 'Dr. Budi Santoso', 'supervisor', '081234567891', 1);

-- Insert sample company
INSERT INTO perusahaan (nama_perusahaan, alamat, kota, provinsi, kode_pos, telepon, email, website, industri, jumlah_karyawan, contact_person, cp_phone, cp_email) VALUES
('PT. Teknologi Indonesia', 'Jl. Sudirman No. 123', 'Jakarta', 'DKI Jakarta', '12190', '021-1234567', 'hr@tekindo.com', 'www.tekindo.com', 'IT/Software', 150, 'Rini Wijaya', '081234567892', 'rini@tekindo.com'),
('PT. Inovasi Digital', 'Jl. Ahmad Yani No. 45', 'Bandung', 'Jawa Barat', '40123', '022-9876543', 'info@innovasi.com', 'www.innovasi.com', 'Digital Marketing', 80, 'Ahmad Hidayat', '081234567893', 'ahmad@innovasi.com');

-- Insert sample mentor
INSERT INTO users (username, email, password, fullname, role, phone, is_active) VALUES
('mentor1', 'mentor1@tekindo.com', MD5('mentor123'), 'Endra Wijaya', 'mentor', '081234567894', 1),
('mentor2', 'mentor2@innovasi.com', MD5('mentor123'), 'Siti Rahayu', 'mentor', '081234567895', 1);

INSERT INTO mentor (user_id, nip, perusahaan_id, bidang_keahlian, departemen) VALUES
(3, '0012340001', 1, 'Backend Development', 'IT Division'),
(4, '0012340002', 2, 'Digital Marketing', 'Marketing Division');

-- Insert sample students
INSERT INTO users (username, email, password, fullname, role, phone, is_active) VALUES
('mahasiswa1', 'mahasiswa1@student.com', MD5('student123'), 'Rafi Pratama', 'mahasiswa', '081234567896', 1),
('mahasiswa2', 'mahasiswa2@student.com', MD5('student123'), 'Dewi Lestari', 'mahasiswa', '081234567897', 1);

INSERT INTO mahasiswa (user_id, nim, universitas, program_studi, tahun_akademik, semester) VALUES
(5, '2020001', 'Universitas Negeri Jakarta', 'Teknik Informatika', '2024/2025', 6),
(6, '2020002', 'Universitas Negeri Jakarta', 'Sistem Informasi', '2024/2025', 6);

-- Insert sample internship positions
INSERT INTO posisi_magang (perusahaan_id, judul_posisi, deskripsi, requirement, kuota, durasi_minggu, bidang, tipe_magang, gaji_stipend, status) VALUES
(1, 'Backend Developer', 'Develop RESTful API using Node.js', 'Menguasai JavaScript, REST API, MySQL', 2, 12, 'IT', 'offline', 2000000, 'aktif'),
(2, 'Digital Marketing Specialist', 'Social Media Management dan Content Creation', 'Mengerti Digital Marketing, Social Media', 1, 8, 'Marketing', 'hybrid', 1500000, 'aktif');

-- Insert system settings
INSERT INTO pengaturan (setting_key, setting_value, deskripsi) VALUES
('app_name', 'Sistem Manajemen Magang', 'Nama Aplikasi'),
('semester_aktif', '2024/2025', 'Semester Akademik Aktif'),
('durasi_magang_min', '8', 'Durasi Magang Minimum (Minggu)'),
('durasi_magang_max', '16', 'Durasi Magang Maximum (Minggu)'),
('nilai_minimum', '60', 'Nilai Minimum Lulus'),
('max_mahasiswa_per_perusahaan', '5', 'Maksimal Mahasiswa Per Perusahaan');