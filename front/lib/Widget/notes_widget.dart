import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';

import '../Controllers/ProjectController.dart';

class Note {
  String id;
  String content;
  DateTime date;

  Note({
    required this.id,
    required this.content,
    required this.date,
  });

  factory Note.fromJson(dynamic json) {
    return Note(
      id: json['_id'],
      content: json['noteText'],
      date: DateTime.parse(json['createdAt']),
    );
  }

  Map<String,dynamic>toMap(){
    return {
      'noteText':content,
      'date':date.toIso8601String(),
    };
  }

}

class NotesWidget extends StatefulWidget {
  String id;  bool isPre = false ;

  NotesWidget({ required this.id});
  NotesWidget.pre({required this.isPre, required this.id});
  @override

  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
   List<Note>? notes = [];

  void initState() {
    super.initState();
    get();
  }
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
          notes==null?Text('لا يوجد ملاحظات'):ListView.builder(
            shrinkWrap: true,
            itemCount: notes!.length,
            itemBuilder: (context, index) {
              Note note = notes![index];
              return _buildNoteSection(note);
            },
          ),
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

  Widget _buildNoteSection(Note note) {
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
                onPressed: () => _showEditNoteDialog(note.content,0),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.orangeAccent),
                onPressed: () {
                  _deleteNote(note.id);
                },
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
                  dateFormater(note.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ProjectController _projectController =ProjectController();

 get() async {
   List<dynamic> notesList = await _projectController.getNotes(widget.id);
    notes=notesList.map((note) => Note.fromJson(note)).toList();
    setState(() {

    });

  }

  void _addNote(String projectId,String content) async {
    print('Adding note for projectId: $projectId');
    print('Note content: $content');
    // إعداد بيانات الملاحظة
    Map<String, dynamic> noteData = {
      'noteText': content,
    };
    print('Note data to send: $noteData');

    final result = await _projectController.addNote(projectId, noteData);
    print('Result from addNote: $result');
    if (result['success'] == true) {
      print('Note added successfully');
      setState(() {
        notes!.add(Note(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          content: content,
          date: DateTime.now(),
        ));
        print('Updated notes list: $notes');
      });
      Get.snackbar(
        'Success',
        result['message'] ?? 'Note added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      print('Error: ${result['message']}');
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to add note!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  // void _addNote(String content) {
  //
  //   setState(() {
  //     notes.add(Note(
  //       content: content,
  //       date: DateTime.now(),
  //     ));
  //   });
  // }

  // void _editNote(int index, String newContent) async {
  //   Map<String, dynamic> noteData = {
  //     'noteText': newContent, // بيانات الملاحظة الجديدة
  //   };
  //
  //   // استدعاء الدالة updateNote
  //   var result = await _projectController.updateNote(widget.id,  notesFormGet[index]['_id'], noteData);
  //
  //   // التعامل مع النتيجة
  //   if (result['success']) {
  //     print('Note updated successfully: ${result['message']}');
  //   } else {
  //     print('Error updating note: ${result['message']}');
  //   }
  //   setState(() {
  //     notes[index].content = newContent;
  //   });
  // }


  void _deleteNote(String noteId) async {
    _projectController.deleteNote(widget.id, noteId );
    setState(() {
      notes!.removeWhere((element) => element.id==noteId,);
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
                  _addNote(widget.id,newNoteContent);
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
                  // _editNote(index, updatedNoteContent);
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