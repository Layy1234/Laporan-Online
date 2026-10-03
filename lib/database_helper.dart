import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vape_stores.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 5, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE stores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  storeName TEXT NOT NULL,
  ownerName TEXT NOT NULL,
  picName TEXT NOT NULL,
  address TEXT NOT NULL,
  volx TEXT,
  takis TEXT,
  tribe TEXT,
  pod_volx TEXT,
  pod_takis TEXT,
  pod_tribe TEXT,
  ct TEXT,
  pod TEXT,
  inside TEXT,
  imagePath TEXT,
  imagePaths TEXT,
  createdAt TEXT
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE stores ADD COLUMN inside TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE stores ADD COLUMN imagePaths TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE stores ADD COLUMN pod TEXT');
      await db.execute('ALTER TABLE stores ADD COLUMN createdAt TEXT');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE stores ADD COLUMN pod_volx TEXT');
      await db.execute('ALTER TABLE stores ADD COLUMN pod_takis TEXT');
      await db.execute('ALTER TABLE stores ADD COLUMN pod_tribe TEXT');
    }
  }

  Future<int> insertStore(Map<String, dynamic> row) async {
    final db = await instance.database;
    if (!row.containsKey('createdAt') || row['createdAt'] == null) {
      row['createdAt'] = DateTime.now().toIso8601String();
    }
    return await db.insert('stores', row);
  }

  Future<int> updateStore(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update(
      'stores',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllStores() async {
    final db = await instance.database;
    return await db.query('stores', orderBy: 'id DESC');
  }

  Future<int> deleteStore(int id) async {
    final db = await instance.database;
    return await db.delete('stores', where: 'id = ?', whereArgs: [id]);
  }
}
