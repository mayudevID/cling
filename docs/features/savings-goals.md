# Target Tabungan

## Tujuan

Target tabungan membantu pengguna menetapkan sasaran nominal dan mencatat setoran menuju sasaran tersebut.

## Membuat Target

Target baru membutuhkan:

- nama yang tidak kosong;
- ikon yang dipilih;
- nominal sasaran lebih dari nol.

Target disimpan dengan nilai terkumpul awal nol. Setelah berhasil, Home memuat ulang target dan jumlah total target.

## Daftar Target

Home menampilkan maksimal lima target. Jika jumlah target lebih banyak, item tambahan membuka halaman daftar lengkap.

Daftar lengkap memakai pagination berbasis ID. Halaman mengambil baris terakhir sebagai titik awal, lalu memuat kelompok berikutnya hingga data habis.

## Detail dan Setoran

Halaman detail memuat target dan seluruh riwayat setoran terkait. Setoran menyimpan ID target, tanggal, dan nominal.

Saat menambah setoran:

1. Nominal harus lebih dari nol.
2. Nominal tidak boleh melebihi sisa sasaran.
3. Riwayat setoran baru disimpan.
4. Nilai terkumpul target ditambah dengan nominal setoran.
5. Home dan daftar target diperbarui.

## Mengubah Target

Pengguna dapat mengubah nama, ikon, dan nominal sasaran. Nama tidak boleh kosong, sasaran harus lebih dari nol, dan sasaran baru tidak boleh lebih kecil daripada nilai yang sudah terkumpul.

## Menghapus Data

- Menghapus satu setoran mengurangi nilai terkumpul target sebesar nominal setoran tersebut.
- Menghapus target juga menghapus seluruh setoran yang memiliki ID target itu.
- Home dan daftar lengkap menerima perubahan setelah operasi berhasil.

## Model Data Lokal

- `goals`: ID, nama, ikon, sasaran, nilai terkumpul.
- `goal_savings`: ID, ID target, tanggal, nominal.

Nilai terkumpul disimpan pada target untuk pembacaan cepat. Riwayat setoran menjadi sumber rincian perubahan nilai.

## Invarian

- `0 <= collected <= target` melalui alur UI normal.
- Penghapusan setoran harus memperbarui `collected`.
- Penghapusan target harus menghapus setoran terkait.
- Perubahan target harus diteruskan ke Home dan daftar target aktif.

## Kegagalan dan Batasan

- Operasi setoran dan pembaruan nilai terkumpul dijalankan bersama dengan `Future.wait`, bukan transaction SQLite eksplisit.
- Foreign key dideklarasikan pada skema, tetapi perilaku cascade tidak digunakan; repository menghapus data terkait secara manual.
- Target dan setoran hanya lokal sampai backup dilakukan.
- Tidak ada bunga, tenggat target, kontribusi otomatis, atau transfer dari saldo.

## Source Terkait

- `lib/features/ui/main/add_goal/bloc/add_goal_bloc.dart`
- `lib/features/ui/main/goal_detail/bloc/goal_detail_bloc.dart`
- `lib/features/ui/main/goal_list/bloc/goal_list_bloc.dart`
- `lib/features/model/goal_model.dart`
- `lib/features/model/goal_saving_model.dart`
- `lib/features/repository/database_repository.dart`
