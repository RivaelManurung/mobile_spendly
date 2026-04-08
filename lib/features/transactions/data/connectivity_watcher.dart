import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_service.dart';

class ConnectivityWatcher {
  final TransactionSyncService _sync;

  ConnectivityWatcher(this._sync) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _sync.syncPending(); // auto sync kalau koneksi kembali
      }
    });
  }
}
