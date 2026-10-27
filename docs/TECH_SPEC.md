# SPARK — Technical Specification

**Project:** Spark – Spot My Park  
**Platform:** Android (Flutter)  
**Backend:** Node.js / Express  
**Database:** MySQL  
**Status:** Proposed Technical Baseline  
**Reference:** PRD_Spark_Final.md

## 1. Purpose & Scope

Dokumen ini mendefinisikan rancangan teknis awal untuk implementasi Spark – Spot My Park berdasarkan kebutuhan dalam PRD.

Implementasi difokuskan pada fitur Must Have:

- Autentikasi pengguna.
- Pencatatan lokasi parkir terstruktur dan bebas.
- Pemilihan kota dan dummy data mall.
- Pengambilan foto dan GPS.
- Penyesuaian pin Google Maps.
- Penyimpanan sesi parkir ke server.
- Pengelolaan beberapa sesi aktif.
- Detail dan riwayat parkir.
- Informasi lantai, area, dan catatan.
- Pengingat durasi parkir.
- Penyelesaian sesi parkir.

Fitur Should Have dan Could Have dikerjakan setelah seluruh fitur Must Have selesai.

## 2. System Architecture

Spark menggunakan arsitektur client-server sederhana.

**Flutter Application**
- User Interface
- State Management
- Camera & GPS
- Google Maps
- Local Notifications
- REST API Client

**Express Backend**
- Authentication
- Request Validation
- Parking Session Management
- File Upload & Retrieval
- Database Access

**Data Storage**
- MySQL untuk data terstruktur.
- Server file storage untuk foto parkir.

Alur komunikasi:

1. Flutter mengirimkan HTTP request ke Express.
2. Backend memvalidasi autentikasi dan input.
3. Backend membaca atau memperbarui data MySQL.
4. Backend mengelola file foto jika diperlukan.
5. Backend mengembalikan JSON response.
6. Flutter memperbarui state dan menampilkan hasil.

Tidak diperlukan microservices, message broker, WebSocket, maupun sistem sinkronisasi real-time.

## 3. Technology Stack

| Layer | Technology |
|---|---|
| Mobile UI | Flutter / Dart |
| State Management | Provider |
| HTTP Client | HTTP client Dart |
| Backend | Node.js / Express |
| Database | MySQL |
| Authentication | JWT Bearer Token |
| Password Security | Password hashing |
| Maps | Google Maps Flutter |
| Location | GPS / Location Services |
| Camera | Flutter Camera Plugin |
| File Upload | Multipart Form Data |
| Notifications | Android Local Notifications |
| Version Control | Git / GitHub |

Package dipilih berdasarkan kompatibilitas dan kebutuhan implementasi aktual. Gunakan dependency seperlunya dan hindari package dengan fungsi yang saling tumpang tindih.

## 4. Application Architecture

### 4.1. Flutter

Flutter menerapkan pemisahan tiga layer sesuai pedoman PPB:

**Presentation Layer**
- Screens / Pages
- Reusable Widgets
- Provider / State Management

**Domain Layer**
- Entity / Model domain
- Business Rules
- Repository Contracts

**Data Layer**
- API Services
- DTO / Serialization
- Repository Implementations
- Device Services (Camera, GPS, Notifications)

Pemisahan tersebut diterapkan secara pragmatis. Tidak perlu membuat abstraction atau use-case class untuk setiap operasi sederhana apabila tidak memberikan manfaat nyata.

### 4.2. Main Application Screens

| Screen | Responsibility |
|---|---|
| Login / Register | Autentikasi pengguna |
| Home | Menampilkan sesi parkir aktif |
| Add Parking | Mengisi kota, metode, tempat, area, dan catatan |
| Capture Photo | Mengambil foto kendaraan atau lingkungan parkir |
| Confirm Location | Menampilkan GPS dan penyesuaian pin Google Maps |
| Parking Detail | Menampilkan seluruh informasi sesi dan opsi selesai |
| Parking History | Menampilkan sesi parkir yang telah selesai |

Halaman pengaturan hanya dibuat apabila diperlukan oleh fitur yang sudah disepakati.

### 4.3. Backend

Backend menggunakan pemisahan tanggung jawab sederhana:

- **Routes:** Mendefinisikan endpoint.
- **Controllers:** Menangani request dan response.
- **Services:** Menangani aturan bisnis.
- **Database Access:** Menjalankan query dan mengelola data.
- **Middleware:** Autentikasi, validasi umum, dan penanganan error.

Tidak perlu menerapkan arsitektur backend berlapis secara berlebihan.

## 5. Database Design

Gunakan MySQL sebagai database utama.

### 5.1. Table: users

| Column | Type | Constraint |
|---|---|---|
| id | INT | PK, Auto Increment |
| name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(255) | UNIQUE, NOT NULL |
| password_hash | VARCHAR(255) | NOT NULL |
| created_at | DATETIME | NOT NULL |

Password disimpan dalam bentuk hash, bukan plaintext.

### 5.2. Table: cities

| Column | Type | Constraint |
|---|---|---|
| id | INT | PK, Auto Increment |
| name | VARCHAR(150) | NOT NULL |

Tabel berisi daftar kota yang disiapkan sebagai data referensi awal.

### 5.3. Table: malls

| Column | Type | Constraint |
|---|---|---|
| id | INT | PK, Auto Increment |
| city_id | INT | FK → cities.id |
| name | VARCHAR(150) | NOT NULL |

Setiap mall terhubung dengan satu kota.

Data mall disediakan sebagai seed/dummy data. Tidak diperlukan dashboard admin untuk mengelolanya pada versi awal.

### 5.4. Table: parking_sessions

| Column | Type | Constraint |
|---|---|---|
| id | INT | PK, Auto Increment |
| user_id | INT | FK → users.id, NOT NULL |
| city_id | INT | FK → cities.id, NOT NULL |
| mode | ENUM('structured', 'free') | NOT NULL |
| category | ENUM('mall', 'event', 'other') | NULL |
| mall_id | INT | FK → malls.id, NULL |
| place_name | VARCHAR(200) | NULL |
| area_code | VARCHAR(50) | NULL |
| notes | TEXT | NULL |
| latitude | DECIMAL(10,7) | NOT NULL |
| longitude | DECIMAL(10,7) | NOT NULL |
| photo_path | VARCHAR(255) | NOT NULL |
| reminder_minutes | INT | NULL |
| status | ENUM('active', 'completed') | NOT NULL, DEFAULT 'active' |
| created_at | DATETIME | NOT NULL |
| completed_at | DATETIME | NULL |

Gunakan indeks pada `user_id`, `status`, dan kolom foreign key sesuai kebutuhan query.

Seluruh waktu disimpan dalam UTC dan ditampilkan mengikuti zona waktu perangkat.

**Aturan data:**

1. Setiap sesi wajib memiliki `user_id`, `city_id`, foto, dan koordinat.
2. Mode `structured` wajib memiliki `category`.
3. Kategori `mall` wajib memiliki `mall_id` yang sesuai dengan `city_id`.
4. Kategori `event` dan `other` wajib mengisi `place_name`.
5. Mode `free` tidak membutuhkan kategori atau `mall_id`; `place_name` opsional.
6. `area_code` menyimpan kode akhir, baik dari dropdown maupun input manual.
7. `notes` dan `reminder_minutes` bersifat opsional.
8. Sesi baru memiliki status `active`.
9. Sesi selesai memiliki status `completed` dan `completed_at` terisi.
10. Setiap pengguna dapat mempunyai beberapa sesi aktif.

Tidak diperlukan tabel terpisah untuk kode area, catatan, foto utama, atau pengingat. Seluruh informasi tersebut cukup dikelola melalui `parking_sessions`.

## 6. REST API Specification

**Base URL:** `/api/v1`

Gunakan JSON untuk request/response biasa dan `multipart/form-data` untuk unggah foto.

### 6.1. Authentication

| Method | Endpoint | Description |
|---|---|---|
| POST | /auth/register | Registrasi akun |
| POST | /auth/login | Login dan mendapatkan token |

Login mengembalikan JWT dan informasi dasar pengguna.

Logout dilakukan di aplikasi dengan menghapus token dan state autentikasi lokal. Endpoint logout khusus tidak diperlukan pada rancangan autentikasi stateless ini.

Endpoint yang membutuhkan autentikasi menggunakan:

`Authorization: Bearer <token>`

Token disimpan menggunakan secure storage pada perangkat, bukan hardcoded atau disimpan sebagai teks biasa.

Token memiliki masa berlaku. Ketika masa berlaku habis, pengguna diminta login kembali.

### 6.2. Location Reference

| Method | Endpoint | Description |
|---|---|---|
| GET | /cities | Mengambil daftar kota |
| GET | /malls?city_id={id} | Mengambil daftar mall berdasarkan kota |

Tidak diperlukan endpoint untuk membuat, memperbarui, atau menghapus kota dan mall melalui aplikasi.

Data awal dikelola menggunakan seed database.

### 6.3. Parking Sessions

| Method | Endpoint | Description |
|---|---|---|
| POST | /parking-sessions | Membuat sesi parkir baru |
| GET | /parking-sessions?status=active | Mengambil sesi aktif |
| GET | /parking-sessions?status=completed | Mengambil riwayat parkir |
| GET | /parking-sessions/:id | Mengambil detail sesi |
| GET | /parking-sessions/:id/photo | Mengambil foto sesi |
| PATCH | /parking-sessions/:id/complete | Menyelesaikan sesi parkir |

Seluruh endpoint sesi parkir membutuhkan autentikasi.

### 6.4. Create Parking Session

**Endpoint:** `POST /parking-sessions`

**Content-Type:** `multipart/form-data`

Field:

| Field | Required | Description |
|---|---|---|
| city_id | Yes | Kota yang dipilih |
| mode | Yes | structured / free |
| category | Conditional | Wajib untuk structured |
| mall_id | Conditional | Wajib untuk kategori mall |
| place_name | Conditional | Wajib untuk event/other; opsional untuk free |
| area_code | No | Kode lantai atau zona |
| notes | No | Catatan tambahan |
| latitude | Yes | Koordinat latitude |
| longitude | Yes | Koordinat longitude |
| reminder_minutes | No | Durasi pengingat dalam menit |
| photo | Yes | File foto parkir |

Backend harus:
1. Memvalidasi token.
2. Memvalidasi field wajib berdasarkan mode dan kategori.
3. Memastikan mall terdaftar pada kota yang dipilih.
4. Memvalidasi koordinat.
5. Memvalidasi jenis dan ukuran file foto.
6. Menyimpan file foto.
7. Menyimpan sesi parkir ke MySQL.
8. Mengembalikan data sesi yang berhasil dibuat.

Jika penyimpanan database gagal, file yang terlanjur diunggah harus dibersihkan agar tidak menjadi file yatim.

Apabila request gagal, aplikasi tidak boleh langsung menampilkan status berhasil.

### 6.5. Complete Parking Session

**Endpoint:** `PATCH /parking-sessions/:id/complete`

Aturan:
1. Sistem memverifikasi pemilik sesi berdasarkan token.
2. Sesi berstatus `active` dapat diubah menjadi `completed`.
3. Backend mencatat `completed_at`.
4. Sesi lain tidak mengalami perubahan.
5. Request berulang pada sesi yang sudah selesai tidak boleh mengubah waktu penyelesaian pertama.

Setelah menerima response berhasil, Flutter membatalkan notifikasi lokal untuk sesi terkait dan memperbarui daftar sesi aktif serta riwayat.

### 6.6. API Response Convention

Response sukses menggunakan format konsisten:

`{"data": ...}`

Response gagal:

`{"error": {"code": "...", "message": "..."}}`

Gunakan HTTP status code yang sesuai, antara lain:

- 200: Berhasil.
- 201: Data berhasil dibuat.
- 400: Input tidak valid.
- 401: Belum terautentikasi atau token tidak valid.
- 404: Data tidak ditemukan atau bukan milik pengguna.
- 409: Konflik status/operasi.
- 413: File melebihi batas unggah.
- 500: Kegagalan server.

Pesan error tidak boleh mengungkap password, token, lokasi file internal, atau detail database.

## 7. Core Business Rules

### 7.1. Location Selection

- Kota wajib dipilih pada semua metode pencatatan.
- Structured + Mall: pilih mall dari daftar sesuai kota.
- Structured + Event/Other: isi nama tempat manual.
- Free: nama tempat opsional.
- Area parkir opsional pada semua metode.
- Dropdown area menyediakan B1, B2, R1, R2, dan Lainnya.
- Ketika Lainnya dipilih, pengguna dapat memasukkan kode manual.
- Backend hanya menyimpan kode area final, bukan nilai dropdown "Lainnya".
- Jika kota berubah, pilihan mall sebelumnya harus direset.
- Perbedaan koordinat GPS dan kota yang dipilih tidak membutuhkan validasi geografis otomatis pada versi awal.

### 7.2. GPS & Google Maps

- GPS diambil ketika membuat sesi parkir.
- Aplikasi menampilkan koordinat awal pada Google Maps.
- Pengguna dapat memindahkan pin sebelum menyimpan.
- Koordinat yang dikirim ke backend merupakan posisi pin terakhir yang dikonfirmasi.
- Jika GPS tidak tersedia atau izin ditolak, aplikasi menampilkan error dan opsi mencoba kembali.
- Informasi lantai/zona berasal dari input pengguna, bukan hasil estimasi GPS.
- Tidak diperlukan reverse geocoding maupun navigasi indoor otomatis.

### 7.3. Parking Session Lifecycle

Status sesi:

`active → completed`

Aturan:
- Sesi baru selalu berstatus active.
- Beberapa sesi active dapat dimiliki satu akun.
- Penyelesaian dilakukan melalui konfirmasi pengguna.
- Sesi completed tetap disimpan sebagai riwayat.
- Sesi completed tidak dapat diaktifkan kembali pada versi awal.
- Tidak diperlukan fitur penghapusan sesi pada versi awal.

### 7.4. Photo Storage

- Satu sesi parkir memiliki satu foto utama.
- Foto diambil dari kamera perangkat.
- File lokal digunakan untuk preview dan proses upload.
- Foto disimpan pada penyimpanan server yang persisten.
- MySQL menyimpan referensi path file, bukan binary foto.
- Foto tidak boleh diakses langsung melalui folder publik tanpa pemeriksaan autentikasi.
- Endpoint foto memverifikasi kepemilikan sesi sebelum mengirimkan file.
- File sementara yang tidak diperlukan dibersihkan setelah proses berhasil atau gagal.

## 8. Notification Mechanism

Pengingat menggunakan local notification pada perangkat Android.

**Alur:**

1. Pengguna memilih durasi pengingat atau tanpa pengingat.
2. Aplikasi menyimpan sesi melalui API.
3. Backend mengembalikan ID sesi dan waktu pencatatan.
4. Flutter menghitung jadwal notifikasi berdasarkan waktu pencatatan dan durasi pengingat.
5. Aplikasi menjadwalkan notifikasi menggunakan ID yang terhubung dengan ID sesi.
6. Saat sesi berhasil diselesaikan, aplikasi membatalkan notifikasi terkait yang belum muncul.

Aturan:
- Setiap sesi menggunakan identitas notifikasi yang berbeda.
- Tanpa pengingat berarti tidak ada notifikasi terjadwal.
- Penjadwalan dilakukan setelah sesi berhasil disimpan.
- Waktu pengingat mengikuti waktu pencatatan sesi, bukan waktu pengguna membuka detail.
- Saat aplikasi dibuka kembali, jadwal lokal dapat direkonsiliasi menggunakan data sesi aktif.
- Ketika logout, notifikasi milik akun yang keluar dibatalkan pada perangkat.
- Pengingat tidak menggunakan server push notification.
- Pengingat pada perangkat lain tidak otomatis tersedia hanya karena sesi tersimpan di server.

Aplikasi meminta izin notifikasi sesuai ketentuan Android. Ketepatan waktu tampilnya notifikasi mengikuti kemampuan dan kebijakan sistem operasi.

Tidak diperlukan layanan background tracking atau exact alarm khusus selama pengingat tidak menuntut ketepatan waktu hingga detik tertentu.

## 9. State Management

Gunakan Provider untuk mengelola state utama aplikasi.

State minimal:

| State | Responsibility |
|---|---|
| Auth | Status login dan informasi pengguna |
| Parking Sessions | Sesi aktif, riwayat, loading, dan error |
| Parking Form | Kota, metode, tempat, area, catatan, foto, koordinat, dan durasi pengingat |

State form disimpan sementara selama proses pencatatan dan hanya dikirim ke server setelah pengguna mengonfirmasi.

Gunakan loading, success, empty, dan error state pada operasi asinkron.

Hindari membuat global provider untuk state yang hanya digunakan pada satu widget dan tidak perlu dibagikan.

## 10. Validation & Error Handling

### Client-side Validation

- Kota wajib dipilih.
- Foto wajib tersedia.
- Koordinat wajib tersedia.
- Kategori wajib dipilih untuk mode structured.
- Mall wajib dipilih untuk kategori mall.
- Nama tempat wajib untuk kategori event dan other.
- Input area manual tidak boleh kosong apabila opsi Lainnya dipilih sebagai nilai area.
- Reminder harus berupa durasi valid jika diaktifkan.

### Server-side Validation

Semua validasi data penting harus diulang pada server.

Backend harus memeriksa:
- Autentikasi.
- Kepemilikan sesi parkir.
- Relasi kota dan mall.
- Nilai mode dan kategori.
- Rentang latitude dan longitude.
- File foto yang diterima.
- Status sesi sebelum penyelesaian.

### Failure Scenarios

| Kondisi | Expected Behavior |
|---|---|
| Kamera ditolak | Tampilkan permintaan izin atau petunjuk pengaturan |
| GPS tidak tersedia | Tampilkan pesan dan opsi retry |
| Koneksi terputus | Tampilkan kegagalan dan pertahankan form sementara |
| Upload foto gagal | Sesi tidak dinyatakan berhasil |
| Server gagal menyimpan | Tampilkan error, bersihkan file sementara di server |
| Token kedaluwarsa | Minta pengguna login kembali |
| Sesi bukan milik pengguna | Tolak permintaan |
| Notifikasi tidak diizinkan | Sesi tetap tersimpan; beri informasi bahwa pengingat tidak aktif |
| Sesi sudah completed | Jangan ubah status atau waktu selesai kembali |
| Daftar sesi kosong | Tampilkan empty state yang sesuai |

## 11. Security & Configuration

- Password menggunakan hashing yang aman.
- JWT ditandatangani menggunakan secret dari environment.
- Token tidak dicatat dalam log.
- Backend memeriksa user ID dari token, bukan mempercayai user ID yang dikirim client.
- Endpoint foto dan sesi wajib memeriksa kepemilikan data.
- File upload dibatasi berdasarkan ukuran dan format yang diizinkan.
- Secret database, JWT, dan konfigurasi sensitif disimpan melalui environment.
- Google Maps API key dibatasi penggunaannya sesuai konfigurasi aplikasi Android.
- Koneksi server produksi menggunakan HTTPS.
- File environment rahasia tidak dimasukkan ke repository.
- Akun hanya dapat membaca dan mengubah data yang dimilikinya.

Gunakan batas ukuran foto dan kompresi yang wajar setelah pengujian pada perangkat target.

## 12. Implementation Plan

Implementasi dilakukan secara bertahap.

### Phase 1 — Foundation
- Flutter project setup.
- Express project setup.
- MySQL connection.
- Struktur folder.
- Konfigurasi environment.

### Phase 2 — Authentication & Reference Data
- Registrasi dan login.
- JWT authentication.
- Daftar kota.
- Dummy data mall berdasarkan kota.

### Phase 3 — Parking Capture
- Form terstruktur dan bebas.
- Camera integration.
- GPS integration.
- Google Maps dan draggable pin.
- Catatan serta kode area parkir.

### Phase 4 — Parking Sessions
- Upload dan penyimpanan foto.
- Create parking session.
- Multiple active sessions.
- Detail parking.
- Complete parking.
- Parking history.

### Phase 5 — Notifications
- Pengingat berdasarkan durasi.
- Penjadwalan notifikasi lokal.
- Pembatalan notifikasi setelah sesi selesai.

### Phase 6 — Verification
- Pengujian fitur Must Have.
- Pengujian integrasi REST API.
- Pengujian akses data pengguna.
- Pengujian kegagalan kamera, GPS, koneksi, dan notifikasi.
- Validasi sembilan persyaratan teknis PPB.
- Perbaikan bug yang ditemukan.

Fase dapat dikerjakan secara iteratif. Tidak diperlukan sprint framework khusus apabila pembagian task sederhana sudah mencukupi.

## 13. Definition of Done

Sebuah fitur dinyatakan selesai apabila:

1. Implementasi sesuai requirement PRD terkait.
2. Alur utama berhasil dijalankan pada Android.
3. Data yang dikirim dan diterima sesuai kontrak API.
4. Error handling relevan tersedia.
5. Tidak menyebabkan regresi pada fitur yang sudah berjalan.
6. Pengujian yang relevan telah dilakukan dan hasilnya dicatat.
7. Perubahan code dan konfigurasi dapat dijelaskan oleh anggota tim.

## 14. Out of Scope

Implementasi berikut tidak termasuk dalam target versi awal:

- Pelacakan kendaraan real-time.
- Deteksi parkir otomatis.
- Navigasi indoor presisi.
- Sistem reservasi atau ketersediaan slot parkir.
- Dashboard admin pengelolaan mall.
- Integrasi API pengelola parkir komersial.
- Payment gateway.
- Push notification server.
- Offline synchronization.
- Multi-photo per parking session.

Fitur Should Have dan Could Have tetap mengikuti prioritas PRD.

## 15. Technical Decisions & Change Control

Dokumen ini merupakan rancangan teknis awal. Implementasi aktual harus tetap mengikuti PRD sebagai sumber kebutuhan produk.

Keputusan yang telah ditetapkan untuk baseline:

- Flutter dan Dart untuk aplikasi Android.
- Node.js dan Express untuk backend.
- MySQL untuk database utama.
- Provider untuk state management awal.
- JWT untuk autentikasi API.
- Penyimpanan foto melalui backend.
- Satu tabel utama parking_sessions untuk data sesi.
- REST API sebagai komunikasi aplikasi dan backend.
- Local notification tanpa push notification server.

Jika terdapat kendala teknis yang menuntut perubahan rancangan, perubahan harus dievaluasi berdasarkan kebutuhan nyata, risiko, dan dampaknya terhadap PRD.

**Implementation Principle:** Build only what is required. Follow existing conventions, keep changes focused, and avoid unnecessary complexity.