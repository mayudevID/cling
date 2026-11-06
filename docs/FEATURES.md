# Dokumentasi Fitur Cling!

Dokumen ini menjadi indeks fitur Cling!. Penjelasan rinci dipisahkan berdasarkan domain agar alur, aturan bisnis, penyimpanan, dan batasan setiap fitur mudah ditelusuri.

## Indeks

| Fitur | Cakupan |
| --- | --- |
| [Autentikasi dan Onboarding](docs/features/authentication.md) | Registrasi, login, reset kata sandi, sesi, verifikasi, dan onboarding data bulanan |
| [Dasbor](docs/features/dashboard.md) | Saldo, ringkasan bulanan, target, pengeluaran hari ini, dan peringatan |
| [Transaksi](docs/features/transactions.md) | Pemasukan, pengeluaran, kategori, riwayat, perubahan, dan penghapusan |
| [Target Tabungan](docs/features/savings-goals.md) | Pembuatan target, setoran, progres, perubahan, penghapusan, dan daftar target |
| [Statistik](docs/features/statistics.md) | Agregasi bulanan, kategori terbesar, distribusi, dan rincian kategori |
| [Perencanaan Bulanan](docs/features/monthly-planning.md) | Pemasukan bulanan, anggaran, tanggal rutin, dan transaksi berulang |
| [Notifikasi](docs/features/notifications.md) | Peringatan keuangan lokal, status baca, penghitung, dan pagination |
| [Profil dan Pengaturan](docs/features/profile-settings.md) | Profil, email, kata sandi, bahasa, mata uang, dan logout |
| [Backup dan Restore](docs/features/backup-restore.md) | Pencadangan SQLite ke Firebase Storage dan pemulihan saat login |

## Gambaran Sistem

- Flutter membangun antarmuka aplikasi.
- BLoC mengelola state dan koordinasi antarfitur.
- SQLite menyimpan data keuangan utama di perangkat.
- Firebase Authentication mengelola identitas dan sesi.
- Cloud Firestore menyimpan profil dan perencanaan bulanan tingkat akun.
- Firebase Storage menyimpan satu berkas backup SQLite per pengguna.
- SharedPreferences menyimpan cache profil, bahasa, mata uang, dan status proses autentikasi.
- GetIt menyediakan repository dan layanan sebagai dependency aplikasi.

## Navigasi Utama

Setelah autentikasi, pengguna masuk ke empat tab: Home, Transactions, Statistics, dan Profile. Tombol aksi pada Home membuka pembuatan pemasukan, pengeluaran, atau target tabungan.

## Batas Validasi Dokumen

Dokumentasi disusun dari perilaku yang terlihat pada source code. Dokumentasi ini tidak membuktikan hasil uji perangkat, integrasi Firebase aktif, keamanan produksi, atau kesesuaian visual.
