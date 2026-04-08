import 'local/transaction_dao.dart';
import 'remote/transaction_api_client.dart';

class TransactionSyncService {
  final SpendlyDatabase _db;
  final TransactionApiClient _api;

  TransactionSyncService(this._db, this._api);

  Future<void> syncPending() async {
    final unsynced = await _db.getUnsynced();
    if (unsynced.isEmpty) return;

    for (final tx in unsynced) {
      try {
        // Kirim ke Go backend
        await _api.createTransaction(tx.toRequest());
        // Kalau berhasil, tandai synced
        await _db.markSynced(tx.id, DateTime.now());
      } catch (e) {
        // Gagal (offline) → biarkan, coba lagi nanti
        print('Sync failed for tx ${tx.id}: $e');
        continue;
      }
    }
  }
}
