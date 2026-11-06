# Autentikasi dan Onboarding

## Tujuan

Fitur ini membentuk identitas pengguna, mempertahankan sesi, dan mengumpulkan data awal yang dibutuhkan fitur keuangan.

## Registrasi

Pengguna memasukkan nama, email, kata sandi, konfirmasi kata sandi, dan mata uang. Sebelum mengirim data, aplikasi memeriksa:

- perangkat memiliki koneksi Wi-Fi atau seluler;
- seluruh kolom wajib terisi;
- email memiliki format valid;
- kata sandi minimal delapan karakter;
- kata sandi dan konfirmasi sama.

Firebase Authentication membuat akun. Nama disimpan sebagai `displayName`. Firestore membuat dokumen `users/{uid}` berisi mata uang, waktu pembuatan, waktu backup, tanggal transaksi rutin, status onboarding, pemasukan bulanan, dan anggaran bulanan. Firebase mengirim email verifikasi setelah akun dibuat.

## Login

Login memakai email dan kata sandi dengan validasi koneksi, kelengkapan data, format email, dan panjang kata sandi. Setelah Firebase menerima kredensial:

1. Aplikasi mengambil dokumen profil dari Firestore.
2. Profil disimpan dalam SharedPreferences sebagai cache pengguna.
3. Mata uang aktif disesuaikan dengan profil.
4. Jika backup tersedia, pengguna ditawari pemulihan data lokal.
5. Jika pemasukan rutin sudah dikonfigurasi, aturan rutin lokal dibuat.
6. Aplikasi mengarahkan pengguna ke halaman utama.

Jika email Firebase sudah terverifikasi tetapi onboarding belum ditandai selesai, aplikasi memperbarui `verified_process` lalu membuka alur data bulanan.

## Onboarding Data Bulanan

Onboarding meminta pemasukan bulanan, anggaran bulanan, dan tanggal pemasukan rutin. Pemasukan serta anggaran harus lebih dari nol dan dapat diubah menjadi angka. Data disimpan ke Firestore, lalu cache profil diperbarui.

## Sesi dan Redirect

`AppBloc` mendengarkan `FirebaseAuth.userChanges()`. Splash menunggu animasi selesai, lalu memilih tujuan:

- pengguna terautentikasi dengan proses login dan registrasi selesai: halaman utama;
- kondisi lain: onboarding awal.

Logout menghapus cache profil dan penanda proses autentikasi, lalu mengakhiri sesi Firebase.

## Reset dan Perubahan Kata Sandi

Lupa kata sandi dan perubahan kata sandi memakai email reset dari Firebase Authentication. Aplikasi tidak mengganti kata sandi langsung di perangkat.

## Data dan Dependensi

- Firebase Authentication: akun, sesi, verifikasi email, reset kata sandi.
- Cloud Firestore: dokumen profil pengguna.
- SharedPreferences: cache profil dan penanda proses login/registrasi.
- Connectivity Plus: pemeriksaan jenis koneksi sebelum operasi jaringan.

## Kegagalan dan Batasan

- Pemeriksaan koneksi hanya mengenali Wi-Fi dan seluler; status jaringan tidak menjamin Firebase dapat dijangkau.
- Login anonim memiliki event, tetapi handler saat ini tidak menjalankan perilaku.
- Pemeriksaan wajib email terverifikasi pada login dinonaktifkan di repository.
- Cache profil menjadi syarat state awal terautentikasi, bukan hanya keberadaan sesi Firebase.
- Restore yang dipilih saat login dapat mengganti basis data lokal sebelum halaman utama dibuka.

## Source Terkait

- `lib/features/repository/auth_repository.dart`
- `lib/features/ui/register/bloc/register_bloc.dart`
- `lib/features/ui/login/bloc/login_bloc.dart`
- `lib/features/ui/app_bloc/app_bloc.dart`
- `lib/features/ui/verification_success/bloc/monthly_data_bloc.dart`
- `lib/features/ui/splash/splash_content.dart`
