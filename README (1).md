# LiburKu

Aplikasi informasi hari libur publik berbasis Flutter. Pengguna dapat memilih negara dan tahun, lalu aplikasi mengambil data hari libur dari API Nager.Date dan menampilkannya dalam bentuk daftar dan halaman detail.

Project ini dibuat untuk Ujian Tengah Semester mata kuliah Pemrograman Mobile.

- **Nama**: Fatimah Habibah Az-Zahra
- **NIM**: 240605110007
- **Kelas**: A
- **Dosen Pengampu**: A'la Syauqi, M.Kom
- **Jurusan**: Teknik Informatika, UIN Maulana Malik Ibrahim Malang

## Fitur

- Daftar hari libur publik dari API (tanggal, nama lokal, nama Inggris, hari)
- Pilihan 10 negara: Indonesia, Malaysia, Singapura, Jepang, Korea Selatan, Australia, Inggris, Amerika Serikat, Jerman, Belanda
- Pilihan tahun: tahun sebelumnya, tahun berjalan, dan tahun berikutnya
- Pencarian hari libur berdasarkan nama lokal atau nama bahasa Inggris
- Halaman detail hari libur (tanggal lengkap, status, negara, cakupan, jenis)
- Penanda hari libur yang sudah lewat dan status "hari ini / sekian hari lagi / sekian hari yang lalu"
- Indikator loading, penanganan error, tombol **Coba lagi**, dan tombol muat ulang

## Teknologi

- Flutter (Dart), Material 3
- Package [`http`](https://pub.dev/packages/http) untuk permintaan HTTP
- Pemrograman asinkron dengan `async`/`await`, `Future`, dan `FutureBuilder`

## Sumber Data

Data diambil dari [Nager.Date](https://date.nager.at/) dengan endpoint:

```
https://date.nager.at/api/v3/PublicHolidays/{tahun}/{kodeNegara}
```

Contoh: `https://date.nager.at/api/v3/PublicHolidays/2026/ID`

## Struktur Kode

```
lib/
├── main.dart                  # Titik masuk aplikasi, tema Material 3
├── models/
│   └── libur.dart             # Model Libur dan pengolahan tanggal
├── pages/
│   ├── home_page.dart         # Halaman utama: pilihan, pencarian, daftar
│   └── detail_page.dart       # Halaman detail hari libur
└── services/
    └── api_service.dart       # Permintaan HTTP dan pemeriksaan respons
test/
└── libur_test.dart            # Pengujian otomatis model Libur
```

## Cara Menjalankan

Prasyarat: [Flutter SDK](https://docs.flutter.dev/get-started/install) terpasang, serta emulator atau perangkat Android, dan koneksi internet.

```bash
git clone https://github.com/zahra1203/LiburKu.git
cd LiburKu
flutter pub get
flutter run
```

## Pengujian

```bash
flutter analyze
flutter test
```

## Batasan

- Pilihan negara dan tahun terbatas
- Data hanya dapat dimuat saat perangkat terhubung ke internet (belum ada penyimpanan lokal)
