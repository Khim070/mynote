import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note2/connections/database_connection.dart';
import 'package:note2/model/model_note.dart';

class InsertPages extends StatefulWidget {
  InsertPages({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<InsertPages> createState() => _InsertPagesState();
}

class _InsertPagesState extends State<InsertPages> {
  TextEditingController _inserthead = TextEditingController();
  TextEditingController _insertbody = TextEditingController();

  late DataConnection db;
  late Future<List<Note>> ListNote;
  Future<void> _onRefresh() async {
    setState(() {
      ListNote = getList()
          .whenComplete(() => Future.delayed(const Duration(seconds: 1)));
    });
  }

  Future<List<Note>> getList() async {
    return await db.getNoteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insert Pages'),
        actions: [
          TextButton(
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () async {
              await DataConnection()
                  .insertData(Note(
                      id: Random().nextInt(100),
                      head: _inserthead.text,
                      body: _insertbody.text))
                  .whenComplete(() => _onRefresh());
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: TextField(
              controller: _inserthead,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Input Title'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: _insertbody,
              decoration: const InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          )
        ],
      ),
    );
  }
}
