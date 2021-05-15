class HTTPExceptionClass implements Exception {
  
  final message;
  HTTPExceptionClass(this.message);

  @override
  String toString() {
    return message;
  }
}
