import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/users_chat_controller.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatForInquiriesScreen extends StatefulWidget {
  const ChatForInquiriesScreen({super.key, required this.id});
  final String id;

  @override
  _ChatForInquiriesScreenState createState() => _ChatForInquiriesScreenState();
}

class _ChatForInquiriesScreenState extends State<ChatForInquiriesScreen> {
  UsersChatController usersChatController = UsersChatController();
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _isChatVisible = true; // اجعل الشات مرئيًا بشكل افتراضي
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final String messageText = _messageController.text;
      usersChatController.getMessageUser(widget.id, messageText);

      // إضافة الرسالة إلى واجهة المستخدم
      setState(() {
        messages.add({
          'sender': 'user',
          'message': messageText,
        });
        _messageController.clear();
      });

      // إرسال الرسالة إلى Firestore
      // _sendMessageToFirestore(messageText, timeStamp);
    }
  }

  // Future<void> _sendMessageToFirestore(String message, String time) async {
  //   await _firestore.collection('messages').add({
  //     'sender': 'user',
  //     'message': message,
  //     'time': time,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  // Future<void> _fetchMessages() async {
  //   _firestore.collection('messages').orderBy('timestamp').snapshots().listen((snapshot) {
  //     setState(() {
  //       messages.clear();
  //       for (var doc in snapshot.docs) {
  //         messages.add({
  //           'sender': doc['sender'],
  //           'message': doc['message'],
  //           'time': doc['time'],
  //         });
  //       }
  //     });
  //   });
  // }

  void _toggleChatVisibility() {
    setState(() {
      _isChatVisible = !_isChatVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    // _fetchMessages(); // جلب الرسائل عند بدء الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return _isChatVisible ? _buildChatWidget() : Container(); // عرض الشات مباشرة
  }

  Widget _buildChatWidget() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D47),
        title: Text("محادثة الاستفسارات"),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUserMessage = message['sender'] == 'user';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.orange : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          child: Column(
                            crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? '',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.start,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Color(0xFF0A1D47),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "أدخل رسالتك",
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}