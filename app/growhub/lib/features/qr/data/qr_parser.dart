class QRParser {
  static const String _expression = "&ghcode";

  static String? parseQRCode(String? code) {
    if (code == null) {
      return null;
    }
    // Check if the string starts and ends with the expression
    if (!code.startsWith(_expression) || !code.endsWith(_expression)) {
      return null;
    }

    // Trim the expression from both ends
    String trimmed =
        code.substring(_expression.length, code.length - _expression.length);

    // Try parsing the trimmed string as an integer
    return trimmed;
  }
}
