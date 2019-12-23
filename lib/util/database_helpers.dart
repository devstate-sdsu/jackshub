import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



// database table and column names
final String savedEventsTable = 'saved_events';
final String docId = 'doc_id';



// Saved Events Datamodel
class SavedEvent {
  String documentId;

  SavedEvent();

    // convenience constructor to create a Word object
  SavedEvent.fromMap(Map<String, dynamic> map) {
    print(map[docId]);
    documentId = map[docId];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      docId: documentId
    };
    return map;
  }
}



List<SavedEvent> _toList(List<Map> maps) {
  List<SavedEvent> newList = new List<SavedEvent>();

  maps.forEach((map) => newList.add(SavedEvent.fromMap(map)));

  return newList;
}



// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "JacksHubDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $savedEventsTable (
            $docId VARCHAR(255) PRIMARY KEY
          )
          ''');
  }

  // Database helper methods:
  Future<int> insert(SavedEvent event) async {
    Database db = await database;
    int id = await db.insert(savedEventsTable, event.toMap());
    return id;
  }

  Future<Null> delete(String documentId) async {
    Database db = await database;
    await db.delete(
      savedEventsTable,
      where: '$docId = ?',
      whereArgs: [documentId]
    );
    return null;
  }

  Future<SavedEvent> querySavedEvent() async {
    Database db = await database;
    List<Map> maps = await db.query(
      savedEventsTable,
      columns: [docId]
    );
    if (maps.length > 0) {
      print(maps);
      return SavedEvent.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SavedEvent>> listSavedEvents() async {
    Database db = await database;
    List<Map> maps = await db.query(
      savedEventsTable,
      columns: [docId]
    );
    if (maps.length > 0) {
      return _toList(maps);
    }
    return [];
  }

  // TODO: queryAllWords()
  // TODO: delete(int id)
  // TODO: update(Word word)
}