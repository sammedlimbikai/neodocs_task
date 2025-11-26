class EnvironmentConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://nd-assignment.azurewebsites.net',
  );

  static const String authToken = String.fromEnvironment(
    'AUTH_TOKEN',
    defaultValue:
        'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95',
  );
}
