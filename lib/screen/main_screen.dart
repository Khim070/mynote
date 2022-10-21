import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note2/connections/database_connection.dart';
import 'package:note2/model/model_note.dart';
import 'package:note2/screen/insert_screen.dart';
import 'package:note2/screen/update_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
  void initState() {
    // TODO: implement initState
    db = DataConnection();
    _onRefresh();
    db.initializeData().whenComplete(() async {
      setState(() {
        ListNote = db.getNoteData();
        print(ListNote.then((value) => value.first.head.toString()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InsertPages(
                        title: 'InsertPages',
                      ),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: ListNote,
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Icon(Icons.info),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  var not = snapshot.data![index];
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePages(
                              note: not,
                            ),
                          ));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          not.head,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await DataConnection()
                                  .deleteNoteData(not.id)
                                  .whenComplete(() => _onRefresh());
                            },
                            icon: const Icon(Icons.delete_forever)),
                      ),
                    ),
                  );
                }));
          }
        },
      ),
    );
  }
}
