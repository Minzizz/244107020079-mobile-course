import 'package:flutter_test/flutter_test.dart';
import 'package:week3_navigation/main.dart';

void main() {
  testWidgets('Navigasi dari HomePage ke DetailPage dengan GoRouter', (tester) async {
    // Build app dan trigger frame pertama
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi berada di halaman Home
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);

    // Tap pada Item 1
    await tester.tap(find.text('Item 1'));
    await tester.pumpAndSettle();

    // Verifikasi telah berpindah ke DetailPage dengan id 1
    expect(find.text('Detail 1'), findsOneWidget);
    expect(find.text('Anda membuka item dengan id: 1'), findsOneWidget);
  });
}
