# Dasbor

## Tujuan

Home memberi ringkasan cepat kondisi keuangan dan akses ke tindakan utama.

## Informasi yang Ditampilkan

- Total saldo sepanjang waktu.
- Total pemasukan bulan berjalan.
- Total pengeluaran bulan berjalan.
- Progres pengeluaran terhadap anggaran bulanan.
- Hingga lima target tabungan terbaru dan akses ke daftar lengkap.
- Pengeluaran pada tanggal hari ini.
- Jumlah notifikasi yang belum dibaca.
- Nama pengguna dan mata uang aktif.

## Perhitungan

Total saldo dihitung dari jumlah seluruh pemasukan dikurangi jumlah seluruh pengeluaran. Ringkasan bulan berjalan memakai transaksi sejak hari pertama bulan sampai waktu saat ini.

Nilai anggaran berasal dari profil Firestore yang sudah disimpan dalam cache dan dimuat oleh `ProfileBloc`. Nilai transaksi berasal dari SQLite melalui `DatabaseRepository`.

## Tindakan Pengguna

Floating action button hanya tampil pada tab Home. Tombol ini memberi akses ke:

- tambah pemasukan;
- tambah pengeluaran;
- tambah target tabungan.

Kartu target membuka detail target. Tautan “lihat semua” membuka daftar target. Ikon notifikasi membuka inbox lokal.

## Sinkronisasi State

`HomeBloc` memuat ringkasan, target, pengeluaran hari ini, dan jumlah notifikasi. Fitur lain mengirim event penyegaran setelah perubahan data:

- tambah, ubah, atau hapus transaksi menyegarkan jumlah keuangan;
- perubahan pengeluaran menyegarkan pengeluaran hari ini;
- perubahan target atau setoran menyegarkan daftar target;
- perubahan status notifikasi menyegarkan penghitung belum dibaca.

## Peringatan Keuangan

Setelah ringkasan keuangan dimuat, Home memeriksa tiga kondisi:

- pengeluaran bulan berjalan melebihi anggaran bulanan;
- saldo bulan berjalan memenuhi kondisi peringatan;
- total saldo bernilai negatif.

Peringatan disimpan sebagai notifikasi lokal. Sistem membatasi duplikasi berdasarkan jenis dan periode waktu.

## Kegagalan dan Batasan

- Home menggabungkan data profil cloud dengan transaksi lokal. Profil lama atau data lokal berbeda perangkat dapat menghasilkan ringkasan yang tidak konsisten.
- State Home tidak melakukan sinkronisasi otomatis lintas perangkat.
- Ringkasan berubah setelah fitur pemilik data mengirim event penyegaran; tidak ada stream database global.
- Indikator kesehatan keuangan bergantung pada aturan lokal, bukan rekomendasi finansial personal.

## Source Terkait

- `lib/features/ui/main/home/page/home_page.dart`
- `lib/features/ui/main/home/bloc/home_bloc.dart`
- `lib/features/ui/main/main_page.dart`
- `lib/features/ui/main/main_widget/custom_fab.dart`
- `lib/features/repository/database_repository.dart`
