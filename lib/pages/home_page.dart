import 'package:flutter/material.dart';
import '../models/libur.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  late Future<List<Libur>> _future;

  String _kode = 'ID';
  late int _tahun;
  String _query = '';

  static const Map<String, String> _negara = {
    'ID': 'Indonesia',
    'MY': 'Malaysia',
    'SG': 'Singapura',
    'JP': 'Jepang',
    'KR': 'Korea Selatan',
    'AU': 'Australia',
    'GB': 'Inggris',
    'US': 'Amerika Serikat',
    'DE': 'Jerman',
    'NL': 'Belanda',
  };

  @override
  void initState() {
    super.initState();
    _tahun = DateTime.now().year;
    _future = _api.fetchLibur(_tahun, _kode);
  }

  void _reload() {
    setState(() {
      _future = _api.fetchLibur(_tahun, _kode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    final daftarTahun = [now - 1, now, now + 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LiburKu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
            onPressed: _reload,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _kode,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Negara',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: _negara.entries
                        .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      _kode = v;
                      _reload();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    initialValue: _tahun,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Tahun',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    items: daftarTahun
                        .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text('$t'),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      _tahun = v;
                      _reload();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama hari libur...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Libur>>(
              future: _future,
              builder: (context, snapshot) {
                // 1. LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memuat data...'),
                      ],
                    ),
                  );
                }

                // 2. ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 56, color: Colors.red),
                          const SizedBox(height: 12),
                          const Text(
                            'Terjadi kesalahan saat mengambil data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _reload,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. SUCCESS
                final all = snapshot.data ?? [];
                final q = _query.toLowerCase();
                final list = all
                    .where((l) =>
                l.namaLokal.toLowerCase().contains(q) ||
                    l.nama.toLowerCase().contains(q))
                    .toList();

                if (list.isEmpty) {
                  return const Center(
                      child: Text('Hari libur tidak ditemukan'));
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${list.length} hari libur • ${_negara[_kode]} $_tahun',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final l = list[index];
                          final lewat = l.sudahLewat;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: ListTile(
                              leading: Container(
                                width: 52,
                                padding:
                                const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: lewat
                                      ? Colors.grey.shade300
                                      : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      l.angkaTanggal,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      l.bulanPendek,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                l.namaLokal,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: lewat ? Colors.grey : null,
                                ),
                              ),
                              subtitle: Text(
                                l.nama == l.namaLokal
                                    ? l.hari
                                    : '${l.nama} • ${l.hari}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                    libur: l,
                                    namaNegara: _negara[_kode] ?? _kode,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Sumber data: Nager.Date (date.nager.at)',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}