import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier asinkron untuk simulasi pengambilan data produk (Praktikum 3).
/// Mendemonstrasikan penggunaan AsyncNotifier dan AsyncValue untuk menangani
/// loading, error, dan success.
class ProductsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Simulasi network delay 2 detik
    await Future.delayed(const Duration(seconds: 2));
    return ['Keyboard Mechanical', 'Wireless Mouse', 'Gaming Monitor 144Hz'];
  }

  /// Memuat ulang data produk
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<List<String>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Keyboard Mechanical', 'Wireless Mouse', 'Gaming Monitor 144Hz', 'Noise Cancelling Headset'];
  }
}

/// Provider global untuk daftar produk
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<String>>(
        ProductsNotifier.new);
