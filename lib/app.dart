import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_theme.dart';
import 'features/config/providers/config_provider.dart';
import 'features/config/screens/config_screen.dart';
import 'features/orders/screens/orders_screen.dart';
import 'features/map/screens/map_screen.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  final configAsync = ref.watch(configNotifierProvider);

  return GoRouter(
    initialLocation: '/orders',
    redirect: (context, state) {
      // Wait until config is loaded
      if (configAsync.isLoading) return null;

      final isConfigured = ref.read(configNotifierProvider.notifier).isConfigured;
      if (!isConfigured && state.matchedLocation != '/config') {
        return '/config';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/config',
        builder: (_, __) => const ConfigScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (_, __) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (_, __) => const MapScreen(),
      ),
    ],
  );
});

class RouteOptimizerApp extends ConsumerWidget {
  const RouteOptimizerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: 'Route Optimizer',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
