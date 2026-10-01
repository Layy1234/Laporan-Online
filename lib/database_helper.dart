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
      version: 3, 
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
  ct TEXT,
  inside TEXT,
  imagePath TEXT,
  imagePaths TEXT
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
  }

  Future<int> insertStore(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('stores', row);
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
