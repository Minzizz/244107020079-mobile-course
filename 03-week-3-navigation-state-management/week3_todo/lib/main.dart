import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/todo_page.dart';
import 'pages/stats_page.dart';
import 'pages/product_page.dart';
import 'widgets/scaffold_with_nav_bar.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Konfigurasi GoRouter untuk integrasi navigasi ToDo (Refactoring Challenge #3)
final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Daftar ToDo (Route: /)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) {
                final isDemo = state.uri.queryParameters['demo'] == 'true';
                final filter = state.uri.queryParameters['filter'];
                return TodoPage(
                  loadDemo: isDemo,
                  initialFilterName: filter,
                );
              },
            ),
          ],
        ),
        // Tab 2: Halaman Statistik (Route: /stats)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) {
                final forceErr = state.uri.queryParameters['error'] == 'true';
                return StatsPage(forceError: forceErr);
              },
            ),
          ],
        ),
        // Tab 3: Halaman Produk Praktikum 3 (Route: /products)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) => const ProductPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Week 3 - ToDo & State Management',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
    );
  }
}