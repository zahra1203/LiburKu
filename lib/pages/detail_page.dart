import 'package:flutter/material.dart';
import '../models/libur.dart';

class DetailPage extends StatelessWidget {
  final Libur libur;
  final String namaNegara;
  const DetailPage({super.key, required this.libur, required this.namaNegara});

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }

  String _status() {
    final s = libur.selisihHari;
    if (s == null) return '-';
    if (s == 0) return 'Hari ini';
    if (s > 0) return '$s hari lagi';
    return '${-s} hari yang lalu';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Hari Libur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.event,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                libur.namaLokal,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Center(
              child: Text(
                libur.tanggalLengkap,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(height: 32),
            _baris('Nama lokal', libur.namaLokal),
            _baris('Nama Inggris', libur.nama),
            _baris('Tanggal', libur.tanggalLengkap),
            _baris('Status', _status()),
            _baris('Negara', '$namaNegara (${libur.kodeNegara})'),
            _baris('Cakupan', libur.nasional ? 'Nasional' : 'Regional'),
            _baris('Jenis',
                libur.jenis.isEmpty ? '-' : libur.jenis.join(', ')),
            const SizedBox(height: 24),
            const Text(
              'Sumber data: Nager.Date',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}