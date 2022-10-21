import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note2/connections/database_connection.dart';
import 'package:note2/main.dart';
import 'package:note2/model/model_note.dart';
import 'package:note2/screen/insert_screen.dart';
import 'package:note2/screen/main_screen.dart';

class UpdatePages extends StatefulWidget {
  UpdatePages({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  State<UpdatePages> createState() => _UpdatePagesState();
}

class _UpdatePagesState extends State<UpdatePages> {
  TextEditingController _updatehead = TextEditingController();
  TextEditingController _updatebody = TextEditingController();
  late Future<List<Note>> listNote;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updatehead.text = widget.note.head;
    _updatebody.text = widget.note.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          TextButton(
              onPressed: () async {
                await DataConnection()
                    .updateNotedata(Note(
                        id: widget.note.id,
                        head: _updatehead.text,
                        body: _updatebody.text))
                    .whenComplete(() => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                        (route) => false));
              },
              child: const Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: TextField(
              controller: _updatehead,
              decoration:
                  const InputDecoration(border: InputBorder.none, hintText: ''),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: _updatebody,
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
