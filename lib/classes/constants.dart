/// Environment variables and shared app constants.
abstract class Constants {
  static const String discogsAPIKey = String.fromEnvironment(
    'DISCOGS_API_KEY',
    defaultValue: '',
  );
}
