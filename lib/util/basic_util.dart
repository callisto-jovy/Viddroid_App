import 'dart:io';

class StringUtil {
  static const String allowedURLSpecialChars = r'[^\$–_.+!*‘(),\w]';

  static String dashes(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars), " ").replaceAll(RegExp(r'\W+'), "-");

  static String underscores(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars), " ").replaceAll(RegExp(r'\W+'), "_");
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
