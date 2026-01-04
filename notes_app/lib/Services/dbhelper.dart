import 'package:notes_app/Services/notesmodal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Dbhelper {
  Dbhelper._();
  static Dbhelper instance = Dbhelper._();

  Database? _db;
  static String TableName = 'NotesTable';
  static String IdColumn = 'id';
  static String TitleColumn = 'title';
  static String DescriptionColumn = 'description';

  Future<Database> getDB() async{
    return _db ??= await initDB();
  }

  Future<Database> initDB() async{
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path,'notestable.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
             CREATE TABLE $TableName(
             $IdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
             $TitleColumn TEXT,
             $DescriptionColumn TEXT )
           ''');
      },);
  }

  Future<int> insertNote(NotesModel model) async{
    final db = await getDB();
    return db.insert(TableName, model.toJson());
  }

  Future<int> deleteNote(NotesModel model) async{
    final db = await getDB();
    return db.delete(TableName,where: 'id = ?',whereArgs: [model.id]);
  }

  Future<int> updateNote(NotesModel model) async{
    final db = await getDB();
    return db.update(TableName, model.toJson(),where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<NotesModel>> GetNotes() async{
    final db = await getDB();
    List<Map<String,dynamic>> data = await db.query(TableName);
    return data.map((c) => NotesModel.fromJson(c)).toList();
  }
}