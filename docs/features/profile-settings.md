# Profil dan Pengaturan

## Tujuan

Fitur ini menampilkan identitas pengguna, menyediakan perubahan data akun, dan mengelola preferensi aplikasi.

## Informasi Profil

Halaman Profile menampilkan:

- nama dari Firebase Authentication;
- email dari Firebase Authentication;
- mata uang dari profil atau state mata uang;
- pemasukan bulanan;
- anggaran bulanan;
- status verifikasi email;
- akses ke pengaturan dan backup.

`ProfileBloc` menggabungkan data Firebase Authentication, cache `UserModel`, package info, dan repository pengaturan.

## Mengubah Nama

Nama baru harus terisi dan memiliki panjang lebih dari empat karakter. Perubahan dikirim ke `FirebaseAuth.currentUser.updateDisplayName()`, lalu profil dimuat ulang.

## Mengubah Email

Email baru harus terisi dan valid. Aplikasi meminta konfirmasi sebelum menjalankan `verifyBeforeUpdateEmail()`. Firebase mengirim verifikasi ke alamat baru. Setelah operasi, profil dan status verifikasi dimuat ulang.

## Mengubah Kata Sandi

Perubahan kata sandi menggunakan email reset Firebase. Setelah konfirmasi pengguna, aplikasi mengirim tautan reset ke email profil.

## Bahasa

Aplikasi mendukung Inggris (`en`) dan Indonesia (`id`). Pilihan bahasa disimpan dalam SharedPreferences dan diterapkan sebagai locale `MaterialApp` melalui `LangCurrencyBloc`.

## Mata Uang

Mata uang dipilih saat registrasi dan disimpan pada profil Firestore. Pilihan aktif juga disimpan secara lokal untuk format nominal. Saat login, state mata uang diselaraskan dengan cache profil.

## Pengaturan

Halaman Settings menyediakan:

- perubahan bahasa;
- versi aplikasi;
- waktu backup terakhir;
- tindakan backup;
- logout.

## Logout

Logout menghapus cache profil, status login, dan status registrasi. Firebase Authentication mengakhiri sesi. Data SQLite lokal tidak dihapus oleh alur logout repository.

## Kegagalan dan Batasan

- Perubahan profil memerlukan jaringan.
- Perubahan email tunduk pada kebijakan reautentikasi Firebase dan dapat gagal bila sesi terlalu lama.
- Tombol penilaian aplikasi pada halaman Profile belum memiliki tindakan.
- Mata uang profil dan preferensi lokal berada di dua penyimpanan; konsistensi bergantung pada alur login dan perubahan state.
- Logout tidak otomatis menghapus data keuangan lokal, sehingga perangkat bersama memerlukan kebijakan privasi tambahan.

## Source Terkait

- `lib/features/ui/main/profile/bloc/profile_bloc.dart`
- `lib/features/ui/main/profile/page/profile_page.dart`
- `lib/features/ui/main/edit_profile/bloc/edit_profile_bloc.dart`
- `lib/features/ui/main/settings/page/settings_page.dart`
- `lib/features/ui/language_currency/lang_currency_bloc.dart`
- `lib/features/repository/settings_repository.dart`
- `lib/features/repository/auth_repository.dart`
