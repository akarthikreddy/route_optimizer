class WooConfig {
  const WooConfig({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
    this.googleApiKey = '',
    this.googleProjectId = '',
  });

  final String baseUrl;
  final String consumerKey;
  final String consumerSecret;

  /// Google Route Optimization API key.
  /// Leave empty to use the built-in VRP solver.
  final String googleApiKey;

  /// Google Cloud project ID (required when googleApiKey is set).
  final String googleProjectId;

  // Uses service account OAuth2 (assets/service_account.json).
  bool get useGoogleOptimizer => googleProjectId.isNotEmpty;

  factory WooConfig.fromJson(Map<String, dynamic> json) => WooConfig(
        baseUrl: (json['base_url'] as String).replaceAll(RegExp(r'/$'), ''),
        consumerKey: json['consumer_key'] as String,
        consumerSecret: json['consumer_secret'] as String,
        googleApiKey: json['google_api_key'] as String? ?? '',
        googleProjectId: json['google_project_id'] as String? ?? '',
      );
}
