import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week3_todo/models/stat_item.dart';
import 'package:week3_todo/providers/stats_provider.dart';

void main() {
  group('StatsNotifier Unit Tests (AI Challenge)', () {
    test('StatsNotifier mengembalikan AsyncData dengan 3 item saat sukses', () async {
      final mockService = StatsService(
        delay: Duration.zero,
        failureRate: 0.0,
      );

      final container = ProviderContainer(
        overrides: [
          statsServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      AsyncValue<List<StatItem>>? currentState;
      final sub = container.listen<AsyncValue<List<StatItem>>>(
        statsProvider,
        (previous, next) {
          currentState = next;
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      // Tunggu hingga pemrosesan asinkron selesai
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(currentState, isA<AsyncData<List<StatItem>>>());
      final stats = currentState!.value!;
      expect(stats.length, 3);
      expect(stats[0].label, 'Tugas Selesai');
      expect(stats[1].label, 'Tugas Tertunda');
      expect(stats[2].label, 'Tingkat Produktivitas');
    });

    test('StatsNotifier menghasilkan state error saat pengambilan data gagal', () async {
      final mockService = StatsService(
        delay: Duration.zero,
        failureRate: 1.0,
      );

      final container = ProviderContainer(
        overrides: [
          statsServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      AsyncValue<List<StatItem>>? currentState;
      final sub = container.listen<AsyncValue<List<StatItem>>>(
        statsProvider,
        (previous, next) {
          currentState = next;
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      // Tunggu hingga pemrosesan asinkron melempar exception dan ditangkap
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Di Riverpod, verifikasi bahwa state mendeteksi error
      expect(currentState?.hasError, isTrue);
      expect(currentState?.error.toString(), contains('Gagal memuat statistik'));
    });

    test('Method refresh() memperbarui state dari error ke sukses', () async {
      final mockService = StatsService(
        delay: Duration.zero,
        failureRate: 1.0, // Mulai dengan kegagalan
      );

      final container = ProviderContainer(
        overrides: [
          statsServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      AsyncValue<List<StatItem>>? currentState;
      final sub = container.listen<AsyncValue<List<StatItem>>>(
        statsProvider,
        (previous, next) {
          currentState = next;
        },
        fireImmediately: true,
      );
      addTearDown(sub.close);

      // Tunggu build() awal yang gagal
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(currentState?.hasError, isTrue);

      // Ubah failureRate menjadi 0.0 (sukses), lalu panggil refresh
      mockService.failureRate = 0.0;
      await container.read(statsProvider.notifier).refresh();

      // State sekarang harus AsyncData dengan 3 item
      expect(currentState, isA<AsyncData<List<StatItem>>>());
      expect(currentState?.value?.length, 3);
      expect(currentState?.value?[0].label, 'Tugas Selesai');
    });
  });
}
