import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/route_stop.dart';
import '../providers/map_provider.dart';
import '../widgets/stop_detail_sheet.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(routeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Routes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/orders'),
        ),
        actions: [
          routesAsync.whenOrNull(
                data: (_) => IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Re-optimize',
                  onPressed: () => ref.invalidate(routeStateProvider),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: routesAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(routeStateProvider),
        ),
        data: (routes) => routes.isEmpty
            ? const _EmptyView()
            : _MapView(routes: routes),
      ),
    );
  }
}

// ── Map view ────────────────────────────────────────────────────────────────

class _MapView extends StatefulWidget {
  const _MapView({required this.routes});
  final List<DriverRoute> routes;

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  final _mapCtrl = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
  }

  void _fitBounds() {
    final allPoints = [
      storeLocation,
      ...widget.routes
          .expand((r) => r.stops.map((s) => s.location)),
    ];
    if (allPoints.length < 2) return;

    final lats = allPoints.map((p) => p.latitude);
    final lons = allPoints.map((p) => p.longitude);

    _mapCtrl.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(
          LatLng(lats.reduce((a, b) => a < b ? a : b),
              lons.reduce((a, b) => a < b ? a : b)),
          LatLng(lats.reduce((a, b) => a > b ? a : b),
              lons.reduce((a, b) => a > b ? a : b)),
        ),
        padding: const EdgeInsets.all(48),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapCtrl,
          options: MapOptions(
            initialCenter: storeLocation,
            initialZoom: 12,
          ),
          children: [
            // OSM tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.batterbowl.route_optimizer',
              maxZoom: 19,
            ),
            // Route polylines
            PolylineLayer(
              polylines: widget.routes.map((route) {
                return Polyline(
                  points: route.polyline,
                  color: route.color.withOpacity(0.8),
                  strokeWidth: 4,
                  borderColor: Colors.white.withOpacity(0.5),
                  borderStrokeWidth: 1.5,
                );
              }).toList(),
            ),
            // Stop markers
            MarkerLayer(
              markers: [
                // Store marker
                Marker(
                  point: storeLocation,
                  width: 44,
                  height: 44,
                  child: const _StoreMarker(),
                ),
                // Driver stop markers
                ...widget.routes.expand((route) => route.stops.map((stop) {
                      return Marker(
                        point: stop.location,
                        width: 36,
                        height: 36,
                        child: GestureDetector(
                          onTap: () => _showStopDetail(context, route, stop),
                          child: _StopMarker(
                            number: stop.stopNumber,
                            color: route.color,
                            isDelivered: stop.isDelivered,
                          ),
                        ),
                      );
                    })),
              ],
            ),
            // Attribution
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        // Driver legend
        Positioned(
          top: 12,
          right: 12,
          child: _DriverLegend(routes: widget.routes),
        ),
      ],
    );
  }

  void _showStopDetail(
      BuildContext context, DriverRoute route, RouteStop stop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StopDetailSheet(
        stop: stop,
        driverIndex: route.driverIndex,
        stopIndex: route.stops.indexOf(stop),
        driverColor: route.color,
      ),
    );
  }
}

// ── Marker widgets ───────────────────────────────────────────────────────────

class _StoreMarker extends StatelessWidget {
  const _StoreMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brand,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: const Icon(Icons.store, color: Colors.white, size: 22),
    );
  }
}

class _StopMarker extends StatelessWidget {
  const _StopMarker({
    required this.number,
    required this.color,
    required this.isDelivered,
  });

  final int number;
  final Color color;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDelivered ? Colors.grey.shade400 : color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
      ),
      alignment: Alignment.center,
      child: isDelivered
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
    );
  }
}

// ── Driver legend ─────────────────────────────────────────────────────────────

class _DriverLegend extends StatelessWidget {
  const _DriverLegend({required this.routes});
  final List<DriverRoute> routes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: routes.map((route) {
          final delivered =
              route.stops.where((s) => s.isDelivered).length;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: route.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${route.driverLabel}  '
                  '${route.stops.length} stops  '
                  '${route.totalDistanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(fontSize: 11),
                ),
                if (delivered > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '($delivered done)',
                    style: TextStyle(
                        fontSize: 11, color: Colors.green.shade700),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Placeholder screens ──────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Geocoding addresses & optimizing routes…'),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No orders to route.'),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Failed to load routes',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
