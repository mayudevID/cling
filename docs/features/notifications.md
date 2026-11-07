# Notifikasi

## Tujuan

Notifikasi memberi peringatan kondisi keuangan dan menyimpan riwayat peringatan di perangkat.

## Jenis Notifikasi

Source mendefinisikan tiga jenis kondisi:

- tipe 0: pengeluaran bulan berjalan melewati anggaran bulanan;
- tipe 1: kondisi saldo bulan berjalan;
- tipe 2: total saldo negatif.

Home menjalankan pemeriksaan setelah menghitung ringkasan keuangan.

## Pencegahan Duplikasi

- Tipe 0 dibatasi satu notifikasi per bulan.
- Tipe 1 dibatasi satu notifikasi per bulan.
- Tipe 2 dibatasi satu notifikasi per hari.

Pemeriksaan dilakukan dengan query terhadap tanggal dan tipe notifikasi pada SQLite.

## Inbox

Inbox memuat notifikasi terbaru lebih dahulu. Pagination memakai kombinasi tanggal dan ID sebagai cursor, dengan ukuran halaman 12 item. Baris terbaru diambil sebagai titik awal, lalu halaman berikutnya memuat data yang lebih lama.

## Status Baca

Setiap notifikasi memiliki `isRead`. Pengguna dapat:

- menandai satu notifikasi sebagai dibaca;
- menandai semua notifikasi sebagai dibaca.

Setelah perubahan, Home menghitung ulang jumlah notifikasi yang belum dibaca.

## Model Data Lokal

Tabel notifikasi menyimpan ID, judul, deskripsi, tipe, tanggal ISO 8601, dan status baca sebagai integer. Data tidak dikirim ke Firebase dan tidak bergantung pada Firebase Cloud Messaging.

## Lifecycle

Notifikasi dibuat saat Home memuat ulang jumlah keuangan. Karena itu, kondisi peringatan dapat ada sebelum notifikasi dibuat jika Home belum menjalankan pemeriksaan terbaru.

## Kegagalan dan Batasan

- Ini adalah inbox lokal, bukan push notification sistem operasi.
- Judul dan deskripsi yang disimpan oleh pemeriksaan Home saat ini dibentuk dari nilai acak; UI memetakan presentasi berdasarkan tipe.
- Menandai semua sebagai dibaca memperbarui database dan penghitung, tetapi daftar state aktif tidak dibentuk ulang pada handler tersebut.
- Data notifikasi ikut dalam backup database, tetapi tidak memiliki sinkronisasi langsung.
- Pagination berhenti saat halaman berisi kurang dari 12 item.

## Source Terkait

- `lib/features/ui/main/notification/bloc/notification_bloc.dart`
- `lib/features/ui/main/notification/page/notification_page.dart`
- `lib/features/ui/main/home/bloc/home_bloc.dart`
- `lib/features/model/notification_model_class.dart`
- `lib/features/repository/database_repository.dart`
