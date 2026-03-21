import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/app_config.dart';
import '../providers/config_provider.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlCtrl = TextEditingController();
  final _keyCtrl = TextEditingController();
  final _secretCtrl = TextEditingController();
  final _driversCtrl = TextEditingController(text: '3');
  final _kmCtrl = TextEditingController(text: '50');

  bool _secretObscured = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(configProvider).value;
    if (config != null) {
      _urlCtrl.text = config.wooBaseUrl;
      _keyCtrl.text = config.consumerKey;
      _secretCtrl.text = config.consumerSecret;
      _driversCtrl.text = config.driverCount.toString();
      _kmCtrl.text = config.kmCapPerDriver.toString();
    }
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    _secretCtrl.dispose();
    _driversCtrl.dispose();
    _kmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final config = AppConfig(
      wooBaseUrl: _urlCtrl.text.trim().replaceAll(RegExp(r'/$'), ''),
      consumerKey: _keyCtrl.text.trim(),
      consumerSecret: _secretCtrl.text.trim(),
      driverCount: int.parse(_driversCtrl.text.trim()),
      kmCapPerDriver: double.parse(_kmCtrl.text.trim()),
    );

    await ref.read(configProvider.notifier).save(config);
    setState(() => _saving = false);

    if (mounted) context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader('WooCommerce API'),
              const SizedBox(height: 12),
              _buildField(
                controller: _urlCtrl,
                label: 'Store URL',
                hint: 'https://yourstore.com',
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Required' : null,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _keyCtrl,
                label: 'Consumer Key',
                hint: 'ck_xxxxxxxxxxxxxxxx',
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _secretCtrl,
                obscureText: _secretObscured,
                decoration: InputDecoration(
                  labelText: 'Consumer Secret',
                  hintText: 'cs_xxxxxxxxxxxxxxxx',
                  suffixIcon: IconButton(
                    icon: Icon(_secretObscured
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _secretObscured = !_secretObscured),
                  ),
                ),
                validator: (v) =>
                    (v?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 28),
              _SectionHeader('Driver Settings'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      controller: _driversCtrl,
                      label: 'Number of Drivers',
                      hint: '3',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n < 1 || n > 20) {
                          return '1 – 20';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(
                      controller: _kmCtrl,
                      label: 'KM Cap / Driver',
                      hint: '50',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final n = double.tryParse(v ?? '');
                        if (n == null || n <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.brand,
          ),
    );
  }
}
