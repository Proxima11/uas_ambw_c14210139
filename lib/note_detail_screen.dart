import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NoteDetailScreen extends StatefulWidget {
  final int? noteIndex;

  NoteDetailScreen({this.noteIndex});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late Box<Map> _notesBox;

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<Map>('notes');
    if (widget.noteIndex != null) {
      final note = _notesBox.getAt(widget.noteIndex!);
      _titleController.text = note!['title'];
      _contentController.text = note['content'];
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    final now = DateTime.now();

    if (widget.noteIndex == null) {
      final newNote = {
        'title': title,
        'content': content,
        'createdTime': now.toString(),
        'modifiedTime': now.toString(),
      };
      _notesBox.add(newNote);
    } else {
      final existingNote = _notesBox.getAt(widget.noteIndex!);
      final updatedNote = {
        'title': title,
        'content': content,
        'createdTime': existingNote!['createdTime'],
        'modifiedTime': now.toString(),
      };
      _notesBox.putAt(widget.noteIndex!, updatedNote);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteIndex == null ? 'New Note' : 'Edit Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveNote,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background_pin3.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Content',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Note',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(hintText: 'Content'),
                  minLines: 1,
                  maxLines: null,
                  // expands:
                  //     true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
