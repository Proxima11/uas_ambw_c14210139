import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'note_detail_screen.dart';
import 'settings_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Box<Map> _notesBox;

  @override
  void initState() {
    super.initState();
    _openNotesBox();
  }

  void _openNotesBox() async {
    if (!Hive.isBoxOpen('notes')) {
      _notesBox = await Hive.openBox<Map>('notes');
    } else {
      _notesBox = Hive.box<Map>('notes');
    }
    setState(() {});
  }

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteDetailScreen(noteIndex: null)),
    ).then((_) => setState(() {}));
  }

  void _editNote(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteDetailScreen(noteIndex: index)),
    ).then((_) => setState(() {}));
  }

  void _deleteNote(int index) {
    setState(() {
      _notesBox.deleteAt(index);
    });
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _notesBox.listenable(),
        builder: (context, Box<Map> box, _) {
          if (box.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/background_pin3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note,
                      color: Colors.grey,
                      size: 100,
                    ),
                    Text(
                      'No notes',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/background_pin3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final note = box.getAt(index);
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/images/background_note.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      title: Text(
                        note!['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Created: ${formatDate(note['createdTime'])}\nLast edited: ${formatDate(note['modifiedTime'])}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      onTap: () => _editNote(index),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteNote(index),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
