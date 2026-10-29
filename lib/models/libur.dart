class Libur {
  final String tanggal;
  final String namaLokal;
  final String nama;
  final String kodeNegara;
  final bool nasional;
  final List<String> jenis;

  Libur({
    required this.tanggal,
    required this.namaLokal,
    required this.nama,
    required this.kodeNegara,
    required this.nasional,
    required this.jenis,
  });

  /// Mengubah satu objek JSON dari Nager.Date menjadi objek Libur.
  factory Libur.fromJson(Map<String, dynamic> json) {
    final types = json['types'] as List?;
    return Libur(
      tanggal: json['date']?.toString() ?? '',
      namaLokal: json['localName']?.toString() ?? '-',
      nama: json['name']?.toString() ?? '-',
      kodeNegara: json['countryCode']?.toString() ?? '-',
      nasional: json['global'] as bool? ?? true,
      jenis: types?.map((e) => e.toString()).toList() ?? [],
    );
  }

  static const List<String> _hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _bulanPendek = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MEI',
    'JUN',
    'JUL',
    'AGU',
    'SEP',
    'OKT',
    'NOV',
    'DES',
  ];

  DateTime? get date => DateTime.tryParse(tanggal);

  String get hari {
    final d = date;
    return d == null ? '-' : _hari[d.weekday - 1];
  }

  String get angkaTanggal {
    final d = date;
    return d == null ? '-' : d.day.toString();
  }

  String get bulanPendek {
    final d = date;
    return d == null ? '' : _bulanPendek[d.month - 1];
  }

  String get tanggalLengkap {
    final d = date;
    if (d == null) return tanggal;
    return '$hari, ${d.day} ${_bulan[d.month - 1]} ${d.year}';
  }

  /// Selisih hari dari hari ini. Negatif = sudah lewat.
  int? get selisihHari {
    final d = date;
    if (d == null) return null;
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);
    return DateTime(d.year, d.month, d.day).difference(hariIni).inDays;
  }

  bool get sudahLewat => (selisihHari ?? 0) < 0;
}