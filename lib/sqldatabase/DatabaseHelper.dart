import 'dart:async';
import 'dart:io' as io;
import 'dart:io';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poems/model/PoemModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'favpoem';
  static final Id = 'id';
  static final p_id = 'p_id';
  static final poemName = 'poemname';
  static final poemText = 'poemtext';
  static final poemimage='poemimage';
  static final poemimagewithtext='poem_txtbg_img';
  static final String poem_author='poem_author';
 static final   String location='location';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
             $Id INTEGER PRIMARY KEY AUTOINCREMENT,
            $p_id INTEGER NOT NULL,
            $poemName TEXT NOT NULL,
            $poemText TEXT NOT NULL,
            $poemimage TEXT NOT NULL,
            $poemimagewithtext TEXT NOT NULL,
            $poem_author TEXT NOT NULL,
            $location TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$p_id = ?', whereArgs: [id]);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> getcount(id) async {
    Database db = await instance.database;
    int  count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table WHERE $p_id=$id"));
    return count;
  }
}


final dbHelper = DatabaseHelper.instance;



