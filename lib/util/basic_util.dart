import 'dart:io';

extension StringExtension on String {
  bool equalsIgnoreCase(String comparison) => comparison.toLowerCase() == toLowerCase();

  static const String allowedURLSpecialChars = r'[^–\p{L}\p{N}]';

  String dashes() => replaceAll(RegExp(allowedURLSpecialChars, unicode: true), " ")
      .trim()
      .replaceAll(RegExp(r'\s+'), "-");

  String underscores() => replaceAll(RegExp(allowedURLSpecialChars, unicode: true), " ")
      .trim()
      .replaceAll(RegExp(r'\s+'), "_");
}

extension StringNullableExtension on String? {
  bool isNotBlank() => this != null && this!.isNotEmpty;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
