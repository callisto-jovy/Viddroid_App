class StringUtil {
  static const String allowedURLSpecialChars = r'[^\$–_.+!*‘(),\w]';

  static String dashes(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars), " ").replaceAll(RegExp(r'\W+'), "-");

  static String underscores(final String string) =>
      string.replaceAll(RegExp(allowedURLSpecialChars), " ").replaceAll(RegExp(r'\W+'), "_");
}
