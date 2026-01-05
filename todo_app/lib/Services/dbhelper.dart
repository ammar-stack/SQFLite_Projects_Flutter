import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/Services/todomodel.dart';


class Dbhelper {
  Dbhelper._();
  static Dbhelper instance = Dbhelper._();

  Database? _db;

  //table fields
  static String TableName = 'todo_table';
  static String idColumn = 'id';
  static String todoColumn = 'todo';
  static String isDoneColumn = 'isDone';

  Future<Database> getDB() async{
    return _db ??= await initDB();
  }

  Future<Database> initDB() async{
    final dir =await getApplicationDocumentsDirectory();
    final pathh = join(dir.path,'todo.db');
    return await openDatabase(
      pathh,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
           CREATE TABLE $TableName(
           $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
           $todoColumn TEXT,
           $isDoneColumn INTEGER)
         ''');
      },
    );
  }


  //get all todos
  Future<List<ToDoModel>> getToDos() async{
    final db =await getDB();
    List<Map<String,dynamic>> data = await db.query(TableName);
    return data.map((c) => ToDoModel.fromJson(c)).toList();
  }

  //insert To Do
  Future<int> insertToDos(ToDoModel model) async{
    final db = await getDB();
    return db.insert(TableName, model.toJson());
  }

  //delete To Do
  Future<int> deleteToDos(ToDoModel model) async{
    final db = await getDB();
    return db.delete(TableName,where: 'id=?',whereArgs: [model.id]);
  }


  //update To Do
  Future<int> updateToDos(ToDoModel model) async{
    final db = await getDB();
    return db.update(TableName, model.toJson(),where: 'id=?',whereArgs: [model.id]);

  }
}