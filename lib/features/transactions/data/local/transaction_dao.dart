import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../remote/transaction_models.dart';

part 'transaction_dao.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get categoryId => text()();
  TextColumn get type => text()(); // income, expense, goal
  TextColumn get note => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Transactions])
class SpendlyDatabase extends _$SpendlyDatabase {
  SpendlyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Simpan transaksi baru (dari user input)
  Future<int> insertTransaction(TransactionsCompanion t) =>
      into(transactions).insert(t);

  // Ambil semua yang belum ter-sync ke BE
  Future<List<Transaction>> getUnsynced() =>
      (select(transactions)..where((t) => t.syncedAt.isNull())).get();

  // Tandai sudah ter-sync
  Future<void> markSynced(String id, DateTime syncedAt) =>
      (update(transactions)..where((t) => t.id.equals(id)))
          .write(TransactionsCompanion(syncedAt: Value(syncedAt)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'spendly.sqlite'));
    return NativeDatabase(file);
  });
}

extension TransactionMapper on Transaction {
  CreateTransactionRequest toRequest() {
    return CreateTransactionRequest(
      id: id,
      title: title,
      amount: amount,
      categoryId: categoryId,
      type: type,
      note: note ?? '',
      isRecurring: isRecurring,
      date: date,
    );
  }
}
