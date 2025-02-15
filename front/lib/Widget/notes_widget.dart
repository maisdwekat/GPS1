import 'package:flutter/material.dart';

class Note {
  String content;
  DateTime date;

  Note({
    required this.content,
    required this.date,
  });
}

class NotesWidget extends StatefulWidget {
  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final List<dynamic> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProjectNotesContent(),
    );
  }
  Widget _buildProjectNotesContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight, // محاذاة النص إلى أقصى اليمين
            child: Text(
              'الملاحظات',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right, // محاذاة النص إلى اليمين
            ),
          ),
          SizedBox(height: 10),
          ...notes.map((note) {
            int index = notes.indexOf(note);
            return _buildNoteSection(note, index);
          }).toList(),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight, // محاذاة الزر إلى اليمين
            child: FloatingActionButton(
              onPressed: () => _showAddNoteDialog(),
              child: Icon(Icons.add),
              backgroundColor: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(Note note, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orangeAccent),
                onPressed: () => _showEditNoteDialog(note.content, index),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.orangeAccent),
                onPressed: () => _deleteNote(index),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(note.content, style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text(
                  '${note.date.day}/${note.date.month}/${note.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNote(String content) {
    setState(() {
      notes.add(Note(
        content: content,
        date: DateTime.now(),
      ));
    });
  }

  void _editNote(int index, String newContent) {
    setState(() {
      notes[index].content = newContent;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void _showAddNoteDialog() {
    String newNoteContent = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('إضافة ملاحظة جديدة'),
          content: Container(
            width: 400,
            height: 200,
            child: TextField(
              onChanged: (value) {
                newNoteContent = value;
              },
              decoration: InputDecoration(hintText: 'محتوى الملاحظة'),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newNoteContent.isNotEmpty) {
                  _addNote(newNoteContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(String currentContent, int index) {
    String updatedNoteContent = currentContent;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل الملاحظة'),
          content: Container(
            width: 400,
            height: 200,
            child: TextField(
              onChanged: (value) {
                updatedNoteContent = value;
              },
              decoration: InputDecoration(hintText: 'محتوى الملاحظة'),
              controller: TextEditingController(text: currentContent),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updatedNoteContent.isNotEmpty) {
                  _editNote(index, updatedNoteContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }


}