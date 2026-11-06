# Backup dan Restore

## Tujuan

Fitur backup memindahkan satu salinan basis data ke Firebase Storage. Restore mengganti basis data lokal dengan salinan milik akun yang sedang login.

## Data yang Dicakup

Backup menyalin berkas SQLite `cling_database.db`. Berkas tersebut memuat:

- pemasukan dan sumber pemasukan;
- pengeluaran dan kategori pengeluaran;
- target serta riwayat setoran;
- notifikasi lokal;
- aturan transaksi rutin.

Profil Firebase, preferensi SharedPreferences, dan sesi Authentication tidak berada di dalam berkas SQLite.

## Proses Backup

1. Repository menemukan direktori database lokal.
2. Berkas database aktif disalin ke berkas sementara bernama `{uid}.db`.
3. Berkas sementara diunggah ke `backupDb/{uid}.db` pada Firebase Storage.
4. Berkas sementara lokal dihapus setelah upload selesai.
5. Waktu backup terakhir diperbarui pada dokumen Firestore dan cache profil.

Backup dijalankan manual dari Settings.

## Proses Restore

Saat login, aplikasi memeriksa `lastBackupTime` pada profil. Jika nilai tersedia, pengguna menerima dialog pilihan restore.

Jika pengguna menyetujui:

1. Repository menutup koneksi SQLite.
2. Berkas database lokal dihapus.
3. Firebase Storage mengunduh `backupDb/{uid}.db` ke lokasi database utama.
4. Repository membuka kembali database.
5. Pemeriksaan transaksi rutin berjalan saat database dibuka.

Jika koneksi tidak tersedia, dialog memberi pilihan untuk mencoba kembali.

## Kepemilikan dan Identitas

Path backup memakai UID Firebase. Setiap akun memiliki satu nama objek tetap. Upload berikutnya mengganti objek akun yang sama menurut perilaku Firebase Storage pada path tersebut.

## Invarian Operasional

- Koneksi database harus ditutup sebelum berkas diganti.
- Restore harus memakai UID akun aktif.
- Repository harus membuka ulang database setelah download.
- Waktu backup hanya boleh mewakili backup yang berhasil.

## Risiko dan Batasan

- Restore bersifat mengganti seluruh database, bukan merge.
- Implementasi menghapus database lokal sebelum download selesai. Kegagalan download dapat meninggalkan database lokal kosong atau tidak tersedia.
- Tidak ada versioning backup, checksum, enkripsi tambahan tingkat aplikasi, atau pilihan snapshot.
- Tidak ada validasi skema database hasil download sebelum dibuka.
- Backup manual tidak menjamin data terbaru sudah tersimpan di cloud.
- Keamanan akses bergantung pada Firebase Authentication dan Firebase Storage Rules yang tidak dijelaskan oleh source aplikasi ini.
- Dokumen ini tidak membuktikan pemulihan berhasil pada perangkat nyata.

## Source Terkait

- `lib/features/repository/settings_repository.dart`
- `lib/features/repository/database_repository.dart`
- `lib/features/ui/login/bloc/login_bloc.dart`
- `lib/features/ui/main/profile/bloc/profile_bloc.dart`
- `lib/features/ui/main/settings/page/settings_page.dart`
