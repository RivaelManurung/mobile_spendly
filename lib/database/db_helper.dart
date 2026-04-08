import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = "KeuanganKu.db";
  static const _databaseVersion = 4;

  static const tableAccounts = 'accounts';
  static const tableCategories = 'categories';
  static const tableTransactions = 'transactions';
  static const tableBudgets = 'budgets';
  static const tableGoals = 'goals';
  static const tableGoalContributions = 'goal_contributions';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $tableGoals (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              targetAmount REAL NOT NULL,
              currentAmount REAL NOT NULL,
              color TEXT NOT NULL,
              icon TEXT NOT NULL,
              deadline TEXT
            )
          ''');
        }
        if (oldVersion < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $tableGoalContributions (
              id TEXT PRIMARY KEY,
              goalId TEXT NOT NULL,
              amount REAL NOT NULL,
              date TEXT NOT NULL,
              note TEXT,
              FOREIGN KEY (goalId) REFERENCES $tableGoals (id) ON DELETE CASCADE
            )
          ''');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    // 1. Table Accounts
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableAccounts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        balance REAL NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // 2. Table Categories
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCategories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    // 3. Table Transactions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableTransactions (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        categoryId TEXT,
        accountId TEXT,
        toAccountId TEXT,
        notes TEXT,
        imagePath TEXT,
        isRecurring INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id),
        FOREIGN KEY (accountId) REFERENCES $tableAccounts (id)
      )
    ''');

    // 4. Table Budgets
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableBudgets (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        amount REAL NOT NULL,
        period TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES $tableCategories (id)
      )
    ''');

    // 5. Table Goals
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableGoals (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentAmount REAL NOT NULL,
        color TEXT NOT NULL,
        icon TEXT NOT NULL,
        deadline TEXT
      )
    ''');

    // 6. Table Goal Contributions
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableGoalContributions (
        id TEXT PRIMARY KEY,
        goalId TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (goalId) REFERENCES $tableGoals (id) ON DELETE CASCADE
      )
    ''');

    // Insert Default Categories
    await db.execute(
      "INSERT INTO $tableCategories (id, name, icon, color, type) VALUES ('cat_food', 'Food & Drink', '🍔', '0xFFF44336', 'Expense')",
    );
    await db.execute(
      "INSERT INTO $tableCategories (id, name, icon, color, type) VALUES ('cat_salary', 'Salary', '💼', '0xFF4CAF50', 'Income')",
    );

    // Insert Default Accounts
    await db.execute(
      "INSERT INTO $tableAccounts (id, name, icon, color, balance, type) VALUES ('acc_cash', 'Cash', 'account_balance_wallet', '0xFF009688', 0, 'Cash')",
    );
    await db.execute(
      "INSERT INTO $tableAccounts (id, name, icon, color, balance, type) VALUES ('acc_bank', 'Bank Account', 'account_balance', '0xFF3F51B5', 0, 'Debit')",
    );

    // Insert Dummy Transactions
    String dateNow = DateTime.now().toIso8601String();
    String dateYest = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
    String datePast = DateTime.now().subtract(const Duration(days: 3)).toIso8601String();

    await db.execute(
      "INSERT INTO $tableTransactions (id, title, amount, date, type, categoryId, accountId, isRecurring) VALUES ('dummy_1', 'Gaji Bulanan', 8500000, '$datePast', 'Income', 'cat_salary', 'acc_bank', 0)",
    );
    await db.execute(
      "INSERT INTO $tableTransactions (id, title, amount, date, type, categoryId, accountId, isRecurring) VALUES ('dummy_2', 'Warteg Bahari', 35000, '$dateYest', 'Expense', 'cat_food', 'acc_cash', 0)",
    );
    await db.execute(
      "INSERT INTO $tableTransactions (id, title, amount, date, type, categoryId, accountId, isRecurring) VALUES ('dummy_3', 'Kopi Kenangan', 15000, '$dateNow', 'Expense', 'cat_food', 'acc_cash', 0)",
    );
    await db.execute(
      "INSERT INTO $tableTransactions (id, title, amount, date, type, categoryId, accountId, isRecurring) VALUES ('dummy_4', 'Makan Malam', 46300, '$dateNow', 'Expense', 'cat_food', 'acc_bank', 0)",
    );
  }

  // Generic CRUD
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> row, String id) async {
    Database db = await database;
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
