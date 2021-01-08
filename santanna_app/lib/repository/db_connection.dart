import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {

  initDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_santanna');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE product("
            "id INTEGER PRIMARY KEY, "
            "name INTEGER,"
            "image TEXT,"
            "ingredients TEXT,"
            "allergens TEXT,"
            "changes TEXT,"
            "price INTEGER)");
  }
}
