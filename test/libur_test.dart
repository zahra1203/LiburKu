import 'package:flutter_test/flutter_test.dart';
import 'package:negaraku/models/libur.dart';

void main() {
  group('Libur.fromJson', () {
    test('membaca field dari JSON Nager.Date', () {
      final libur = Libur.fromJson({
        'date': '2026-08-17',
        'localName': 'Hari Kemerdekaan',
        'name': 'Independence Day',
        'countryCode': 'ID',
        'global': true,
        'types': ['Public'],
      });

      expect(libur.namaLokal, 'Hari Kemerdekaan');
      expect(libur.nama, 'Independence Day');
      expect(libur.kodeNegara, 'ID');
      expect(libur.nasional, true);
      expect(libur.jenis, ['Public']);
    });

    test('memakai nilai cadangan jika field tidak ada', () {
      final libur = Libur.fromJson({});

      expect(libur.namaLokal, '-');
      expect(libur.nama, '-');
      expect(libur.nasional, true);
      expect(libur.jenis, isEmpty);
      expect(libur.hari, '-');
    });
  });

  group('Pengolahan tanggal', () {
    final libur = Libur.fromJson({
      'date': '2026-08-17',
      'localName': 'Hari Kemerdekaan',
      'name': 'Independence Day',
      'countryCode': 'ID',
    });

    test('hari, angka tanggal, dan bulan pendek', () {
      expect(libur.hari, 'Senin');
      expect(libur.angkaTanggal, '17');
      expect(libur.bulanPendek, 'AGU');
    });

    test('tanggal lengkap dalam bahasa Indonesia', () {
      expect(libur.tanggalLengkap, 'Senin, 17 Agustus 2026');
    });

    test('sudahLewat untuk tanggal lampau dan mendatang', () {
      final lampau = Libur.fromJson({'date': '2000-01-01'});
      final depan = Libur.fromJson({'date': '2999-01-01'});

      expect(lampau.sudahLewat, true);
      expect(depan.sudahLewat, false);
    });
  });
}
