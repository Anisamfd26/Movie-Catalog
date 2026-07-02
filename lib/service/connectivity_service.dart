import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Listen to connectivity changes
  /// Returns a stream that emits true when connected, false when disconnected
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    });
  }

  /// Get current connectivity status
  /// Returns a stream of connectivity results
  Stream<List<ConnectivityResult>> get connectivityStatus {
    return _connectivity.onConnectivityChanged;
  }
}
