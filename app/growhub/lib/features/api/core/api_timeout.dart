class ApiTimeout {
  static Duration timeout = const Duration(seconds: 15);
  static Exception timeoutException = Exception("Timeout exception");
}
