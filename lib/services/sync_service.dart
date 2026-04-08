import 'package:dio/dio.dart';
import 'package:mobile_spendly/database/app_database.dart' as db;
import 'package:drift/drift.dart';

class SyncService {
  final db.AppDatabase database;
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://backendspendly-production-70c0.up.railway.app/api/v1', 
    connectTimeout: const Duration(seconds: 10),
  ));

  SyncService(this.database);

  Future<void> syncAll() async {
    try {
      print('🔄 [Sync] Memulai sinkronisasi total...');
      // 1. Sinkronkan Kategori DULU (Sangat Penting untuk Foreign Key)
      await syncCategories();
      
      // 2. Baru sinkronkan Transaksi
      await syncTransactions();
      
      print('✨ [Sync] Sinkronisasi total selesai.');
    } catch (e) {
      print('❌ [Sync] Global Error: $e');
    }
  }

  Future<void> syncCategories() async {
    // Kita ambil semua kategori lokal
    final cats = await database.select(database.categories).get();
    print('📂 [Sync] Sinkronisasi ${cats.length} kategori...');

    for (var cat in cats) {
      try {
        await dio.post('/categories/', data: {
          'id': cat.id,
          'label': cat.label,
          'icon': cat.icon,
          'color': cat.color,
          'type': cat.type,
        });
      } catch (e) {
        print('⚠️ [Sync] Gagal kirim kategori ${cat.label}: $e');
      }
    }
  }

  Future<void> syncTransactions() async {
    final unsynced = await database.getUnsyncedTransactions();
    print('💸 [Sync] Sinkronisasi ${unsynced.length} transaksi...');
    
    int successCount = 0;
    for (var tx in unsynced) {
      try {
        final response = await dio.post('/transactions/', data: {
          'id': tx.id,
          'title': tx.title,
          'amount': tx.amount,
          'date': tx.date.toUtc().toIso8601String(),
          'type': tx.type,
          'category_id': tx.categoryId ?? 'default', 
          'note': tx.notes ?? '', 
          'is_recurring': false,
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          await database.markTransactionSynced(tx.id, DateTime.now());
          successCount++;
          print('✅ [Sync] Berhasil: "${tx.title}"');
        }
      } catch (e) {
        if (e is DioException && e.response != null) {
          print('❌ [Sync] Server Error (${tx.title}): ${e.response?.data}');
        } else {
          print('❌ [Sync] Gagal: "${tx.title}" -> Error: $e');
        }
      }
    }
    print('🏁 [Sync] Selesai. $successCount transaksi ter-upload.');
  }
}
