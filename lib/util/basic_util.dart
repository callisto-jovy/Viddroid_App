import 'dart:io';

class StringUtil {
  static const String allowedURLSpecialChars = r'[^\$–_.+!*‘(),\p{L}\p{N}]';

  static String dashes(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars, unicode: true), " ").replaceAll(RegExp(r'\s+'), "-");

  static String underscores(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars, unicode: true), " ").replaceAll(RegExp(r'\s+'), "_");
}

extension StringExtension on String {
  bool equalsIgnoreCase(String comparison) => comparison.toLowerCase() == toLowerCase();
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
