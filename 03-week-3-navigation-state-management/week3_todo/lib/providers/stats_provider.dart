import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/stat_item.dart';

/// Service simulasi fetch statistik untuk memisahkan I/O/network dari Notifier
/// sehingga mempermudah pengujian (unit testing) dan verifikasi.
class StatsService {
  final Random _random;
  final Duration delay;
  double failureRate;
  bool forceError;

  StatsService({
    Random? random,
    this.delay = const Duration(seconds: 2),
    this.failureRate = 0.3,
    this.forceError = false,
  }) : _random = random ?? Random();

  /// Mengambil data statistik secara asinkron dengan simulasi delay dan kemungkinan gagal.
  Future<List<StatItem>> fetchStats() async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    } else {
      await Future.microtask(() {});
    }

    // Simulasi kegagalan 30% atau force error
    if (forceError || _random.nextDouble() < failureRate) {
      throw Exception('Gagal memuat statistik dari server (Koneksi bermasalah)');
    }

    // Mengembalikan 3 item statistik sesuai spesifikasi AI Challenge
    return const [
      StatItem(
        label: 'Tugas Selesai',
        value: '18 Tugas',
        icon: Icons.check_circle_outline,
        color: Colors.teal,
      ),
      StatItem(
        label: 'Tugas Tertunda',
        value: '5 Tugas',
        icon: Icons.pending_actions,
        color: Colors.orange,
      ),
      StatItem(
        label: 'Tingkat Produktivitas',
        value: '78.2%',
        icon: Icons.insights,
        color: Colors.indigo,
      ),
    ];
  }
}

/// Provider untuk StatsService, memungkinkan mock/override pada unit test
final statsServiceProvider = Provider<StatsService>((ref) {
  return StatsService();
});

/// AsyncNotifier untuk mengelola state statistik.
/// Menggunakan Riverpod AsyncNotifier modern yang secara otomatis mengelola
/// siklus state: AsyncLoading, AsyncError, dan AsyncData.
class StatsNotifier extends AsyncNotifier<List<StatItem>> {
  @override
  Future<List<StatItem>> build() async {
    final service = ref.read(statsServiceProvider);
    return service.fetchStats();
  }

  /// Fungsi refresh untuk memicu pengambilan ulang data (misal saat retry setelah error)
  Future<void> refresh() async {
    // Ubah state menjadi AsyncLoading agar UI menampilkan indikator loading
    state = const AsyncLoading();
    // AsyncValue.guard menangkap exception dan otomatis mengubah state menjadi AsyncError jika gagal
    state = await AsyncValue.guard(() async {
      final service = ref.read(statsServiceProvider);
      return service.fetchStats();
    });
  }
}

/// Provider global untuk StatsNotifier
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<StatItem>>(StatsNotifier.new);
