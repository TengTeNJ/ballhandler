import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/models/global/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../utils/global.dart';

class VideoPathModel {
  String id = '';
  String videoPath = '';

  VideoPathModel({required this.id, required this.videoPath});
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;
  Database? _videoDatabase;
  Database? _subDatabase;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> get videoDatabase async {
    if (_videoDatabase != null) {
      return _videoDatabase!;
    }
    _videoDatabase = await initVideoDatabase();
    return _videoDatabase!;
  }

  /*游戏数据表*/
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
        videoPath TEXT,
        sceneId TEXT,
         modeId TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE ${kDataBaseTVideoableName}(
        id INTEGER PRIMARY KEY,
        videoPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ${kDataBaseSubscripeName}(
        id INTEGER PRIMARY KEY,
        productId TEXT,
        title TEXT,
        description TEXT,
        price TEXT,
        rawPrice REAL,
        videoPath TEXT,
        currencyCode TEXT,
         currencySymbol TEXT
      )
    ''');
  }

  /*游戏视频*/
  Future<Database> initVideoDatabase() async {
    String path = join(await getDatabasesPath(), 'my_table.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Future<void> _onCreateVideo(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE ${kDataBaseTVideoableName}(
  //       id INTEGER PRIMARY KEY,
  //       videoPath TEXT
  //     )
  //   ''');
  // }

  /*插入游戏数据*/
  Future<int> insertData(String table, GameOverModel data) async {
    Database db = await database;
    print('插入游戏数据=${data.toJson}');
    return await db.insert(table, data.toJson());
  }

  /*插入游戏视频路径数据*/
  Future<int> insertVideoData(String table, String data) async {
    Database db = await videoDatabase;
    return await db.insert(table, {"videoPath": data});
  }

  /*插入订阅数据*/
  Future<int> insertSubData(ProductDetails data) async {
    Database db = await database;
    Map<String, dynamic> _map = {
      'productId': data.id,
      'title': data.title,
      'description': data.description,
      'price': data.price,
      'rawPrice': data.rawPrice,
      'currencyCode': data.currencyCode,
      'currencySymbol': data.currencySymbol,
    };
    final _result = await db.insert(kDataBaseSubscripeName, _map);
    print('插入订阅数据结果=${_result}');
    return _result;
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

/*删除某条视频路径数据*/
  Future<int> deletevVideoPathData(String table, int id) async {
    Database db = await videoDatabase;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /*删除某条订阅路径数据*/
  Future<int> deletevSubPathData(String productId) async {
    Database db = await database;
    final _result = await db.delete(kDataBaseSubscripeName,
        where: 'productId = ?', whereArgs: [productId]);
    print('删除订阅数据结果=${_result}');
    return _result;
  }

  Future<List<GameOverModel>> getData(String table) async {
    Database db = await database;
    final _datas = await db.query(table);
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    List<GameOverModel> array = [];
    _datas.forEach((element) {
      GameOverModel model = GameOverModel.fromJson(element);
      if (model.sceneId == (gameUtil.gameScene.index + 1).toString()) {
        array.add(model);
      }
    });
    return array;
  }

  /*获取本地保存的订阅数据*/
  Future<List<ProductDetails>> getSubData() async {
    Database db = await database;
    final _datas = await db.query(kDataBaseSubscripeName);
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    List<ProductDetails> array = [];
    _datas.forEach((element) {
      ProductDetails detail = ProductDetails(
        id: element['productId'].toString() ?? '',
        title: element['title'].toString() ?? '',
        description: element['description'].toString() ?? '',
        price: element['price'].toString() ?? '',
        rawPrice: double.parse(element['rawPrice'].toString()) ?? 0,
        currencyCode: element['currencyCode'].toString() ?? '',
      );
      array.add(detail);
    });
    return array;
  }

/*获取本地的视频列表*/
  Future<List<VideoPathModel>> getVideoListData(String table) async {
    Database db = await videoDatabase;
    final _datas = await db.query(table);

    List<VideoPathModel> array = [];
    _datas.forEach((element) {
      String videoPath = element['videoPath'].toString();
      String id = element['id'].toString();
      VideoPathModel model = VideoPathModel(id: id, videoPath: videoPath);
      array.add(model);
    });
    return array;
  }

  /*获取本地的游客数据*/
  Future<void> getLocalGuestData(BuildContext context) async {
    List<GameOverModel> _data =
        await DatabaseHelper().getData(kDataBaseTableName);
    if (_data.length == 0) {
      UserProvider.of(context).avgPace = '-';
      UserProvider.of(context).totalScore = '-';
      UserProvider.of(context).totalTime = '-';
      UserProvider.of(context).totalTimes = '-';
    } else {
      double _bestSpeed = 9999;
      double _totalScore = 0;
      double _totalTime = 0;
      _data.forEach((element) {
        // 速度越小 成绩越好
        _bestSpeed = double.parse(element.avgPace) < _bestSpeed
            ? double.parse(element.avgPace)
            : _bestSpeed;
        _totalScore = _totalScore + double.parse(element.score);
        _totalTime = _totalTime + double.parse(element.time);
      });
      UserProvider.of(context).totalTimes = _data.length.toString();
      UserProvider.of(context).avgPace = _bestSpeed.toString();
      UserProvider.of(context).totalScore = _totalScore.toString();
      UserProvider.of(context).totalTime = (_totalTime / 60).toStringAsFixed(1);
    }
  }
}
