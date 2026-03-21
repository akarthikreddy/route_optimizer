class WooConfig {
  const WooConfig({
    required this.baseUrl,
    required this.consumerKey,
    required this.consumerSecret,
  });

  final String baseUrl;
  final String consumerKey;
  final String consumerSecret;

  factory WooConfig.fromJson(Map<String, dynamic> json) => WooConfig(
        baseUrl: (json['base_url'] as String).replaceAll(RegExp(r'/$'), ''),
        consumerKey: json['consumer_key'] as String,
        consumerSecret: json['consumer_secret'] as String,
      );
}
