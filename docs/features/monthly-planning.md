# Perencanaan Bulanan

## Tujuan

Fitur ini menyimpan ekspektasi pemasukan dan batas pengeluaran bulanan. Nilai tersebut dipakai Home, peringatan, profil, dan pembuatan pemasukan rutin.

## Data Perencanaan

Dokumen profil Firestore menyimpan:

- `monthly_income`: estimasi atau nilai pemasukan bulanan;
- `monthly_budget`: batas pengeluaran bulanan;
- `recurring_day`: tanggal pemasukan rutin;
- `updated_at`: waktu perubahan terakhir.

Cache `UserModel` di SharedPreferences menyimpan salinan data untuk akses aplikasi.

## Pengisian Awal

Setelah verifikasi, onboarding meminta pemasukan bulanan dan anggaran bulanan. Keduanya harus lebih dari nol. Pengguna juga memilih tanggal pemasukan rutin. Penyimpanan memperbarui Firestore dan cache profil.

## Perubahan dari Profil

Profil menyediakan halaman terpisah untuk pemasukan bulanan dan anggaran. Perubahan memerlukan koneksi jaringan karena data disimpan ke Firestore. Perubahan pemasukan juga dapat membawa tanggal rutin baru.

## Pemasukan Rutin Lokal

Saat login, aplikasi membuat aturan rutin lokal jika `recurring_day` dan `monthly_income` tidak nol. Saat `DatabaseRepository` membuka basis data, repository memeriksa aturan rutin dan membuat pemasukan yang terlewat.

Pemasukan otomatis menggunakan:

- deskripsi `Monthly Income (Recurring)`;
- sumber pemasukan kategori pertama;
- nominal dari aturan rutin;
- tanggal berdasarkan hari rutin setiap bulan.

Repository menyimpan tanggal terakhir yang diproses agar periode berikutnya dapat dihitung.

## Penggunaan Anggaran

Home membandingkan pengeluaran bulan berjalan dengan `monthly_budget`. Jika pengeluaran melewati batas, sistem membuat notifikasi anggaran maksimal satu kali per bulan untuk jenis tersebut.

## Kepemilikan Data

- Firestore dan cache profil: nilai perencanaan akun.
- SQLite: aturan rutin dan transaksi pemasukan yang dihasilkan.

Pemisahan ini berarti perubahan profil tidak otomatis merekonsiliasi semua aturan rutin lokal lama.

## Kegagalan dan Batasan

- Pemasukan rutin diproses saat aplikasi membuka database, bukan oleh scheduler latar belakang.
- Perhitungan bulan terlewat memakai selisih hari dibagi 30, sehingga bukan perhitungan kalender penuh.
- Repository menyimpan aturan rutin baru saat login; source saat ini tidak menunjukkan deduplikasi atau penggantian aturan lama.
- Tanggal yang tidak ada pada bulan tertentu mengikuti normalisasi `DateTime` Dart.
- Pemeriksaan perubahan pada edit bulanan membandingkan tanggal awal dengan nilai nominal pada salah satu kondisi; kondisi keluar cepat perlu verifikasi lebih lanjut.
- Tidak ada anggaran per kategori.

## Source Terkait

- `lib/features/ui/verification_success/bloc/monthly_data_bloc.dart`
- `lib/features/ui/main/edit_monthly/bloc/edit_monthly_bloc.dart`
- `lib/features/ui/main/profile/widgets/list_account_settings.dart`
- `lib/features/repository/settings_repository.dart`
- `lib/features/repository/database_repository.dart`
- `lib/core/init_database.dart`
