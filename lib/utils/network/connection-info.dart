import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionInfoImpl {
  final InternetConnectionChecker connectionChecker;

  ConnectionInfoImpl({required this.connectionChecker});
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}
