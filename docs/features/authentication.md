# Autentikasi dan Onboarding

## Tujuan

Fitur ini membentuk identitas pengguna, mempertahankan sesi yang telah
terautentikasi, dan mengumpulkan data awal pemasukan/anggaran bulanan.

## Registrasi dan verifikasi email

Registrasi menggunakan Firebase Authentication. Dokumen `users/{uid}` di
Firestore dibuat dengan `verified_process: false`. Verifikasi email Firebase
dan penyelesaian onboarding bulanan adalah dua kondisi yang **berbeda**.

Jika pembuatan profil Firestore terputus, `ensureProfile()` memperbaiki
field yang belum tersedia tanpa menimpa nilai yang sudah ada.

## Login email dan password

Tombol **Login** memerlukan jaringan agar Firebase bisa memverifikasi password.
Tidak ada fallback ke sesi tersimpan ketika password salah atau verifikasi
password gagal karena koneksi.

Jika koneksi tidak tersedia, form menampilkan kesalahan koneksi; aplikasi
**tidak** menganggap input password sebagai berhasil terautentikasi.

Jika Firebase telah memverifikasi email/password, Cling mengaktifkan database
lokal untuk UID yang sama, memulihkan cache profil, dan menyinkronkan
pengaturan recurring income bila server tersedia.

## Lanjutkan sesi tersimpan

Pada halaman Login, tersedia tombol **Lanjutkan sesi tersimpan** jika:

- `FirebaseAuth.currentUser` masih tersedia di perangkat;
- email akun tersebut sudah diverifikasi;
- UID-nya cocok dengan UID profil lokal yang disimpan.

Tombol ini tidak meminta atau memverifikasi password, karena hanya
**melanjutkan sesi Firebase yang sudah ada**. Tidak ada mekanisme login offline
untuk akun yang sudah sign-out, dan perangkat yang digunakan harus dijaga
keamanannya. Akses dengan biometrik/PIN lokal dapat ditambahkan sebagai
lapisan perlindungan tersendiri jika dibutuhkan.

Ketika sesi lama dilanjutkan, Cling tidak otomatis membuat pemasukan rutin
berdasarkan konfigurasi offline yang mungkin sudah kedaluwarsa.

## Status onboarding bulanan

`verified_process` sekarang hanya diubah menjadi `true` setelah pengguna
menyelesaikan kedua tahap onboarding dan:

1. Nilai pemasukan, anggaran, dan tanggal recurring telah disimpan di
   Firestore.
2. Proyeksi aturan recurring di SQLite berhasil diperbarui.
3. Cache profil bulanan berhasil disimpan.
4. Firestore berhasil mengonfirmasi `verified_process: true` dan cache
   lokal menandai onboarding selesai.

Jika salah satu tahap gagal, penyelesaian onboarding tidak dianggap berhasil
oleh aplikasi; pengguna dapat mencoba menyimpan kembali.

Login dan splash menggunakan kebijakan rute yang sama: pengguna terautentikasi
dengan onboarding belum selesai menuju `/verifOnboard`, sedangkan pengguna
yang sudah menyelesaikannya menuju `/main`.

Tombol **Skip** hanya melewati pengisian untuk sesi saat itu. Status onboarding
tetap belum selesai, sehingga pengguna akan diminta kembali pada startup
atau login berikutnya.

**Catatan data lama:** versi sebelumnya sempat mengubah
`verified_process` menjadi true sebelum onboarding. Status lama tersebut
tidak direset otomatis karena tidak mungkin membedakan pengguna yang
benar-benar sudah selesai dan yang sebelumnya melewati setup tanpa
memeriksa riwayat. Perbaikan alur ini berlaku untuk proses baru.

## Reset kata sandi dan logout

Reset password dilakukan melalui Firebase Authentication. Cache profil
dihapus pada logout. Data transaksi SQLite per UID tetap disimpan secara
lokal dan tidak menjadi data tamu.

## Pengujian

`test/features/ui/login_onboarding_policy_test.dart` mencakup eligibility
sesi Firebase dan penentuan rute onboarding/dashboard. Pengujian integrasi
Firebase dan UI aktual tetap diperlukan sebelum rilis.

```sh
flutter analyze --no-fatal-infos
flutter test
```
