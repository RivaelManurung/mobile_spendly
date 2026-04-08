import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('DbCategory')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();
  TextColumn get type => text()(); 
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbTransaction')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbBudget')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  RealColumn get amount => real()();
  TextColumn get period => text()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DbGoal')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Categories, Transactions, Budgets, Goals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Sync Helpers
  Future<List<DbTransaction>> getUnsyncedTransactions() =>
      (select(transactions)..where((t) => t.syncedAt.isNull())).get();

  Future markTransactionSynced(String id, DateTime time) =>
      (update(transactions)..where((t) => t.id.equals(id)))
          .write(TransactionsCompanion(syncedAt: Value(time)));
          
  Future upsertTransaction(TransactionsCompanion t) =>
      into(transactions).insertOnConflictUpdate(t);

  Future upsertCategory(CategoriesCompanion c) =>
      into(categories).insertOnConflictUpdate(c);
      
  // CRUD Helpers for AppState
  Future<List<DbTransaction>> getAllDbTransactions() => select(transactions).get();
  Future insertDbTransaction(TransactionsCompanion t) => into(transactions).insert(t);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'spendly_v2.sqlite'));
    return NativeDatabase(file);
  });
}
