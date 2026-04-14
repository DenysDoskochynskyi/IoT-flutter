import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityService {
  Future<bool> hasInternet();
  Stream<bool> watchInternet();
}

final class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> hasInternet() async {
    final res = await _connectivity.checkConnectivity();
    return !res.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> watchInternet() {
    return _connectivity.onConnectivityChanged.map(
      (res) => !res.contains(ConnectivityResult.none),
    );
  }
}
