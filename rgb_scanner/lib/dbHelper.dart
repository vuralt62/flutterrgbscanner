import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'colorsmodel.dart';

class DbHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Color.db");

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    return await db.execute("CREATE TABLE Color(red TEXT, green TEXT, blue TEXT)");
  }

  Future<List<ColorModel>> getColors() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Color');
    List<ColorModel> colorModel = new List();
    for (var i = 0; i < list.length; i++) {
      colorModel.add(new ColorModel(list[i]["red"],list[i]["green"],list[i]["blue"]));
    }
    return colorModel;
  }

  void insertColor(ColorModel colorModel) async{
    var dbClient = await db;
    await dbClient.transaction((txn) async {
    return await txn.rawInsert(
          'INSERT INTO Color(red, green, blue ) VALUES(' +
              '\'' +
              colorModel.red +
              '\'' +
              ',' +
              '\'' +
              colorModel.green +
              '\'' +
              ',' +
              '\'' +
              colorModel.blue +
              '\'' +
              ')');
    });
  }

  Future<void> removeColor(String red, String green, String blue) async{
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM Color WHERE red = $red and green = $green and blue = $blue');
    
  }

  Future<void> removeAll() async{
    final dbClient = await db;
    dbClient.rawDelete("DELETE FROM Color");
  }
}

