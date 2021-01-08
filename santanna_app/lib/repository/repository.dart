import 'package:santanna_app/repository/db_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _connection;

  Repository(){
    _connection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;
    _database = await _connection.initDatabase();

    return _database;
  }

  getAllLocal(table) async {
    var conn = await database;
    return await conn.query(table);
  }

  saveLocal(table, data) async {
    var conn = await database;
    return await conn.insert(table, data);
  }

  updateLocal(table, columnName, data) async {
    var conn = await database;
    return await conn.update(table, data, where: '$columnName =?', whereArgs: [data['productId']]);
  }

  getLocalByCondition(table, columnName, conditionalValue) async {
    var conn = await database;
    return await conn.rawQuery('SELECT * FROM $table WHERE $columnName=?', ['$conditionalValue']);
  }

}