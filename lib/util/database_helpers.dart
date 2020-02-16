import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

const String savedEventsIdsTable = 'saved_events_ids';
const String savedEventsInfoTable = 'saved_events_info';
const String docId = 'doc_id';
const String _document_id = 'document_id';
const String _name = 'name';
const String _description = 'description';
const String _start_time = 'start_time';
const String _end_time = 'end_time';
const String _image = 'image';
const String _tags = 'tags';
const String _start_time_uncertain = 'start_time_uncertain';
const String _end_time_uncertain = 'end_time_uncertain';
const String _start_date_uncertain = 'start_date_uncertain';
const String _end_date_uncertain = 'end_date_uncertain';
const String _time_updated = 'time_updated';
const String _tiny_location = 'tiny_location';
const String _big_location = 'big_location';
const String _updates = 'updates';

class SavedEventId {
  String documentId;

  SavedEventId();

  SavedEventId.fromMap(Map<String, dynamic> map) {
    documentId = map[docId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      docId: documentId
    };
    return map;
  }
}

class EventInfo {
  String documentId;
  String name;
  String description;
  Timestamp startTime;
  Timestamp endTime;
  String image;
  List<dynamic> tags;
  bool startTimeUncertain;
  bool endTimeUncertain;
  bool startDateUncertain;
  bool endDateUncertain;
  Timestamp timeUpdated;
  String tinyLocation;
  String bigLocation;
  String updates;

  EventInfo();

  EventInfo.fromFirebase(DocumentSnapshot doc) {
    documentId = doc.documentID;
    name = doc[_name];
    description = doc[_description];
    startTime = doc[_start_time];
    endTime = doc[_end_time];
    image = doc[_image];
    tags = doc[_tags];
    startTimeUncertain = doc[_start_time_uncertain] == null ? true : doc[_start_time_uncertain];
    endTimeUncertain = doc[_end_time_uncertain] == null ? true : doc[_end_time_uncertain];
    startTimeUncertain = doc[_start_date_uncertain] == null ? true : doc[_start_date_uncertain];
    endTimeUncertain = doc[_end_date_uncertain] == null ? true : doc[_end_date_uncertain];
    timeUpdated = doc[_time_updated];
    tinyLocation = doc[_tiny_location];
    bigLocation = doc[_big_location];
    updates = doc[_updates];
  } 

  EventInfo.fromMap(Map<String, dynamic> map) {
    documentId = map[_document_id];
    name = map[_name];
    description = map[_description];
    startTime = Timestamp.fromMillisecondsSinceEpoch(map[_start_time]);
    endTime = Timestamp.fromMillisecondsSinceEpoch(map[_end_time]);
    image = map[_image];
    tags = jsonDecode(map[_tags]);
    startTimeUncertain = map[_start_time_uncertain] == 1 ? true : false;
    endTimeUncertain = map[_end_time_uncertain] == 1 ? true : false;
    startDateUncertain = map[_start_date_uncertain] == 1 ? true : false;
    endDateUncertain = map[_end_date_uncertain] == 1 ? true : false;
    timeUpdated = Timestamp.fromMillisecondsSinceEpoch(map[_time_updated]);
    tinyLocation = map[_tiny_location];
    bigLocation = map[_big_location];
    updates = map[_updates];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
    _document_id: documentId,
    _name: name,
    _description: description,
    _start_time: startTime.millisecondsSinceEpoch,
    _end_time: endTime.millisecondsSinceEpoch,
    _image: image,
    _tags: jsonEncode(tags),
    _start_time_uncertain: startTimeUncertain,
    _end_time_uncertain: endTimeUncertain,
    _start_date_uncertain: startDateUncertain,
    _end_date_uncertain: endDateUncertain,
    _time_updated: timeUpdated.millisecondsSinceEpoch,
    _tiny_location: tinyLocation,
    _big_location: bigLocation,
    _updates: updates,
    };
    return map;
  }
}

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "JacksHubDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

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
          CREATE TABLE $savedEventsIdsTable (
            $docId VARCHAR(255) PRIMARY KEY
          )
          ''');

    await db.execute('''
          CREATE TABLE $savedEventsInfoTable (
            $_document_id VARCHAR(255) PRIMARY KEY,
            $_name VARCHAR(512),
            $_description VARCHAR(2000),
            $_start_time INT8,
            $_end_time INT8,
            $_image VARCHAR(2048),
            $_tags VARCHAR(2048),
            $_start_time_uncertain TINYINT,
            $_end_time_uncertain TINYINT,
            $_start_date_uncertain TINYINT,
            $_end_date_uncertain TINYINT,
            $_time_updated INT8,
            $_tiny_location VARCHAR(255),
            $_big_location VARCHAR(255),
            $_updates VARCHAR(255)
          )
          ''');          
  }

  // Database helper methods:

  // SAVED EVENT ID HELPER METHODS
  Future<int> insertSavedEventId(SavedEventId event) async {
    Database db = await database;
    int id = await db.insert(savedEventsIdsTable, event.toMap());
    return id;
  }

  Future<Null> deleteSavedEventId(String documentId) async {
    Database db = await database;
    await db.delete(
      savedEventsIdsTable,
      where: '$docId = ?',
      whereArgs: [documentId]
    );
    return null;
  }

  Future<List<SavedEventId>> listSavedEventsIds() async {
    Database db = await database;
    List<Map> maps = await db.query(
      savedEventsIdsTable,
      columns: [docId]
    );
    if (maps.length > 0) {
      return _toList(maps);
    }
    return [];
  }
  List<SavedEventId> _toList(List<Map> maps) {
    List<SavedEventId> newList = new List<SavedEventId>();

    maps.forEach((map) => newList.add(SavedEventId.fromMap(map)));

    return newList;
  }

    // SAVED EVENT INFO HELPER METHODS
  Future<int> insertSavedEventInfo(EventInfo event) async {
    Database db = await database;
    int id = await db.insert(savedEventsInfoTable, event.toMap());
    return id;
  }

  Future<Null> deleteSavedEventInfo(String documentId) async {
    Database db = await database;
    await db.delete(
      savedEventsInfoTable,
      where: '$_document_id = ?',
      whereArgs: [documentId]
    );
    return null;
  }

  Future<List<EventInfo>> listSavedEventsInfo() async {
    print("ARE WE LISTING? ");
    Database db = await database;
    print("GOT OUR DB? ");
    List<Map> maps = await db.query(
      savedEventsInfoTable,
      columns: [  
        _document_id,
        _name,
        _description,
        _start_time,
        _end_time,
        _image,
        _tags,
        _start_time_uncertain,
        _end_time_uncertain,
        _start_date_uncertain,
        _end_date_uncertain,
        _time_updated,
        _tiny_location,
        _big_location,
        _updates,
      ]
    );
    if (maps.length > 0) {
      print("MAPS HAS LENGHT: ");
      print(maps);
      return _infoMapToList(maps);
    }
    print("MAP NO LENGTH");
    print(maps);
    return [];
  }
  List<EventInfo> _infoMapToList(List<Map> maps) {
    List<EventInfo> newList = new List<EventInfo>();

    maps.forEach((map) => newList.add(EventInfo.fromMap(map)));

    return newList;
  }
}