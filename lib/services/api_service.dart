import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/libur.dart';

class ApiService {
  static const String _base = 'https://date.nager.at/api/v3/PublicHolidays';

  /// Mengirim request GET, memeriksa status respons,
  /// lalu mengonversi JSON menjadi daftar objek Libur.
  Future<List<Libur>> fetchLibur(int tahun, String kodeNegara) async {
    final uri = Uri.parse('$_base/$tahun/$kodeNegara');

    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 20));

    final body = utf8.decode(response.bodyBytes);
    debugPrint('URL: $uri');
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${body.length > 300 ? body.substring(0, 300) : body}');

    if (response.statusCode == 404) {
      throw Exception(
          'Data tidak tersedia untuk negara/tahun ini (kode 404)');
    }
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${response.statusCode})');
    }
    if (body.trim().isEmpty) return [];

    final decoded = jsonDecode(body);
    if (decoded is! List) {
      throw Exception('Format respons API tidak dikenali');
    }

    return decoded
        .map((item) => Libur.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}