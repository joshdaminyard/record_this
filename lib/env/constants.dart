/// Environment variables and shared app constants.
abstract class Constants {
  static const String discogsKey = String.fromEnvironment(
    'DISCOGS_KEY',
    defaultValue: '',
  );
}
