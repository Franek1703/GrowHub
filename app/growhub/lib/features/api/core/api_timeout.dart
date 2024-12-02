class ApiTimeout {
  static Duration timeout = const Duration(seconds: 10);
  static Exception timeoutException = Exception("Timeout exception");
}
