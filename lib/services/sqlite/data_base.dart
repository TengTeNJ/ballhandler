import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_table.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${kDataBaseTableName}(
        id INTEGER PRIMARY KEY,
        time TEXT,
        score TEXT,
        avgPace TEXT,
        rank TEXT,
        endTime TEXT,
        videoPath TEXT
      )
    ''');
  }

  Future<int> insertData(String table, GameOverModel data) async {
    Database db = await database;
    return await db.insert(table, data.toJson());
  }

  Future<int> updateData(
      String table, Map<String, dynamic> data, int id) async {
    Database db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String table, int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<GameOverModel>> getData(String table) async {
    Database db = await database;
    final _datas =  await db.query(table);

    List<GameOverModel> array = [];
    _datas.forEach((element) {
      GameOverModel model = GameOverModel.fromJson(element);
      array.add(model);
    });
    return array;
  }
}

