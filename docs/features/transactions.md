# Transaksi

## Tujuan

Fitur transaksi mencatat arus uang masuk dan keluar, menyediakan riwayat bulanan, serta menjaga agregasi Home dan Statistics tetap diperbarui.

## Jenis Transaksi

### Pemasukan

Pemasukan menyimpan tanggal dan waktu, deskripsi, nominal, serta sumber pemasukan. Sumber bawaan mencakup pekerjaan tetap, investasi, bisnis, hadiah, kategori lain, dan kesehatan atau wellbeing.

### Pengeluaran

Pengeluaran menyimpan tanggal dan waktu, nama item, nominal, serta kategori pengeluaran. Kategori bawaan mencakup tagihan, bisnis dan investasi, hiburan, makanan dan minuman, hadiah, kesehatan dan kecantikan, belanja, langganan, transportasi, dan kategori lain.

## Menambah Transaksi

Pengguna memilih jenis transaksi dari Home. Form menerima tanggal, waktu, kategori, deskripsi atau item, dan nominal. Aplikasi menolak penyimpanan jika kategori belum dipilih atau nominal bernilai nol.

Setelah SQLite menyimpan data, BLoC terkait diperbarui:

- Home menghitung ulang ringkasan bulan dan total saldo;
- Transaction memuat ulang bulan aktif bila sesuai;
- Statistics menghitung ulang agregasi dan kategori;
- pengeluaran juga menyegarkan daftar pengeluaran hari ini.

## Riwayat Bulanan

Tab Transactions menggabungkan pemasukan dan pengeluaran untuk bulan terpilih. Daftar dikelompokkan berdasarkan tanggal. Pengguna dapat pindah bulan memakai kontrol tanggal atau gestur horizontal.

## Mengubah dan Menghapus

Pemilihan transaksi membuka form edit sesuai jenis transaksi. Perubahan mempertahankan identitas transaksi dan mengganti field yang relevan. Penghapusan menghapus baris dari tabel pemasukan atau pengeluaran. Setelah operasi, tampilan agregat menerima event penyegaran yang sama seperti alur tambah.

## Model Data Lokal

- Tabel pemasukan memiliki foreign key ke sumber pemasukan.
- Tabel pengeluaran memiliki foreign key ke kategori pengeluaran.
- Nominal disimpan dalam kolom SQLite bertipe `INTEGER`, sementara model aplikasi memakai nilai numerik yang dapat direpresentasikan sebagai `double`.
- Tanggal disimpan sebagai string ISO 8601.

## Kalkulator

Form nominal dapat membuka kalkulator. Nilai hasil kalkulasi dikembalikan ke form sebagai nominal transaksi. Kalkulator merupakan alat input, bukan sumber data terpisah.

## Aturan dan Invarian

- Setiap transaksi harus memiliki kategori atau sumber.
- Nominal nol tidak dapat disimpan melalui form tambah.
- Jenis transaksi menentukan tabel, model, dan label field.
- Agregasi tidak disimpan sebagai tabel terpisah; nilai dihitung dari transaksi.

## Kegagalan dan Batasan

- Data transaksi hanya lokal sampai backup manual dilakukan.
- Kategori bawaan dibuat saat basis data versi pertama dibuat dan tidak memiliki UI pengelolaan kategori.
- Tidak ada sinkronisasi transaksi per baris dengan backend.
- Validasi form menangani format angka dan kegagalan SQLite, tetapi tidak menyediakan transaction database lintas pembaruan UI.

## Source Terkait

- `lib/features/ui/main/add_in_ex/bloc/add_income_expense_bloc.dart`
- `lib/features/ui/main/edit_in_ex/bloc/edit_income_expense_bloc.dart`
- `lib/features/ui/main/transaction/bloc/transaction_bloc.dart`
- `lib/features/ui/main/transaction/page/transaction_page.dart`
- `lib/features/model/income_model.dart`
- `lib/features/model/expense_model.dart`
- `lib/features/repository/database_repository.dart`
- `lib/core/init_database.dart`
