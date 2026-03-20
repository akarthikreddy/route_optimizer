import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../models/driver_route.dart';
import '../models/route_stop.dart';
import '../providers/map_provider.dart';

class StopDetailSheet extends ConsumerStatefulWidget {
  const StopDetailSheet({
    super.key,
    required this.stop,
    required this.driverIndex,
    required this.stopIndex,
    required this.driverColor,
  });

  final RouteStop stop;
  final int driverIndex;
  final int stopIndex;
  final Color driverColor;

  @override
  ConsumerState<StopDetailSheet> createState() => _StopDetailSheetState();
}

class _StopDetailSheetState extends ConsumerState<StopDetailSheet> {
  bool _loading = false;

  Future<void> _markDelivered() async {
    setState(() => _loading = true);
    try {
      await ref.read(routeStateProvider.notifier).markAsDelivered(
            driverIndex: widget.driverIndex,
            stopIndex: widget.stopIndex,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stop = widget.stop;
    final order = stop.order;
    final billing = order.billing;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Row(
            children: [
              _StopBadge(
                number: stop.stopNumber,
                color: widget.driverColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      billing.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Order #${order.id}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (stop.isDelivered)
                Chip(
                  label: const Text('Delivered'),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Address
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: billing.fullAddress,
          ),
          if (billing.phone.isNotEmpty) ...[
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: billing.phone,
            ),
          ],
          if (billing.email.isNotEmpty) ...[
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: billing.email,
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Order items
          Text(
            'Items',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          ...order.lineItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Expanded(child: Text(item.name)),
                    Text('×${item.quantity}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(width: 16),
                    Text(
                      '${order.currencySymbol}${item.total}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total: ${order.currencySymbol}${order.total}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.brand,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (!stop.isDelivered)
            ElevatedButton.icon(
              onPressed: _loading ? null : _markDelivered,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(_loading ? 'Updating…' : 'Mark as Delivered'),
            ),
        ],
      ),
    );
  }
}

class _StopBadge extends StatelessWidget {
  const _StopBadge({required this.number, required this.color});
  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
