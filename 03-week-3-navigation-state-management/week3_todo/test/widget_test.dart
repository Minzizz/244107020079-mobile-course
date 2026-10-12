import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week3_todo/main.dart';
import 'package:week3_todo/providers/stats_provider.dart';

void main() {
  // Helper ProviderScope dengan override StatsService tanpa delay untuk kestabilan test
  Widget createTestWidget() {
    final mockService = StatsService(
      delay: Duration.zero,
      failureRate: 0.0,
    );

    return ProviderScope(
      overrides: [
        statsServiceProvider.overrideWithValue(mockService),
      ],
      child: const MyApp(),
    );
  }

  testWidgets('Menambah tugas baru dan menampilkannya di daftar', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Pastikan teks kosong tampil pada awal
    expect(find.text('Belum ada tugas'), findsOneWidget);

    // Buka dialog tambah tugas
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Masukkan judul tugas baru
    await tester.enterText(find.byType(TextField), 'Kerjakan PR minggu 3');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    // Pastikan tugas tampil
    expect(find.text('Kerjakan PR minggu 3'), findsOneWidget);
  });

  testWidgets('Toggle status tugas dan verifikasi filter aktif/selesai', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Tambah 2 tugas
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tugas Pertama');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tugas Kedua');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Tugas Pertama'), findsOneWidget);
    expect(find.text('Tugas Kedua'), findsOneWidget);

    // Tandai Tugas Pertama sebagai selesai (centang Checkbox pertama)
    final firstCheckbox = find.byType(Checkbox).first;
    await tester.tap(firstCheckbox);
    await tester.pumpAndSettle();

    // Filter "Aktif"
    await tester.tap(find.text('Aktif'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas Pertama'), findsNothing);
    expect(find.text('Tugas Kedua'), findsOneWidget);

    // Filter "Selesai"
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas Pertama'), findsOneWidget);
    expect(find.text('Tugas Kedua'), findsNothing);

    // Filter "Semua"
    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Tugas Pertama'), findsOneWidget);
    expect(find.text('Tugas Kedua'), findsOneWidget);
  });

  testWidgets('Navigasi antar tab menggunakan NavigationBar GoRouter', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verifikasi berada di tab ToDo
    expect(find.text('ToDo List'), findsOneWidget);

    // Pindah ke tab Statistik
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Statistik Tugas'), findsOneWidget);

    // Pindah ke tab Produk
    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Katalog Produk (Praktikum 3)'), findsOneWidget);

    // Kembali ke tab ToDo
    await tester.tap(find.byIcon(Icons.check_box_outlined));
    await tester.pumpAndSettle();
    expect(find.text('ToDo List'), findsOneWidget);
  });
}
