class Config {
  final String siteId;

  final String language;

  const Config({required this.siteId, String? language})
    : language = language ?? 'en';
}
