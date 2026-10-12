import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

/// Halaman StatsPage yang dibangun sebagai [ConsumerStatefulWidget] untuk mengonsumsi [statsProvider].
/// Halaman ini mengimplementasikan penanganan state asinkron secara komprehensif menggunakan
/// pola `AsyncValue.when`:
/// 1. State Loading: menampilkan spinner (indikator loading) dan teks penjelas.
/// 2. State Error: menampilkan ikon peringatan, pesan error, serta tombol retry untuk memuat ulang.
/// 3. State Data (Success): menampilkan ListView dengan 3 item statistik ringkasan ToDo.
class StatsPage extends ConsumerStatefulWidget {
  final bool forceError;

  const StatsPage({
    super.key,
    this.forceError = false,
  });

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.forceError) {
      ref.read(statsServiceProvider).forceError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Membaca state asinkron dari statsProvider menggunakan ref.watch
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Tugas'),
        actions: [
          // Tombol refresh manual pada AppBar
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: () {
              ref.read(statsServiceProvider).forceError = false;
              ref.read(statsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      // 2. Menangani kondisi state: jika terdapat error, tampilkan UI error dan tombol retry
      body: statsAsync.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 54,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi Kesalahan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      statsAsync.error
                          .toString()
                          .replaceFirst('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(statsServiceProvider).forceError = false;
                        ref.read(statsProvider.notifier).refresh();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          : statsAsync.when(
        // === STATE LOADING ===
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Memuat data statistik...',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),

        // === STATE ERROR ===
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 54,
                ),
                const SizedBox(height: 16),
                Text(
                  'Terjadi Kesalahan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                // Tombol Retry (Coba lagi) untuk memicu pemuatan ulang data
                FilledButton.icon(
                  onPressed: () {
                    // Reset forceError agar pemanggilan berikutnya sukses
                    ref.read(statsServiceProvider).forceError = false;
                    ref.read(statsProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),

        // === STATE DATA / SUCCESS ===
        data: (statsList) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: statsList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = statsList[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: item.color.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              color: item.color.withValues(alpha: 0.05),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  backgroundColor: item.color.withValues(alpha: 0.15),
                  child: Icon(item.icon, color: item.color),
                ),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
