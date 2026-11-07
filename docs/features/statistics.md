# Statistik

## Tujuan

Fitur statistik mengubah transaksi lokal menjadi ringkasan visual agar pengguna dapat melihat pola pemasukan dan pengeluaran.

## Mode Tampilan

Statistics memiliki tiga mode:

- **All**: perbandingan pemasukan dan pengeluaran serta kategori terbesar.
- **Income**: tren dan distribusi pemasukan.
- **Expense**: distribusi pengeluaran.

Pemilih mode mengubah state tampilan tanpa memindahkan route utama.

## Agregasi Utama

Repository menjalankan query SQLite untuk:

- menjumlahkan pemasukan dan pengeluaran per bulan pada tahun berjalan;
- memilih hingga tujuh kategori atau sumber dengan nilai terbesar;
- menghitung pemasukan tahunan;
- menghitung distribusi pemasukan berdasarkan sumber;
- menghitung distribusi pengeluaran berdasarkan kategori.

Bulan yang hanya memiliki satu jenis transaksi tetap digabungkan ke struktur data yang sama dengan nilai nol untuk jenis lain.

## Rincian Kategori

Pengguna dapat membuka kategori statistik untuk melihat transaksi yang membentuk nilai agregat. Query detail memakai:

- jenis arus: pemasukan atau pengeluaran;
- kategori atau sumber terpilih;
- rentang tanggal yang dipilih.

Hasil diurutkan berdasarkan nominal terbesar.

## Penyegaran State

`StatisticsBloc` dibuat pada tingkat aplikasi dan langsung memuat agregasi utama. Tambah, edit, atau hapus transaksi mengirim event untuk menghitung ulang bagian terkait.

Pemisahan event menghindari pengambilan seluruh statistik saat hanya satu jenis data berubah, tetapi konsistensi tetap bergantung pada setiap alur mutasi mengirim event yang tepat.

## Data dan Presentasi

Statistik membaca SQLite sebagai sumber data. Model chart dan pie hanya membentuk data presentasi; tidak ada tabel statistik permanen. Warna, label, dan mata uang ditentukan pada lapisan UI serta pengaturan bahasa dan mata uang aktif.

## Kegagalan dan Batasan

- Statistik tahunan memakai tahun kalender saat ini.
- Agregasi terbesar dibatasi tujuh item.
- Statistik tidak memiliki sinkronisasi cloud atau perbandingan lintas perangkat.
- Hasil query bergantung pada tanggal ISO yang tersimpan benar.
- Tidak ada filter akun, tag kustom, merchant, atau rentang tahun bebas pada model saat ini.

## Source Terkait

- `lib/features/ui/main/statistics/bloc/statistics_bloc.dart`
- `lib/features/ui/main/statistics/page/statistics_page.dart`
- `lib/features/ui/main/statistics/page/stats_all.dart`
- `lib/features/ui/main/statistics/page/state_income.dart`
- `lib/features/ui/main/statistics/page/stats_expense.dart`
- `lib/features/ui/main/stats_detail/bloc/stats_detail_bloc.dart`
- `lib/features/repository/database_repository.dart`
