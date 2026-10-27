# SPARK — Technical Specification

**Project:** Spark – Spot My Park

**Platform:** Android (Flutter + Dart)

**Data:** Dummy data lokal + Provider/AppState (dalam memori)

**Status:** Frontend-only Technical Baseline

**Reference:** [PRD.md](PRD.md)

## 1. Purpose & Scope

Dokumen ini mendefinisikan rancangan teknis Spark – Spot My Park berdasarkan PRD dan keputusan scope terbaru dari dosen: hanya Flutter frontend menggunakan dummy data, tanpa backend, REST API, JWT, atau database persisten.

Implementasi difokuskan pada fitur Must Have:

- Simulasi registrasi, login, dan logout menggunakan data lokal.
- Pencatatan lokasi parkir terstruktur dan bebas.
- Pemilihan kota dan dummy data mall.
- Pengambilan foto dan GPS.
- Penyesuaian pin Google Maps.
- Simulasi penyimpanan sesi parkir melalui shared state lokal.
- Pengelolaan beberapa sesi aktif.
- Detail dan riwayat parkir.
- Informasi lantai, area, dan catatan.
- Pengingat durasi parkir.
- Penyelesaian sesi parkir.

Fitur Should Have dan Could Have tetap mengikuti prioritas PRD dan dikerjakan setelah seluruh fitur Must Have selesai. ID FR tidak berubah.

Kamera, GPS, Google Maps, dan local notifications menggunakan kemampuan perangkat Android secara nyata. Foto berupa file lokal perangkat. Registrasi/login bukan autentikasi aman terhadap server; data runtime tidak dijamin bertahan setelah restart.

Server-based Database dan API Integration belum diimplementasikan karena pembatasan scope terbaru. Pengecualian kedua persyaratan PPB tersebut masih perlu dipastikan dengan dosen dalam penilaian akhir. Penggunaan Google Maps tidak diklaim memenuhi persyaratan API Integration tersebut.

## 2. System Architecture

Spark menggunakan shared state lokal di dalam aplikasi Flutter.

- **Presentation:** Delapan halaman, reusable widgets, dan navigation/routing.
- **Shared Models:** User, City, Mall, ParkingSession, dan ParkingDraft.
- **Initial Data:** Satu file bersama, `lib/data/mock_data.dart`, untuk dummy user, kota, mall berdasarkan kota, serta contoh sesi parkir.
- **AppState:** Provider mengelola pengguna lokal, sesi aktif, riwayat, dan draft selama runtime.
- **Device Integration:** Kamera, GPS, Google Maps, file foto lokal, serta penjadwalan/pembatalan notifikasi lokal.

Alur data:

1. AppState menginisialisasi salinan data awal dari `mock_data.dart` sekali saat aplikasi dimulai.
2. Halaman membaca data melalui AppState dan menggunakan shared models.
3. Input pencatatan dikumpulkan dalam satu ParkingDraft lintas halaman.
4. Setelah konfirmasi dan validasi lokal, AppState membuat atau memperbarui sesi dalam memori.
5. AppState memanggil `notifyListeners()` agar halaman terkait menampilkan perubahan.
6. Integrasi perangkat mengambil foto/koordinat dan mengatur notifikasi berdasarkan sesi terkait.

`mock_data.dart` hanya berisi data awal; perubahan runtime tidak ditulis kembali ke file tersebut. Jangan membuat salinan dummy data di masing-masing halaman. Restart menginisialisasi ulang data awal, tanpa pemulihan akun, sesi, atau riwayat yang berubah pada runtime sebelumnya.

## 3. Technology Stack

| Layer | Technology |
|---|---|
| Mobile UI | Flutter / Dart untuk Android |
| State Management | Provider / AppState |
| Initial Data | `lib/data/mock_data.dart` |
| Runtime Data | Shared models dan koleksi dalam memori AppState |
| Login / Register | Simulasi lokal dengan kredensial dummy |
| Maps | Google Maps Flutter |
| Location | GPS / Location Services perangkat |
| Camera | Flutter Camera Plugin |
| Photo Storage | File lokal perangkat; path disimpan pada model sesi |
| Notifications | Android Local Notifications |
| Version Control | Git / GitHub |

Gunakan dependency yang sudah disepakati untuk kebutuhan tersebut; dokumen ini tidak menambah dependency atau HTTP client. Google Maps tetap dapat memerlukan koneksi internet untuk memuat peta.

## 4. Application Architecture

### 4.1. Flutter

Pemisahan tanggung jawab dilakukan secara sederhana mengikuti struktur dan konvensi project:

- **Pages / Widgets:** UI, navigasi, input, serta loading/empty/error state.
- **Shared Models:** Kontrak data bersama untuk semua halaman.
- **AppState:** Operasi pengguna simulasi, draft, dan pengelolaan sesi melalui Provider.
- **Data:** `lib/data/mock_data.dart` sebagai satu sumber dummy data awal.
- **Device Integration:** Camera, GPS, Google Maps, foto lokal, dan notifications.

Tidak diperlukan repository/API layer, DTO server, atau use-case class untuk setiap operasi sederhana.

### 4.2. Main Application Screens

| Screen | Responsibility |
|---|---|
| Login | Simulasi login akun lokal dan navigasi ke Register |
| Register | Simulasi pendaftaran pengguna lokal |
| Home | Menampilkan `activeSessions` dan akses tambah/detail/riwayat |
| Add Parking | Mengisi kota, metode, tempat, area, catatan, dan durasi pengingat pada draft |
| Capture Photo | Mengambil foto perangkat dan mengisi path foto pada draft |
| Confirm Location | Mengambil GPS, menyesuaikan pin Google Maps, dan mengonfirmasi penyimpanan draft |
| Parking Detail | Menampilkan sesi berdasarkan ID dan opsi selesai untuk sesi aktif |
| Parking History | Menampilkan `parkingHistory` dan akses detail sesi selesai |

### 4.3. Navigation & Routing

- Login ↔ Register; setelah login/register berhasil, buka Home.
- Home → Add Parking → Capture Photo → Confirm Location → Home setelah penyimpanan.
- Home → Parking Detail; Home → Parking History → Parking Detail.
- Detail menerima ID sesi dan membaca `getParkingById()`, sehingga tidak menyimpan salinan sesi yang dapat tertinggal dari AppState.
- Kembali antarhalaman pencatatan mempertahankan draft; batal atau selesai menyimpan membersihkan draft.
- Logout mengosongkan pengguna aktif dan draft, membatalkan pengingat akun tersebut, lalu kembali ke Login serta menghapus akses kembali ke halaman akun melalui tombol Back.

Routing menggunakan mekanisme Flutter yang tersedia. Tidak ada halaman tambahan atau dependency routing baru yang diwajibkan.

## 5. Shared Model Contracts

Kontrak berikut menjadi acuan bersama Phase 0 dan pengembangan halaman paralel; bukan schema database. Gunakan nama field Dart yang konsisten. ID bertipe `String` dan unik dalam koleksi terkait; waktu bertipe `DateTime`, disimpan sebagai UTC dan ditampilkan sesuai zona perangkat.

### 5.1. User

| Field | Type | Keterangan |
|---|---|---|
| id | String | Identitas pengguna lokal |
| name | String | Nama pengguna |
| email | String | Email untuk simulasi login, unik tanpa membedakan huruf besar/kecil |
| password | String | Kredensial dummy untuk perbandingan lokal; hanya untuk demo |

User awal berasal dari mock data; hasil register disimpan dalam memori AppState. Jangan menggunakan kredensial nyata. Tidak ada token atau jaminan keamanan autentikasi.

### 5.2. City

| Field | Type | Keterangan |
|---|---|---|
| id | String | Identitas kota |
| name | String | Nama kota |

### 5.3. Mall

| Field | Type | Keterangan |
|---|---|---|
| id | String | Identitas mall |
| cityId | String | Referensi City |
| name | String | Nama mall |

Kota dan mall merupakan data referensi awal dari `mock_data.dart`, tanpa fitur pengelolaan admin.

### 5.4. ParkingSession

| Field | Type | Keterangan |
|---|---|---|
| id | String | ID sesi unik, dibuat AppState tanpa bentrok dengan ID contoh |
| userId | String | Pemilik sesi lokal |
| cityId | String | Kota wajib |
| mode | String | `structured` / `free` |
| category | String? | `mall` / `event` / `other`; hanya untuk structured |
| mallId | String? | Wajib untuk kategori mall, sesuai cityId |
| placeName | String? | Wajib untuk event/other; opsional untuk free; nama mall dari referensi Mall |
| areaCode | String? | Kode akhir dropdown atau input manual |
| notes | String? | Catatan tambahan |
| latitude | double | Latitude pin terakhir yang dikonfirmasi |
| longitude | double | Longitude pin terakhir yang dikonfirmasi |
| photoPath | String | Path file foto lokal perangkat |
| reminderMinutes | int? | Durasi positif dalam menit; null berarti tanpa pengingat |
| status | String | `active` / `completed` |
| createdAt | DateTime | Waktu pencatatan |
| completedAt | DateTime? | Terisi saat completed |

Setiap sesi memiliki satu foto dan satu titik koordinat. Contoh sesi aktif dan selesai berasal dari mock data dengan relasi user/kota/mall yang valid. Path contoh tidak boleh bergantung pada URL server; jika file lokal contoh belum tersedia pada perangkat, tampilkan placeholder/informasi foto tidak tersedia. Sesi baru tetap wajib menggunakan foto kamera nyata.

### 5.5. ParkingDraft

ParkingDraft menampung `cityId`, `mode`, `category`, `mallId`, `placeName`, `areaCode`, `notes`, `photoPath`, `latitude`, `longitude`, dan `reminderMinutes` dengan tipe yang sama seperti ParkingSession. Field yang belum diisi dapat null selama alur form; `mode` harus dipilih sebelum lanjut.

Draft tidak mempunyai ID sesi, userId, status, atau timestamp. AppState menetapkan field tersebut saat `addParking()` berhasil. Draft dibagikan sepanjang Add Parking → Capture Photo → Confirm Location dan tidak menjadi sesi aktif sebelum dikonfirmasi.

## 6. AppState Contract

Gunakan satu AppState berbasis `ChangeNotifier` yang disediakan melalui Provider. Koleksi internal dapat berubah hanya melalui metode AppState; halaman membaca getter dan tidak memodifikasi koleksi langsung.

### 6.1. State & Queries

| Member | Contract |
|---|---|
| currentUser | `User?`; null saat belum login |
| cities | `List<City>` read-only dari data awal |
| getMallsByCity(String cityId) | `List<Mall>` read-only, difilter berdasarkan cityId; kosong jika tidak ada |
| activeSessions | `List<ParkingSession>` read-only milik currentUser dengan status active |
| parkingHistory | `List<ParkingSession>` read-only milik currentUser dengan status completed |
| getParkingById(String id) | `ParkingSession?` milik currentUser; null jika tidak ditemukan atau milik pengguna lain |
| parkingDraft | `ParkingDraft?` yang dibagikan selama alur pencatatan |

Tanpa currentUser, getter sesi mengembalikan daftar kosong dan pencarian ID mengembalikan null. Ini filter lokal untuk perilaku demo, bukan otorisasi aman.

### 6.2. User Simulation

| Method | Contract |
|---|---|
| login(String email, String password) → bool | Bandingkan kredensial dengan pengguna lokal; true menetapkan currentUser, false membuat UI menampilkan pesan |
| register(String name, String email, String password) → bool | Validasi input dan email unik; true membuat user lokal dan menetapkan currentUser, false membuat UI menampilkan pesan |
| logout() → void | Kosongkan currentUser/draft; koordinasikan pembatalan notifikasi akun yang keluar |

Pengguna terdaftar dapat login kembali selama AppState yang sama masih hidup. Logout tidak menghapus koleksi user/sesi runtime, tetapi restart tidak menjamin akun atau perubahan tersebut tersedia.

### 6.3. Parking Mutations

| Method | Contract |
|---|---|
| addParking(ParkingDraft draft) → ParkingSession | Validasi lokal dan currentUser; buat ID serta createdAt, simpan referensi foto dan koordinat, tetapkan status active, lalu tambahkan ke koleksi sesi |
| completeParking(String id) → ParkingSession | Ambil sesi pengguna aktif, ubah active menjadi completed dan isi completedAt; sesi lain tidak berubah |

Jika input tidak valid, operasi melempar ArgumentError; jika pengguna belum login atau sesi tidak ditemukan/bukan milik pengguna, operasi melempar StateError. Koleksi tidak berubah dan UI menangani error dengan pesan yang sesuai. Pemanggilan completeParking berulang mengembalikan sesi selesai tanpa mengubah waktu selesai pertama. Pengingat sesi terkait dibatalkan setelah perubahan status, termasuk saat mencoba kembali pembatalan yang sebelumnya gagal.

Sediakan operasi memulai, memperbarui, dan membersihkan parkingDraft melalui AppState; nama metode mengikuti konvensi implementasi Phase 0. Setiap perubahan user, draft, atau sesi memanggil `notifyListeners()`. Integrasi perangkat menjadwalkan notifikasi setelah addParking berhasil; kegagalan izin/jadwal notifikasi tidak menghapus sesi yang sudah dibuat.

## 7. Core Business Rules

### 7.1. Location Selection

- Kota wajib dipilih pada semua metode pencatatan.
- Structured + Mall: pilih mall dari daftar sesuai kota.
- Structured + Event/Other: isi nama tempat manual.
- Free: nama tempat opsional.
- Area parkir opsional pada semua metode.
- Dropdown area menyediakan B1, B2, R1, R2, dan Lainnya.
- Ketika Lainnya dipilih, pengguna dapat memasukkan kode manual.
- Model sesi hanya menyimpan kode area final, bukan nilai dropdown "Lainnya".
- Jika kota berubah, pilihan mall sebelumnya harus direset.
- Perbedaan koordinat GPS dan kota yang dipilih tidak membutuhkan validasi geografis otomatis pada versi awal.

### 7.2. GPS & Google Maps

- GPS diambil ketika membuat sesi parkir.
- Aplikasi menampilkan koordinat awal pada Google Maps.
- Pengguna dapat memindahkan pin sebelum menyimpan.
- Koordinat yang disimpan di AppState merupakan posisi pin terakhir yang dikonfirmasi.
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
- Sesi completed tetap disimpan sebagai riwayat di AppState selama runtime.
- Sesi completed tidak dapat diaktifkan kembali pada versi awal.
- Tidak diperlukan fitur penghapusan sesi pada versi awal.

### 7.4. Photo Storage

- Satu sesi parkir memiliki satu foto utama.
- Foto diambil dari kamera perangkat.
- File lokal digunakan untuk preview serta tampilan detail/riwayat.
- ParkingSession.photoPath menyimpan path file lokal, tanpa upload ke server.
- AppState menyimpan referensi path, bukan binary foto.
- File yang direferensikan sesi atau draft tidak dibersihkan selama masih diperlukan.
- Jika file hilang/tidak terbaca, tampilkan placeholder dan pesan yang sesuai.
- Foto dari draft yang dibatalkan dapat dibersihkan jika tidak digunakan sesi lain; tidak ada jaminan pemulihan data setelah restart.

## 8. Notification Mechanism

Pengingat menggunakan local notification pada perangkat Android.

**Alur:**

1. Pengguna memilih durasi pengingat atau tanpa pengingat.
2. AppState.addParking() menghasilkan sesi lokal beserta ID dan createdAt.
3. Flutter menghitung jadwal berdasarkan createdAt dan reminderMinutes.
4. Aplikasi menjadwalkan notifikasi dengan identitas unik yang terhubung ke ID sesi.
5. Saat sesi diselesaikan melalui completeParking(), aplikasi membatalkan notifikasi terkait yang belum muncul.

Aturan:

- Tanpa pengingat berarti tidak ada notifikasi terjadwal.
- Penjadwalan dilakukan setelah sesi berhasil ditambahkan ke AppState.
- Waktu pengingat mengikuti waktu pencatatan, bukan waktu membuka detail.
- Sesi tetap tersedia jika izin notifikasi ditolak atau penjadwalan gagal; tampilkan informasi bahwa pengingat tidak aktif.
- Ketika logout, notifikasi milik akun yang keluar dibatalkan. Login kembali dalam runtime yang sama menjadwalkan ulang hanya pengingat sesi aktif yang waktunya belum lewat.
- Jadwal notifikasi dikelola OS dan dapat hidup lebih lama daripada AppState. Pada inisialisasi aplikasi, batalkan jadwal Spark yang tertinggal sebelum memuat ulang data awal; jangan menjanjikan pemulihan sesi atau pengingat setelah restart.
- Contoh sesi dalam mock data tidak otomatis menjadwalkan pengingat yang waktunya sudah lewat.
- Kegagalan pembatalan notifikasi diberi pesan dan opsi mencoba kembali; sesi yang sudah selesai tetap berstatus completed.
- Pengingat tidak menggunakan server push notification.

Aplikasi meminta izin notifikasi sesuai ketentuan Android. Ketepatan waktu tampilnya notifikasi mengikuti kemampuan dan kebijakan sistem operasi.

Tidak diperlukan layanan background tracking atau exact alarm khusus selama pengingat tidak menuntut ketepatan waktu hingga detik tertentu.

## 9. State Management

Gunakan Provider/AppState untuk mengelola state utama sesuai kontrak bagian 6.

| State | Responsibility |
|---|---|
| User Simulation | Pengguna lokal dan currentUser |
| Parking Sessions | Koleksi sesi runtime; activeSessions dan parkingHistory merupakan hasil filter koleksi yang sama |
| Parking Draft | Kota, metode, tempat, area, catatan, foto, koordinat, dan durasi pengingat lintas halaman |

State form disimpan sementara dan baru menjadi ParkingSession setelah konfirmasi. Pembatalan alur membersihkan draft tanpa menambah sesi. Perubahan kota mereset mall; perubahan metode/kategori membersihkan field yang tidak lagi relevan.

Gunakan loading, success, empty, dan error state untuk operasi perangkat asinkron. State UI yang hanya diperlukan satu widget tetap lokal. Jangan menginisialisasi ulang mock data saat berpindah halaman atau membuat koleksi sesi terpisah di Home, Detail, dan History.

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
- AppState memeriksa pengguna aktif, relasi kota/mall, nilai mode/kategori, rentang koordinat, serta file foto lokal sebelum menambah sesi.
- Status dan kepemilikan lokal diperiksa sebelum menyelesaikan sesi; ini validasi frontend, bukan keamanan server.

### Failure Scenarios

| Kondisi | Expected Behavior |
|---|---|
| Kamera ditolak | Tampilkan permintaan izin atau petunjuk pengaturan |
| GPS tidak tersedia | Tampilkan pesan dan opsi retry |
| Peta gagal dimuat / koneksi peta terputus | Tampilkan pesan dan opsi retry; pertahankan draft |
| Foto lokal tidak dapat dibaca | Minta ambil ulang pada draft; tampilkan placeholder pada detail/riwayat |
| Draft tidak valid | Tampilkan field bermasalah; jangan menambah sesi |
| Kredensial lokal salah / email sudah digunakan | Tampilkan pesan simulasi login/register gagal |
| Sesi tidak ditemukan / bukan milik pengguna lokal | Jangan tampilkan atau ubah sesi; beri pesan |
| Notifikasi tidak diizinkan / gagal dijadwalkan | Sesi tetap di AppState; beri informasi bahwa pengingat tidak aktif |
| Sesi sudah completed | Jangan ubah status atau waktu selesai kembali |
| Daftar sesi kosong | Tampilkan empty state yang sesuai |

## 11. Security & Configuration

- Login/register merupakan simulasi lokal dengan kredensial dummy; tidak ada hashing server, JWT, atau jaminan keamanan akun produksi.
- Gunakan data demo, bukan kredensial nyata, dan jangan mencatat password ke log.
- Filter userId dilakukan AppState untuk konsistensi tampilan dan mutasi lokal.
- Foto dibaca dari file lokal; path foto bukan URL upload atau penyimpanan server.
- Google Maps API key dibatasi penggunaannya sesuai konfigurasi aplikasi Android.
- File konfigurasi rahasia tidak dimasukkan ke repository.
- Izin kamera, lokasi, dan notifikasi diminta serta ditangani sesuai kebutuhan alur pengguna.

Gunakan ukuran foto yang wajar setelah pengujian pada perangkat target. Tidak ada database persisten atau jaminan bahwa referensi foto dan data sesi dapat dipulihkan setelah restart.

## 12. Implementation Plan

Implementasi dilakukan secara bertahap. Roadmap ini merupakan acuan pekerjaan; revisi dokumentasi tidak mengimplementasikan foundation.

### Phase 0 — Flutter Foundation

- Flutter foundation dan struktur folder mengikuti konvensi project.
- Navigation/routing serta skeleton untuk delapan halaman pada bagian 4.2.
- Shared models User, City, Mall, ParkingSession, dan ParkingDraft.
- Satu sumber mock data user, kota, mall berdasarkan kota, serta contoh sesi di `lib/data/mock_data.dart`.
- Provider/AppState beserta getter/metode bagian 6 dan lifecycle draft.
- Sepakati kontrak model, state, serta parameter navigasi sebelum pengembangan halaman paralel.

### Phase 1 — Parallel Page Development

- Kembangkan UI Login dan Register menggunakan simulasi akun pada AppState.
- Kembangkan Home, Parking Detail, dan Parking History menggunakan getter sesi bersama.
- Kembangkan Add Parking, Capture Photo, dan Confirm Location menggunakan ParkingDraft yang sama.
- Setiap bagian memakai kontrak Phase 0; jangan membuat dummy data atau state sesi sendiri di halaman.

### Phase 2 — Device Integration dan Interaksi

- Hubungkan kamera nyata dan preview file foto lokal.
- Hubungkan GPS, Google Maps, draggable pin, serta konfirmasi koordinat.
- Hubungkan form terstruktur/bebas, penyimpanan draft, dan penyelesaian sesi.
- Jadwalkan/batalkan local notifications dan tangani izin serta kegagalan perangkat.

### Phase 3 — Integration & Testing

- Uji seluruh fitur Must Have dan navigasi delapan halaman pada Android.
- Uji simulasi register/login/logout, pemisahan sesi lokal, dan konsistensi Home/Detail/History.
- Uji kedua metode pencatatan, daftar mall per kota, serta field opsional.
- Uji kamera, GPS, peta gagal dimuat, file foto hilang, izin ditolak, dan notifikasi.
- Uji penyelesaian berulang, pembatalan draft, beberapa sesi aktif, serta batas reset data setelah restart.
- Verifikasi persyaratan PPB dalam scope dan catat pengecualian server-based database/API Integration.

### Phase 4 — Finalization

- Perbaiki bug hasil integrasi dan rapikan UI sesuai desain yang disepakati.
- Finalisasi dokumentasi serta demonstrasi fitur dan keterbatasan simulasi.
- Pastikan pengecualian scope PPB dengan dosen untuk penilaian akhir.

Fase dapat dikerjakan secara iteratif. Tidak diperlukan sprint framework khusus apabila pembagian task sederhana sudah mencukupi.

## 13. Definition of Done

Sebuah fitur dinyatakan selesai apabila:

1. Implementasi sesuai requirement PRD terkait.
2. Alur utama berhasil dijalankan pada Android.
3. Data dan perubahan state sesuai shared models serta kontrak AppState; seluruh halaman menggunakan sumber data yang sama.
4. Error handling relevan tersedia.
5. Tidak menyebabkan regresi pada fitur yang sudah berjalan.
6. Pengujian yang relevan telah dilakukan dan hasilnya dicatat.
7. Perubahan code dan konfigurasi dapat dijelaskan oleh anggota tim.
8. Keterbatasan simulasi login dan data runtime dijelaskan; tidak ada klaim pemenuhan server-based database/API Integration, dan pengecualiannya perlu dipastikan dalam penilaian akhir.

## 14. Out of Scope

Implementasi berikut tidak termasuk dalam target versi awal:

- Backend Node.js/Express, MySQL, atau layanan server aplikasi.
- REST API, kontrak endpoint, dan JWT authentication.
- Server-side validation, upload/storage foto server, migrations, dan deployment backend.
- Database persisten lokal maupun jaminan pemulihan data setelah restart.
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

Implementasi mengikuti [PRD.md](PRD.md) sebagai sumber kebutuhan produk dan keputusan frontend-only terbaru.

Keputusan baseline:

- Flutter dan Dart untuk Android; tetap delapan halaman.
- Provider/AppState untuk pengguna simulasi, draft, sesi aktif, dan riwayat runtime.
- Shared models User, City, Mall, ParkingSession, serta ParkingDraft sebagai kontrak lintas halaman.
- Seluruh dummy data awal berasal dari `lib/data/mock_data.dart`; tidak diduplikasi pada halaman.
- Login/register lokal tanpa autentikasi server; tidak ada backend, REST API, JWT, atau database persisten.
- Foto lokal serta integrasi nyata kamera, GPS, Google Maps, dan local notifications.
- Seluruh Must Have, dua metode pencatatan, ID FR, serta prioritas MoSCoW tetap mengacu pada PRD.
- Tidak ada jaminan persistensi setelah restart.
- Pengecualian PPB untuk server-based database dan API Integration masih perlu dipastikan dalam penilaian akhir.

Perubahan di luar scope harus dibahas terlebih dahulu; roadmap tidak mencakup penambahan backend atau implementasi foundation pada revisi dokumentasi ini.

**Implementation Principle:** Build only what is required. Follow existing conventions, keep changes focused, and avoid unnecessary complexity.
