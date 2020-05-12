import 'dart:io';
import 'package:path/path.dart';
// should install these
// refer description for more
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// the database helper class
class Databasehelper {
  // database name
  static final _databasename = "todo.db";
  static final _databaseversion = 1;

  // the table name
  static final table = "my_table";

  // column names
  static final columnID = 'id';
  // static final columnName = "todo"; //NOT USE THIS FOR NOW
  static final evening = "eveningTasks";
  static final morning = "morningTasks";
  static final night = 'nightTasks';

  // a database
  static Database _database;

  // privateconstructor
  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

  // asking for a database
  Future<Database> get databse async {
    if (_database != null) return _database;

    // create a database if one doesn't exist
    _database = await _initDatabase();
    return _database;
  }

  // function to return a database
  _initDatabase() async {
    Directory documentdirecoty = await getApplicationDocumentsDirectory();
    String path = join(documentdirecoty.path, _databasename);
    return await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
  }

  // create a database since it doesn't exist

  Future _onCreate(Database db, int version) async {
    // sql code
    await db.execute('''
      CREATE TABLE $table (
        $columnID INTEGER PRIMARY KEY,
        $evening TEXT,
        $morning TEXT,
        $night TEXT
      )
      ''');
  }

  // functions to insert data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.databse;
    return await db.insert(table, row);
  }

  // function to query all the rows
  Future<List<Map<String, dynamic>>> queryevening() async {
    Database db = await instance.databse;
    List<String> columnsToSelect = [
      Databasehelper.columnID,
      Databasehelper.evening,
    ];

    return await db.query(table, columns: columnsToSelect);
  }

  Future<List<Map<String, dynamic>>> querymorning() async {
    Database db = await instance.databse;
    List<String> columnsToSelect = [
      Databasehelper.columnID,
      Databasehelper.morning,
    ];

    return await db.query(table, columns: columnsToSelect);
  }

  Future<List<Map<String, dynamic>>> querynight() async {
    Database db = await instance.databse;
    List<String> columnsToSelect = [
      Databasehelper.columnID,
      Databasehelper.night,
    ];

    return await db.query(table, columns: columnsToSelect);
  }

  // function to delete some data
  Future<int> deletedata(int id) async {
    Database db = await instance.databse;
    var res = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return res;
  }

  // fucntion to query specific rows
  // Future<List<Map<String, dynamic>>> queryspecific(i) async {
  //   Database db = await instance.databse;

  //   if (i == 1) {
  //     List<String> columnsToSelect = [
  //       Databasehelper.columnID,
  //       Databasehelper.morning,
  //     ];
  //     var res = await db.query(table, columns: columnsToSelect);
  //   } else if (i == 2) {
  //     List<String> columnsToSelect = [
  //       Databasehelper.columnID,
  //       Databasehelper.evening,
  //     ];
  //     var res = await db.query(table, columns: columnsToSelect);
  //   } else {
  //     List<String> columnsToSelect = [
  //       Databasehelper.columnID,
  //       Databasehelper.evening,
  //     ];
  //     var res = await db.query(table, columns: columnsToSelect);
  //     // return res;
  //   }
  //   // var res = await db.query(table, where: "age < ?", whereArgs: [age]);
  //   // var res = await db.rawQuery('SELECT * FROM my_table WHERE age >?', [age]);
  //   return await res;
  // }
}
