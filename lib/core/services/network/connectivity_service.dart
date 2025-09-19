import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  const ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? const Connectivity();

  final Connectivity _connectivity;

  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
