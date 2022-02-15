
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:unikids_uz/model/db_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  final _databaseName = "myuser.db";
  final _databaseVersion = 1;
  static final tablePeddings = 'info';
  final columnId = 'id';
  final columnPhotoUrl = 'url';
  final columnRelation = 'relation';
  final columnChildId = 'childId';

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  late Database _database;
  DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async{
    if(_database != null){
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, _databaseName);

  // SQL code to create the database table
    var db = await openDatabase(path, version: _databaseVersion, onCreate: onCreate);
    return db;
  }

    void  onCreate (Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tablePeddings (
             $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
             $columnRelation TEXT,
            $columnChildId INTEGER,
            $columnPhotoUrl TEXT
          )
          ''');
     }

  Future insert(@required DbModel userInfo) async {
    final db = await database;
    var res = await db.insert(tablePeddings, userInfo.toJson());
    return res;
  }

  Future<List<DbModel>>  getAllUserInfo() async {
    var dbClient = await database;
    List<Map> list = await dbClient.rawQuery('select *from $tablePeddings');
    List<DbModel> user =  [];
    for(int i = 0; i < list.length; i++){
         var items = DbModel(
             childId: list[i][columnChildId],
             relation: list[i][columnRelation],
             photoUrl: list[i][columnPhotoUrl]
         );
         user.add(items);
    }
    return user;
  }

  Future<DbModel>  getChildIdUserInfo(int id) async {
    var dbClient = await database;
    List<Map> list = await dbClient.rawQuery('select *from $tablePeddings Where $columnChildId = $id');
    late DbModel user;
    user = DbModel(
          childId: list[0][columnChildId],
          relation: list[0][columnRelation],
          photoUrl: list[0][columnPhotoUrl]
    );
    print("getChildIdUserInfo method");
    return user;
  }

  Future<void> clearTable(String table) async {
    var db = await database;
     await db.rawQuery("DELETE FROM $table");
  }


  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }

}