import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'package:note2/model/model_note.dart';

String table = 'Note';

class DataConnection {
  Future<Database> initializeData() async {
    //Directory tempDir = await getTemporaryDirectory();
    //String tempPath = tempDir.path;
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    //String appDocPath = appDocDir.path;
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mynote.db'),
      version: 1,
      onCreate: ((db, version) async {
        await db.execute(
            'CREATE TABLE $table(id INTEGER PRIMARY KEY, head TEXT, body TEXT)');
      }),
    );
  }

  Future<void> insertData(Note note) async {
    final db = await initializeData();
    await db.insert(table, note.fromJson());
    print('object was insert to database');
  }

  Future<List<Note>> getNoteData() async {
    final db = await initializeData();
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Note.toJson(e)).toList();
  }

  Future<void> deleteNoteData(int id) async {
    final db = await initializeData();
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateNotedata(Note note) async {
    final db = await initializeData();
    await db.update(
      table,
      note.fromJson(),
      where: 'id=?',
      whereArgs: [note.id],
    );
  }
}
