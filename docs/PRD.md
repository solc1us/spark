# SPARK - PRD Mobile App

**Nama Project: Spark – Spot My Park**

**Deskripsi aplikasi:** Aplikasi mobile untuk membantu pengguna menyimpan dan menemukan kembali lokasi parkir kendaraan melalui foto, koordinat GPS, dan Maps. Pengguna dapat menyimpan beberapa lokasi parkir aktif, melihat riwayat parkir, serta menerima pengingat berdasarkan durasi yang ditentukan.

# 1. Informasi Project

| Komponen | Keterangan |
| --- | --- |
| Nama aplikasi | Spark – Spot My Park |
| Judul project | Pengembangan Aplikasi Mobile Spark – Spot My Park untuk Pencatatan, Penelusuran, dan Pengingat Lokasi Parkir Kendaraan |
| Mata kuliah | Pemrograman Perangkat Bergerak |
| Platform | Android |
| Framework yang direncanakan | Flutter (frontend-only) |
| Bahasa pemrograman aplikasi | Dart |
| Data dan state | Dummy data awal di `lib/data/mock_data.dart`; perubahan runtime dikelola Provider/AppState |
| Anggota kelompok | 103022400025 - Jeremy Marcelino<br>103022400035 - Petra Panondang Simangunsong<br>103022400043 - Ariz Taufani Aqilah<br>103022400068 - Muhammad Dhaifullah Safarullah<br>103022400070 - Muhammad Meizar Salman |
| Kelas | SE 48 03 |
| Status project | Perencanaan dan penyusunan PRD |
| Status persetujuan dosen | Diterima setelah revisi |
| Repository GitHub | [https://github.com/solc1us/spark](https://github.com/solc1us/spark) |
| Desain UI/UX | - |

# 2. Deskripsi Aplikasi

Spark – Spot My Park merupakan aplikasi mobile yang membantu pengguna mengingat dan menemukan kembali lokasi kendaraan yang telah diparkir. Aplikasi ini ditujukan bagi pengguna kendaraan pribadi, khususnya pengendara mobil dan sepeda motor yang mengalami kesulitan mengingat lokasi parkir, terutama pada area yang luas atau memiliki banyak lantai dan zona.

Pengguna dapat mencatat lokasi parkir melalui dua metode, yaitu **pencatatan terstruktur** dan **pencatatan bebas**. Pada kedua metode, pengguna wajib memilih kota tempat kendaraan diparkir.

Pada pencatatan terstruktur, pengguna memilih kategori tempat seperti mall, event, atau tempat lainnya. Untuk kategori mall, aplikasi menyediakan daftar mall berdasarkan kota yang dipilih menggunakan data awal (*dummy data*). Sementara itu, untuk kategori event dan tempat lainnya, pengguna dapat memasukkan nama tempat secara manual.

Pada pencatatan bebas, pengguna dapat mencatat lokasi parkir tanpa memilih tempat dari daftar yang tersedia, tetapi tetap wajib menentukan kota. Kedua metode menyediakan kolom opsional untuk kode area atau lantai parkir, serta catatan tambahan seperti nomor pilar, pintu masuk, atau patokan lokasi lainnya.

Pengguna kemudian mengambil foto kendaraan atau area parkir menggunakan kamera perangkat. Aplikasi memperoleh koordinat GPS secara otomatis dan menampilkannya pada Maps agar pengguna dapat memeriksa serta menyesuaikan posisi pin sebelum menyimpan lokasi.

Spark juga mendukung penyimpanan beberapa sesi parkir aktif, pengingat durasi parkir, dan riwayat parkir. Ketika pengguna telah menemukan serta mengambil kendaraannya, sesi dapat ditandai sebagai selesai. Sistem akan menyimpan waktu penyelesaian, membatalkan pengingat yang masih terjadwal, dan memindahkan sesi ke riwayat tanpa menghapus informasi parkir sebelumnya.

Scope terbaru dari dosen membatasi implementasi pada Flutter frontend menggunakan dummy data, tanpa backend, REST API, atau layanan server aplikasi. Seluruh data awal pengguna, kota, mall berdasarkan kota, dan contoh sesi parkir berasal dari `lib/data/mock_data.dart`. Registrasi dan login merupakan simulasi lokal; perubahan pengguna dan sesi dikelola dalam memori oleh Provider/AppState selama aplikasi berjalan. Tidak ada persistent database atau jaminan data bertahan setelah restart aplikasi. Kamera, GPS, Maps, dan local notification tetap menggunakan kemampuan perangkat Android secara nyata; foto menggunakan file lokal perangkat.

# 3. Latar Belakang

Kendaraan pribadi merupakan salah satu sarana transportasi yang banyak digunakan masyarakat dalam aktivitas sehari-hari. Dalam penggunaannya, kendaraan sering diparkir di berbagai lokasi seperti pusat perbelanjaan, kawasan perkantoran, area kampus, tempat wisata, dan fasilitas umum.

Pada area parkir yang luas, memiliki banyak baris kendaraan, atau terbagi menjadi beberapa zona, pengguna berpotensi mengalami kesulitan mengingat lokasi kendaraan yang telah diparkir. Situasi tersebut dapat terjadi ketika pengguna meninggalkan kendaraan dalam waktu cukup lama, mengunjungi tempat yang belum familiar, atau berada di lingkungan parkir dengan tampilan yang relatif serupa.

Untuk mengingat lokasi kendaraan, pengguna dapat mengandalkan ingatan pribadi, mengambil foto area parkir, mencatat nomor zona, atau menyimpan titik lokasi melalui aplikasi peta. Namun, penggunaan cara-cara tersebut secara terpisah dapat membuat pengguna perlu mencari kembali informasi dari beberapa tempat ketika ingin menemukan kendaraan.

Kondisi ini menunjukkan adanya kebutuhan terhadap aplikasi yang dapat menggabungkan informasi visual, koordinat lokasi, dan waktu parkir dalam satu catatan yang mudah diakses.

Spark – Spot My Park dirancang untuk menjawab kebutuhan tersebut melalui pencatatan sesi parkir berbasis kamera dan GPS. Pengguna dapat mengambil foto kendaraan atau lingkungan sekitar, menyimpan koordinat lokasi, serta membuka kembali informasi tersebut saat diperlukan.

Selain membantu menemukan kendaraan, aplikasi menyediakan pengelolaan beberapa sesi parkir aktif, riwayat parkir, dan pengingat berbasis durasi. Fitur-fitur tersebut ditujukan untuk membantu pengguna mengelola informasi parkir secara lebih terstruktur.

# 4. Problem Statement

**Permasalahan**

1. Pengguna berpotensi mengalami kesulitan mengingat lokasi kendaraan setelah meninggalkannya di area parkir yang luas, memiliki banyak zona, atau belum familiar.
2. Informasi lokasi kendaraan yang hanya mengandalkan ingatan atau satu jenis catatan dapat menjadi kurang memadai ketika pengguna ingin menemukan kembali kendaraannya.
3. Foto kendaraan, koordinat lokasi, dan informasi tempat parkir yang disimpan secara terpisah berpotensi menyulitkan pengguna saat mencari kembali informasi tersebut.
4. Lokasi GPS tidak selalu dapat mengidentifikasi lantai, zona, atau area parkir secara presisi, khususnya pada gedung parkir bertingkat.
5. Pengguna memerlukan pencatatan lokasi yang terstruktur berdasarkan kota, tempat, dan area parkir, tetapi tetap membutuhkan metode bebas untuk lokasi yang tidak tersedia dalam daftar.
6. Pengguna yang memiliki beberapa catatan parkir membutuhkan mekanisme untuk mengelola dan menyelesaikan setiap sesi secara terpisah.
7. Pengguna membutuhkan pengingat durasi parkir agar tidak sepenuhnya bergantung pada ingatan untuk memantau waktu kendaraan diparkir.

**Pihak yang Terdampak**

1. Pengendara mobil yang menggunakan area parkir luas, pusat perbelanjaan, dan gedung parkir.
2. Pengendara sepeda motor yang memarkir kendaraan di area dengan jumlah kendaraan banyak.
3. Pengunjung event, pusat perbelanjaan, tempat wisata, kampus, perkantoran, dan fasilitas umum.
4. Pengguna yang membutuhkan penyimpanan beberapa catatan lokasi parkir dalam satu akun.

**Kondisi atau Proses Saat Ini**

Pengguna umumnya mengandalkan ingatan pribadi, foto, catatan manual, atau aplikasi peta untuk mengingat lokasi kendaraan. Namun, informasi tersebut tidak selalu terorganisasi dalam satu catatan yang memuat kota, tempat, lantai atau area parkir, foto, koordinat, dan waktu parkir.

Kondisi tersebut menjadi dasar kebutuhan awal untuk menyediakan sistem pencatatan parkir yang terintegrasi. Efektivitas solusi perlu dievaluasi melalui pengujian aplikasi.

**Urgensi**

Penyelesaian masalah diperlukan untuk membantu pengguna mengakses kembali lokasi kendaraan melalui informasi yang lebih lengkap dan terstruktur, mengurangi ketergantungan pada ingatan, serta mempermudah pengelolaan sesi parkir aktif dan riwayat parkir.

# 5. Tujuan Pengembangan

1. Mengembangkan aplikasi mobile untuk membantu pengguna mencatat dan menemukan kembali lokasi parkir kendaraan.
2. Menyediakan dua metode pencatatan lokasi parkir, yaitu terstruktur dan bebas, dengan pemilihan kota sebagai informasi wajib.
3. Menyediakan pemilihan kategori tempat dan daftar dummy mall berdasarkan kota untuk mendukung pencatatan lokasi parkir secara terstruktur.
4. Memungkinkan pengguna menyimpan informasi lantai, zona, atau kode area parkir serta catatan tambahan sebagai petunjuk lokasi kendaraan.
5. Memanfaatkan kamera perangkat untuk mengambil foto kendaraan atau lingkungan parkir sebagai referensi visual.
6. Memanfaatkan GPS untuk memperoleh koordinat lokasi parkir secara otomatis.
7. Menampilkan dan memungkinkan penyesuaian titik lokasi melalui Maps sebelum data disimpan.
8. Mensimulasikan penyimpanan informasi sesi parkir secara lokal melalui Provider/AppState selama aplikasi berjalan.
9. Mendukung penyimpanan dan pengelolaan beberapa sesi parkir aktif dalam satu akun pengguna.
10. Menyediakan detail lokasi dan riwayat parkir yang dapat diakses kembali.
11. Menyediakan pengingat melalui notifikasi berdasarkan durasi yang dipilih pengguna.
12. Mendukung penyelesaian sesi parkir dengan pencatatan waktu selesai dan pembatalan pengingat yang masih terjadwal.
13. Menerapkan persyaratan project akhir PPB sesuai scope frontend-only; pengecualian server-based database dan API Integration perlu dipastikan dalam penilaian akhir.

# 6. Target User

| Target pengguna | Kebutuhan utama | Hak akses |
| --- | --- | --- |
| Pengendara mobil | Mengingat lokasi kendaraan di area parkir luas, pusat perbelanjaan, dan gedung parkir | Membuat akun, mencatat lokasi parkir, mengambil foto, menyimpan koordinat, mengelola sesi parkir, dan mengakses riwayat |
| Pengendara sepeda motor | Menyimpan informasi lokasi kendaraan di area parkir yang padat | Mengambil foto, menyimpan lokasi, melihat informasi parkir, mengatur pengingat, dan menyelesaikan sesi |
| Pengguna dengan beberapa lokasi parkir aktif | Mengelola lebih dari satu catatan parkir secara bersamaan | Menambahkan beberapa sesi aktif, memilih detail setiap sesi, serta menyelesaikan sesi secara terpisah |

Seluruh kategori target pengguna memiliki hak akses yang sama sebagai pengguna aplikasi. AppState memfilter catatan berdasarkan akun simulasi yang sedang login; pemisahan ini merupakan perilaku UI lokal, bukan kontrol keamanan server.

# 7. Proposed Solution

Spark – Spot My Park menawarkan sistem pencatatan dan pengelolaan lokasi parkir kendaraan melalui Flutter frontend dengan integrasi kamera, GPS, Maps, shared state lokal, dan notifikasi.

Pengguna membuat akun atau melakukan login melalui simulasi data lokal untuk mengakses aplikasi. Setelah masuk, pengguna dapat melihat daftar sesi parkir aktif dan membuat catatan parkir baru.

Saat membuat catatan, pengguna terlebih dahulu memilih kota, kemudian menentukan salah satu metode pencatatan berikut:

1. **Pencatatan Terstruktur:** Pengguna memilih kategori tempat. Untuk mall, aplikasi menampilkan daftar mall berdasarkan kota yang dipilih. Untuk event dan kategori tempat lainnya, nama tempat dimasukkan secara manual.
2. **Pencatatan Bebas:** Pengguna mencatat lokasi tanpa harus memilih tempat dari daftar, tetapi tetap wajib menentukan kota.

Kedua metode menyediakan pilihan kode lantai atau area parkir seperti B1, B2, R1, dan R2. Pengguna dapat memilih opsi Lainnya untuk menuliskan kode secara manual. Pengisian kode area bersifat opsional. Aplikasi juga menyediakan kolom catatan tambahan.

Setelah mengisi informasi lokasi, pengguna mengambil foto kendaraan atau area parkir. Aplikasi memperoleh koordinat GPS secara otomatis dan menampilkan posisi tersebut pada Maps. Pengguna dapat menggeser pin untuk menyesuaikan titik lokasi sebelum disimpan.

AppState menyimpan referensi file foto lokal, koordinat, kota, informasi tempat, kode area apabila diisi, catatan, waktu pencatatan, dan status sesi parkir dalam memori. Pengguna dapat menyimpan beberapa sesi parkir aktif secara bersamaan selama aplikasi berjalan.

Ketika ingin menemukan kendaraan, pengguna membuka detail sesi parkir untuk melihat foto, peta, nama tempat, serta informasi lantai atau zona parkir yang telah dicatat. Informasi tersebut digunakan sebagai petunjuk untuk menemukan kendaraan, terutama pada lokasi yang tidak dapat diidentifikasi secara presisi menggunakan GPS.

Pengguna juga dapat menentukan durasi pengingat parkir. Setelah waktu pengingat tercapai, aplikasi menampilkan notifikasi lokal apabila izin dan pengaturan perangkat mendukung.

Setelah kendaraan ditemukan dan diambil, pengguna memilih tindakan Selesai Parkir dan memberikan konfirmasi. Sistem memperbarui status sesi, menyimpan waktu selesai, membatalkan pengingat yang masih terjadwal, serta memindahkan sesi ke riwayat parkir.

**Mekanisme utama aplikasi terdiri atas:**

1. **Parking Location Selection:** Pemilihan kota dan metode pencatatan terstruktur atau bebas, dengan daftar dummy mall berdasarkan kota serta pengisian nama tempat secara manual untuk kategori lainnya.
2. **Parking Area Documentation:** Pencatatan informasi lantai atau area parkir melalui dropdown kode area atau input manual, serta catatan tambahan sebagai petunjuk lokasi kendaraan.
3. **Photo & GPS Capture:** Pengambilan foto kendaraan atau area parkir menggunakan kamera dan koordinat lokasi secara otomatis melalui GPS perangkat.
4. **Location Verification:** Pemeriksaan dan penyesuaian titik lokasi parkir melalui Maps sebelum disimpan.
5. **Parking Session Management:** Penyimpanan dan pengelolaan beberapa sesi parkir aktif beserta foto, koordinat, informasi tempat, dan waktu pencatatan.
6. **Parking Location Retrieval:** Penampilan kembali foto, koordinat, informasi tempat, lantai atau area parkir, dan catatan untuk membantu pengguna menemukan kendaraan.
7. **Parking Reminder:** Pengingat parkir melalui notifikasi lokal berdasarkan durasi yang ditentukan pengguna.
8. **Parking Completion & History:** Penyelesaian sesi parkir melalui konfirmasi pengguna, pencatatan waktu selesai, pembatalan pengingat yang masih terjadwal, dan penyimpanan riwayat parkir.

# 8. Kebutuhan Fungsional dan Prioritas Fitur

Prioritas menggunakan metode MoSCoW:

1. **Must Have:** Wajib tersedia pada versi project.
2. **Should Have:** Dikerjakan setelah seluruh fitur wajib selesai.
3. **Could Have:** Tambahan jika waktu memungkinkan.
4. **Won't Have:** Di luar cakupan versi ini.

## 8.1. Must Have

| ID | Fitur | Kebutuhan |
| --- | --- | --- |
| FR-001 | Autentikasi pengguna (simulasi) | Pengguna dapat melakukan simulasi registrasi, login, dan logout menggunakan data lokal yang dikelola AppState. Ini bukan autentikasi aman terhadap server dan tidak menggunakan JWT. |
| FR-002 | Pengambilan foto parkir | Pengguna dapat mengambil foto kendaraan atau area parkir menggunakan kamera perangkat. |
| FR-003 | Pengambilan koordinat GPS | Sistem dapat memperoleh koordinat GPS secara otomatis saat pengguna mencatat lokasi parkir. |
| FR-004 | Penyesuaian titik lokasi | Pengguna dapat melihat dan menggeser pin pada Maps sebelum menyimpan lokasi parkir. |
| FR-005 | Pembuatan sesi parkir | Pengguna dapat menyimpan sesi parkir yang berisi foto, koordinat, informasi tempat, waktu pencatatan, dan status parkir. |
| FR-006 | Penyimpanan foto parkir | Sistem menggunakan file foto lokal perangkat dan menyimpan referensinya pada sesi di AppState untuk ditampilkan kembali selama runtime; tidak ada upload atau penyimpanan server. |
| FR-007 | Penyimpanan data parkir | Sistem mensimulasikan penyimpanan dan pengambilan data parkir melalui Provider/AppState, dengan data awal dari `lib/data/mock_data.dart`. Data runtime tidak dijamin bertahan setelah restart aplikasi. |
| FR-008 | Manajemen beberapa parkir aktif | Pengguna dapat menyimpan dan mengelola beberapa sesi parkir aktif secara bersamaan. |
| FR-009 | Detail lokasi parkir | Pengguna dapat melihat foto, kota, tempat, area parkir, catatan, waktu, status, dan koordinat lokasi pada Maps. |
| FR-010 | Penyelesaian sesi parkir | Pengguna dapat mengonfirmasi bahwa kendaraan telah ditemukan dan diambil untuk menyelesaikan sesi parkir, mencatat waktu selesai, dan membatalkan pengingat yang belum muncul. |
| FR-011 | Riwayat parkir | Pengguna dapat melihat kembali daftar dan detail sesi parkir yang telah selesai tanpa kehilangan informasi sebelumnya selama aplikasi berjalan. |
| FR-012 | Pengingat durasi parkir | Pengguna dapat menentukan durasi pengingat dan menerima notifikasi sesuai waktu yang ditentukan. |
| FR-013 | Catatan lokasi parkir | Pengguna dapat menambahkan catatan seperti nomor pilar, pintu masuk, patokan lokasi, atau informasi tambahan lainnya. |
| FR-018 | Pemilihan kota | Pengguna harus memilih kota saat membuat sesi parkir, baik melalui metode terstruktur maupun bebas. |
| FR-019 | Metode pencatatan parkir | Pengguna dapat memilih metode pencatatan terstruktur atau bebas saat membuat sesi parkir. |
| FR-020 | Pemilihan kategori tempat | Pengguna dapat memilih kategori Mall, Event, atau Lainnya pada metode pencatatan terstruktur. |
| FR-021 | Daftar mall berdasarkan kota | Sistem dapat menampilkan daftar dummy mall berdasarkan kota yang dipilih pengguna dari sumber bersama `lib/data/mock_data.dart` melalui AppState. |
| FR-022 | Pengisian nama tempat manual | Pengguna dapat memasukkan nama tempat secara manual untuk kategori Event, Lainnya, dan metode pencatatan bebas. |
| FR-023 | Informasi lantai dan area parkir | Pengguna dapat menyimpan dan melihat kode lantai atau area parkir melalui dropdown B1, B2, R1, R2, atau opsi Lainnya dengan input manual. Pengisian bersifat opsional pada seluruh kategori dan metode pencatatan. |

## 8.2. Should Have

| ID | Fitur | Kebutuhan |
| --- | --- | --- |
| FR-014 | Navigasi menuju lokasi | Pengguna dapat membuka petunjuk arah menuju koordinat parkir melalui Maps. |
| FR-015 | Identitas kendaraan | Pengguna dapat memberikan nama atau label kendaraan untuk membedakan setiap sesi parkir. |

## 8.3. Could Have

| ID | Fitur | Kebutuhan |
| --- | --- | --- |
| FR-016 | Perubahan pengingat | Pengguna dapat mengubah durasi pengingat pada sesi parkir yang masih aktif. |
| FR-017 | Berbagi lokasi parkir | Pengguna dapat membagikan koordinat lokasi parkir melalui aplikasi lain. |

## 8.4. Won't Have

| ID | Fitur | Batasan Cakupan |
| --- | --- | --- |
| OUT-001 | Pelacakan kendaraan real-time | Aplikasi tidak menyediakan pelacakan perpindahan kendaraan secara langsung. |
| OUT-002 | Deteksi parkir otomatis | Aplikasi tidak mendeteksi aktivitas parkir secara otomatis tanpa tindakan pengguna. |

# 9. Kesesuaian dengan Persyaratan Teknis PPB

| Persyaratan pedoman | Rencana penerapan |
| --- | --- |
| Navigation dan Routing | Navigasi antara 8 halaman: Login, Register, Home, Add Parking, Capture Photo, Confirm Location, Parking Detail, dan Parking History |
| Server-based Database | Belum diimplementasikan karena pembatasan scope terbaru dari dosen. Data awal menggunakan dummy data dan perubahan runtime menggunakan AppState, tanpa database persisten |
| API Integration | Belum diimplementasikan karena pembatasan scope terbaru dari dosen. Tidak ada REST API/backend; penggunaan Maps tetap bagian integrasi perangkat dan tidak diklaim memenuhi persyaratan ini |
| File Storage | Aplikasi mengelola dan membaca file foto lokal dari kamera serta menyimpan referensinya di AppState, tanpa upload |
| Camera | Kamera digunakan untuk mengambil foto kendaraan atau area parkir saat pengguna membuat catatan baru |
| State Management | Provider/AppState mengelola pengguna simulasi, draft pencatatan, foto lokal, koordinat, sesi aktif, dan riwayat selama runtime |
| Error Handling | Menangani peta gagal dimuat, data kosong, izin perangkat ditolak, lokasi tidak tersedia, input tidak valid, serta file foto lokal tidak dapat dibaca |
| Google Maps | Implementasi menggunakan OpenStreetMap untuk menampilkan koordinat GPS, menyesuaikan posisi pin, menyimpan koordinat di AppState, dan menampilkan kembali lokasi parkir. Kesesuaiannya terhadap kategori pedoman PPB ini masih perlu dikonfirmasi kepada dosen |
| Notification | Menampilkan notifikasi lokal berdasarkan durasi pengingat yang ditentukan pengguna untuk setiap sesi parkir |

Server-based Database dan API Integration belum terpenuhi. Pengecualian akibat scope terbaru ini masih perlu dipastikan dengan dosen dalam penilaian akhir; integrasi perangkat tidak menggantikan kedua persyaratan tersebut.

# 10. Kebutuhan Nonfungsional (NFR)

1. **Kemudahan penggunaan:** Tampilan dan navigasi aplikasi dibuat sederhana serta konsisten. Pengguna dapat menyimpan lokasi parkir melalui alur pengambilan foto, konfirmasi titik lokasi, dan penyimpanan tanpa langkah yang tidak diperlukan.
2. **Simulasi akses:** AppState memfilter sesi berdasarkan pengguna lokal yang sedang login. Registrasi/login bukan autentikasi aman terhadap server dan tidak digunakan untuk akun atau kredensial nyata.
3. **Privasi:** Foto kendaraan dan koordinat dikelola secara lokal dan tidak dibagikan kepada pengguna lain secara otomatis. Simulasi akun tidak menjamin perlindungan data seperti autentikasi server.
4. **Konsistensi data:** Informasi foto, koordinat, waktu, dan status parkir harus memiliki hubungan yang sesuai dengan sesi yang dibuat. Perubahan status satu sesi tidak boleh memengaruhi sesi parkir lainnya.
5. **Keakuratan informasi lokasi:** Koordinat lokasi diperoleh dari layanan lokasi perangkat. Karena akurasinya dapat dipengaruhi kondisi lingkungan, aplikasi memberikan kesempatan kepada pengguna untuk memeriksa dan menyesuaikan titik lokasi sebelum penyimpanan. Aplikasi tidak menjamin GPS dapat menunjukkan lantai atau slot parkir secara presisi.
6. **Keandalan:** Aplikasi tidak berhenti mendadak ketika GPS, kamera, koneksi internet, atau proses penyimpanan mengalami kegagalan. Aplikasi memberikan informasi yang sesuai dan memungkinkan pengguna mencoba kembali.
7. **Konsistensi notifikasi:** Pengingat dijadwalkan berdasarkan durasi yang dipilih pengguna. Notifikasi terjadwal untuk sesi yang telah diselesaikan harus dibatalkan jika belum ditampilkan, sejauh didukung mekanisme perangkat.
8. **Kemudahan pemeliharaan:** Halaman/widget, shared models, AppState, mock data, dan integrasi perangkat dipisahkan sesuai tanggung jawab. Semua halaman menggunakan kontrak data bersama dan komponen UI yang serupa dibuat reusable.
9. **Efisiensi penyimpanan:** Foto dikelola dengan ukuran yang wajar untuk penggunaan aplikasi mobile. Mekanisme penyimpanan menghindari file sementara yang tidak diperlukan tanpa menghilangkan foto yang masih dibutuhkan pengguna.
10. **Batas ketahanan data:** Pengguna baru, sesi aktif, dan riwayat yang berubah di AppState hanya tersedia selama runtime; restart menginisialisasi ulang data dummy dan tidak menjamin pemulihan perubahan sebelumnya.

# 11. Alur Penggunaan

**Alur Menyimpan Lokasi Parkir**

1. Pengguna membuka aplikasi dan melakukan simulasi login menggunakan data lokal.
2. Memilih fitur tambah lokasi parkir.
3. Memilih kota tempat kendaraan diparkir.
4. Memilih metode pencatatan terstruktur atau bebas.
5. Jika menggunakan metode terstruktur, pengguna memilih kategori tempat:
    - Mall: memilih mall dari daftar dummy berdasarkan kota.
    - Event: mengisi nama tempat secara manual.
    - Lainnya: mengisi nama tempat secara manual.
6. Jika menggunakan metode bebas, pengguna dapat mengisi nama lokasi secara manual tanpa memilih kategori tempat.
7. Pengguna dapat memilih kode lantai atau area parkir melalui dropdown B1, B2, R1, R2, atau Lainnya.
8. Jika memilih Lainnya, pengguna mengisi kode area secara manual. Pengguna juga dapat melewati pengisian area parkir.
9. Pengguna dapat menambahkan catatan lokasi.
10. Pengguna mengambil foto kendaraan atau area parkir menggunakan kamera perangkat.
11. Aplikasi memperoleh koordinat GPS secara otomatis.
12. Pengguna memeriksa titik lokasi pada Maps dan menggeser pin apabila diperlukan.
13. Pengguna dapat menentukan durasi pengingat.
14. Pengguna mengonfirmasi penyimpanan sesi parkir.
15. AppState menyimpan informasi parkir beserta referensi file foto lokal dalam memori dan menampilkan sesi baru dalam daftar parkir aktif.
16. Aplikasi menjadwalkan notifikasi apabila pengingat diaktifkan.

**Alur Menemukan Kembali Lokasi Kendaraan**

1. Pengguna membuka daftar sesi parkir aktif.
2. Memilih sesi parkir yang ingin ditemukan.
3. Aplikasi menampilkan foto, kota, nama tempat, waktu, serta catatan lokasi parkir.
4. Jika tersedia, aplikasi menampilkan kode lantai atau area parkir yang sebelumnya disimpan.
5. Pengguna membuka Maps untuk melihat koordinat lokasi kendaraan.
6. Pengguna menggunakan informasi foto, koordinat, lantai atau area parkir, dan catatan sebagai petunjuk untuk menemukan kendaraan.
7. Setelah kendaraan ditemukan dan diambil, pengguna memilih tindakan Selesai Parkir.
8. Aplikasi menampilkan dialog konfirmasi penyelesaian sesi.

**Alur Menyelesaikan Parkir**

1. Pengguna membuka detail sesi parkir aktif.
2. Memilih tindakan Selesai Parkir.
3. Aplikasi menampilkan konfirmasi bahwa kendaraan telah ditemukan dan diambil.
4. Setelah pengguna mengonfirmasi, AppState memperbarui status sesi menjadi selesai.
5. Sistem mencatat waktu penyelesaian parkir.
6. Aplikasi membatalkan notifikasi pengingat yang belum ditampilkan.
7. Sesi dihapus dari daftar parkir aktif dan tetap tersimpan pada riwayat parkir di AppState selama runtime.
8. Foto, koordinat, informasi tempat, lantai atau area, dan catatan tetap dapat diakses melalui riwayat.
9. Sesi parkir aktif lainnya tidak terpengaruh.

# 12. Rencana Teknologi dan Data

Rencana teknologi menggunakan Flutter dan Dart untuk Android, Provider/AppState, Maps, kamera perangkat, GPS, local notification, serta GitHub. Tidak ada backend Node.js/Express, MySQL, REST API, JWT, atau layanan server aplikasi.

`lib/data/mock_data.dart` menjadi satu-satunya sumber dummy data awal pengguna, kota, mall berdasarkan kota, dan contoh sesi parkir. AppState menginisialisasi salinan data tersebut sekali, lalu mengelola perubahan runtime. Halaman tidak menduplikasi dummy data.

**Data utama yang dikelola:**

1. **Pengguna:** Identitas akun dan kredensial dummy untuk simulasi login/register lokal.
2. **Kota:** Identitas dan nama kota yang tersedia sebagai pilihan lokasi parkir.
3. **Tempat:** Identitas tempat, nama, kategori, dan kota terkait. Daftar mall menggunakan dummy data yang dikelompokkan berdasarkan kota.
4. **Sesi Parkir:** Identitas sesi, pemilik akun, metode pencatatan, kota, kategori dan nama tempat jika tersedia, koordinat, waktu pencatatan, status, dan waktu penyelesaian.
5. **Foto Parkir:** Referensi path file foto lokal perangkat yang terhubung dengan sesi parkir.
6. **Detail Area Parkir:** Kode lantai atau area parkir yang dipilih dari dropdown maupun diisi secara manual.
7. **Catatan Parkir:** Informasi tambahan mengenai lokasi kendaraan yang ditulis pengguna.
8. **Pengingat Parkir:** Durasi pengingat dan waktu notifikasi yang terkait dengan sesi parkir.

Shared models terdiri atas `User`, `City`, `Mall`, `ParkingSession`, dan `ParkingDraft`. Data lokasi, area, catatan, referensi foto, serta pengingat menjadi atribut model; draft menampung input sementara sebelum dikonfirmasi. Tidak ada tabel database atau penyimpanan persisten.

**Hubungan data utama:**

- Satu pengguna dapat memiliki banyak sesi parkir.
- Satu kota dapat memiliki banyak tempat.
- Satu tempat terstruktur dapat digunakan oleh banyak sesi parkir.
- Setiap sesi parkir wajib memiliki satu kota.
- Setiap sesi memiliki satu metode pencatatan, yaitu terstruktur atau bebas.
- Pada kategori Mall, sesi menggunakan referensi mall dari daftar dummy sesuai kota.
- Pada kategori Event dan Lainnya, nama tempat dapat disimpan sebagai teks manual.
- Pada mode bebas, informasi nama tempat bersifat opsional.
- Setiap sesi parkir memiliki satu foto utama dan satu titik koordinat.
- Informasi lantai atau area parkir dan catatan tambahan bersifat opsional.
- Satu pengguna dapat memiliki beberapa sesi parkir aktif secara bersamaan.
- Setiap sesi memiliki status aktif atau selesai.
- Sesi yang telah selesai tetap tersimpan sebagai riwayat parkir selama runtime.

**Rencana mekanisme penyimpanan data:**

1. AppState menyediakan daftar kota dan mall dari data awal `lib/data/mock_data.dart`.
2. Pengguna menentukan kota serta metode pencatatan.
3. Sistem menampilkan daftar mall yang sesuai dengan kota apabila kategori Mall dipilih.
4. Pengguna melengkapi informasi tempat, area parkir, dan catatan sesuai kebutuhan.
5. Aplikasi mengambil foto dan koordinat GPS.
6. Pengguna mengonfirmasi atau menyesuaikan titik lokasi pada Maps.
7. Aplikasi meneruskan `ParkingDraft` yang telah dikonfirmasi ke `AppState.addParking()`.
8. AppState memvalidasi data lokal dan menambahkan sesi parkir beserta referensi file fotonya ke shared state dalam memori.
9. Aplikasi memperbarui daftar parkir aktif serta menjadwalkan pengingat jika diaktifkan.
10. Ketika sesi diselesaikan, `AppState.completeParking()` memperbarui status dan waktu selesai serta aplikasi membatalkan pengingat terkait.

Sesi aktif dan riwayat diakses melalui `activeSessions`, `parkingHistory`, serta `getParkingById()`. Data runtime tidak ditulis kembali ke `mock_data.dart` dan tidak dijamin bertahan setelah restart.

# 13. Batasan Project

1. Spark – Spot My Park dikembangkan sebagai aplikasi mobile dengan target awal perangkat Android.
2. Pencatatan lokasi parkir dilakukan melalui tindakan pengguna dan tidak mendeteksi parkir secara otomatis.
3. Pengguna wajib memilih kota pada setiap sesi parkir, baik dalam metode pencatatan terstruktur maupun bebas.
4. Daftar tempat yang disediakan secara terstruktur dibatasi pada dummy data mall berdasarkan kota yang telah disiapkan.
5. Untuk kategori Event dan Lainnya, nama tempat dimasukkan secara manual tanpa menyediakan daftar tempat terintegrasi.
6. Pengguna dapat memilih kode lantai atau area parkir yang tersedia atau mengisinya secara manual melalui opsi Lainnya. Informasi tersebut bersifat opsional pada seluruh kategori dan metode pencatatan.
7. Informasi lantai dan area parkir digunakan sebagai petunjuk manual untuk menemukan kendaraan. Aplikasi tidak melakukan penentuan posisi lantai secara otomatis atau menyediakan navigasi indoor presisi.
8. Koordinat lokasi diperoleh menggunakan GPS perangkat dan dapat disesuaikan melalui Maps.
9. Versi awal menggunakan satu foto utama untuk setiap sesi parkir.
10. Pengguna dapat menyimpan beberapa sesi parkir aktif secara bersamaan.
11. Data utama menggunakan dummy data dan shared state lokal tanpa koneksi server aplikasi. Maps tetap dapat memerlukan koneksi internet untuk memuat peta.
12. Pengingat menggunakan local notification yang bergantung pada izin dan pengaturan perangkat.
13. Sesi parkir diselesaikan melalui konfirmasi pengguna setelah kendaraan ditemukan dan diambil, bukan berdasarkan deteksi otomatis sistem.
14. Sesi yang telah selesai tetap disimpan sebagai riwayat parkir selama aplikasi berjalan, tanpa jaminan persistensi setelah restart.
15. Fitur pelacakan kendaraan real-time dan deteksi parkir otomatis tidak termasuk dalam cakupan pengembangan versi awal.
16. Struktur kode, repository, jadwal pengerjaan, dan demonstrasi mengikuti ketentuan Project Akhir PPB.
17. Registrasi/login hanya simulasi lokal; tidak ada backend, REST API, JWT, database persisten, atau upload foto. Pengecualian server-based database dan API Integration masih perlu dipastikan dalam penilaian akhir.

# 14. Kriteria Keberhasilan

1. Pengguna dapat melakukan simulasi membuat akun, login, logout, dan melihat sesi yang difilter berdasarkan akun lokal selama runtime.
2. Pengguna dapat memilih kota pada saat membuat sesi parkir.
3. Pengguna dapat memilih metode pencatatan terstruktur atau bebas.
4. Pada metode terstruktur, pengguna dapat memilih kategori Mall, Event, atau Lainnya.
5. Sistem berhasil menampilkan daftar dummy mall sesuai kota yang dipilih.
6. Pengguna dapat memasukkan nama tempat secara manual untuk kategori Event, Lainnya, dan pencatatan bebas.
7. Pengguna dapat memilih kode lantai atau area parkir melalui dropdown, mengisi kode manual melalui opsi Lainnya, atau membiarkan informasi tersebut kosong.
8. Pengguna dapat menambahkan catatan lokasi parkir.
9. Kamera perangkat berhasil mengambil foto kendaraan atau area parkir.
10. Aplikasi berhasil memperoleh koordinat GPS dan menampilkannya pada Maps.
11. Pengguna dapat menggeser pin untuk menyesuaikan titik lokasi sebelum disimpan.
12. Sistem berhasil menyimpan foto, koordinat, kota, informasi tempat, area, catatan, dan waktu pencatatan sesuai data yang diisi pengguna.
13. Data parkir berhasil dikelola di AppState dan dapat ditampilkan kembali selama runtime, dengan data awal dari `lib/data/mock_data.dart` serta tanpa jaminan persistensi setelah restart.
14. Pengguna dapat menyimpan lebih dari satu sesi parkir aktif secara bersamaan.
15. Detail sesi menampilkan informasi yang sebelumnya disimpan, termasuk lantai atau area parkir sebagai petunjuk ketika kendaraan berada di gedung bertingkat.
16. Pengguna dapat menentukan durasi pengingat dan menerima notifikasi ketika izin serta pengaturan perangkat mendukung.
17. Pengguna dapat mengonfirmasi penyelesaian sesi setelah kendaraan ditemukan dan diambil.
18. Sistem berhasil mengubah status sesi menjadi selesai dan mencatat waktu penyelesaian.
19. Pengingat yang belum muncul berhasil dibatalkan ketika sesi parkir terkait diselesaikan.
20. Sesi yang selesai tidak lagi muncul pada daftar aktif, tetapi tetap dapat diakses melalui riwayat.
21. Penyelesaian satu sesi tidak memengaruhi sesi parkir aktif lainnya.
22. Sistem dapat menangani peta gagal dimuat, izin perangkat ditolak, GPS tidak tersedia, input tidak valid, dan file foto lokal tidak tersedia tanpa menyebabkan aplikasi berhenti mendadak.
23. Persyaratan PPB dalam scope dapat didemonstrasikan; server-based database dan API Integration belum diimplementasikan, dengan pengecualian yang perlu dipastikan dalam penilaian akhir.
24. Halaman menggunakan shared models, Provider/AppState, satu sumber dummy data, dan reusable component secara konsisten.

# 15. Progress Pengembangan

Bagian ini digunakan untuk memantau perkembangan implementasi fitur dan wajib diperbarui secara berkala selama pengerjaan project.

**Status Awal Project**

| Komponen | Status |
| --- | --- |
| Penyusunan PRD | Direvisi untuk scope Flutter frontend-only dan dummy data |
| Persetujuan judul | Diterima dengan catatan revisi |
| Perancangan UI/UX | Belum dikerjakan |
| Perancangan arsitektur | Baseline frontend-only didokumentasikan pada `TECH_SPEC.md`; foundation belum diimplementasikan |
| Pengembangan aplikasi | Belum dikerjakan |
| Integrasi backend / REST API | Tidak diimplementasikan sesuai scope terbaru dari dosen |
| Pengujian aplikasi | Belum dikerjakan |
| Dokumentasi akhir | Belum dikerjakan |

**Progress Fitur**

| ID | Fitur | Prioritas | Status |
| --- | --- | --- | --- |
| FR-001 | Autentikasi pengguna (simulasi) | Must Have | Belum dikerjakan |
| FR-002 | Pengambilan foto parkir | Must Have | Belum dikerjakan |
| FR-003 | Pengambilan koordinat GPS | Must Have | Belum dikerjakan |
| FR-004 | Penyesuaian titik lokasi | Must Have | Belum dikerjakan |
| FR-005 | Pembuatan sesi parkir | Must Have | Belum dikerjakan |
| FR-006 | Penyimpanan foto parkir | Must Have | Belum dikerjakan |
| FR-007 | Penyimpanan data parkir | Must Have | Belum dikerjakan |
| FR-008 | Manajemen beberapa parkir aktif | Must Have | Belum dikerjakan |
| FR-009 | Detail lokasi parkir | Must Have | Belum dikerjakan |
| FR-010 | Penyelesaian sesi parkir | Must Have | Belum dikerjakan |
| FR-011 | Riwayat parkir | Must Have | Belum dikerjakan |
| FR-012 | Pengingat durasi parkir | Must Have | Belum dikerjakan |
| FR-013 | Catatan lokasi parkir | Must Have | Belum dikerjakan |
| FR-018 | Pemilihan kota | Must Have | Belum dikerjakan |
| FR-019 | Metode pencatatan parkir | Must Have | Belum dikerjakan |
| FR-020 | Pemilihan kategori tempat | Must Have | Belum dikerjakan |
| FR-021 | Daftar mall berdasarkan kota | Must Have | Belum dikerjakan |
| FR-022 | Pengisian nama tempat manual | Must Have | Belum dikerjakan |
| FR-023 | Informasi lantai dan area parkir | Must Have | Belum dikerjakan |
| FR-014 | Navigasi menuju lokasi | Should Have | Belum dikerjakan |
| FR-015 | Identitas kendaraan | Should Have | Belum dikerjakan |
| FR-016 | Perubahan pengingat | Could Have | Belum dikerjakan |
| FR-017 | Berbagi lokasi parkir | Could Have | Belum dikerjakan |

**Kendala dan Risiko Awal**

1. Kelayakan konsep dan revisi fitur masih memerlukan validasi akhir dosen.
2. Koordinat GPS tidak selalu dapat menunjukkan lantai atau zona parkir (vertikal) secara presisi.
3. Daftar dummy mall perlu disiapkan dan dikelompokkan berdasarkan kota.
4. Pemilihan area parkir harus mendukung kode standar, input manual, dan kondisi tanpa area.
5. Proses penyelesaian sesi perlu menjaga konsistensi riwayat dan pembatalan pengingat.
6. Pengelolaan beberapa sesi aktif harus memastikan perubahan satu sesi tidak memengaruhi sesi lainnya.
7. Pengecualian persyaratan server-based database dan API Integration akibat pembatasan scope masih perlu dipastikan dalam penilaian akhir.
8. Perubahan akun dan sesi runtime dapat hilang setelah restart; simulasi login bukan autentikasi aman.

**Rencana Penyelesaian Kendala**

1. Menyelaraskan PRD dengan seluruh catatan revisi dosen.
2. Menggunakan informasi lantai, zona, dan catatan sebagai petunjuk tambahan selain koordinat GPS.
3. Menyiapkan seluruh dummy data awal pengguna, kota, mall, dan contoh sesi dalam `lib/data/mock_data.dart`, lalu mengelola perubahan runtime melalui AppState.
4. Menyediakan dropdown kode area dengan opsi Lainnya serta mendukung pengisian kosong.
5. Menggunakan konfirmasi pengguna untuk mengakhiri sesi, menyimpan waktu selesai, dan membatalkan pengingat.
6. Menggunakan identitas unik untuk setiap sesi parkir.
7. Memastikan penerimaan pengecualian scope dengan dosen sebelum penilaian akhir.
8. Menjelaskan batas simulasi dan ketahanan data pada dokumentasi serta demonstrasi.

**Ketentuan Pembaruan Progress**

Progress diperbarui berdasarkan fitur yang telah diselesaikan, fitur yang sedang dikerjakan, fitur yang belum dimulai, kendala yang ditemukan, serta langkah penyelesaian yang telah dilakukan.
