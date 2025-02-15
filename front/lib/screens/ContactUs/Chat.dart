import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Controllers/chatController.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController chatController =
      ChatController(); // إنشاء كائن من ChatController
  List<dynamic> messages = [];

  getMessages() async {
    await chatController.getMessages();
    setState(() {
      messages = chatController.messages;
    });
  }

  sendMessages(String massageText) async {
    await chatController.sendMessage(massageText);
    setState(() {
      messages = chatController.messages;
    });
  }

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  final TextEditingController _messageController = TextEditingController();
  bool hasWelcomed = false;

  // Future<void> _sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     final String messageText = _messageController.text;
  //     final String timeStamp = DateFormat('HH:mm').format(DateTime.now());
  //
  //     setState(() {
  //       messages.add({
  //         'sender': 'user',
  //         'message': messageText,
  //         'time': timeStamp,
  //       });
  //       _messageController.clear();
  //
  //       if (!hasWelcomed) {
  //         hasWelcomed = true;
  //         messages.add({
  //           'sender': 'admin',
  //           'message': 'مرحبًا ميس، شكرًا على رسالتك. سنرد عليك في أقرب وقت.',
  //           'time': timeStamp,
  //         });
  //       }
  //     });
  //
  //     // إرسال الرسالة إلى الباك إند
  //     final adminResponse = await chatController.sendMessage(messageText);
  //
  //     if (adminResponse != null) {
  //       setState(() {
  //         messages.add({
  //           'sender': 'admin',
  //           'message': adminResponse,
  //           'time': timeStamp,
  //         });
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الدردشة المباشرة',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A1D47),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['senderRole'] == 'user';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: isUserMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(isUserMessage ? 'انت' : 'الأدمن'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: isUserMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(12.0),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            child: Column(
                              crossAxisAlignment: isUserMessage
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['message'] ?? '',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.start,
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  message['time'] ?? '',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                  onPressed: () {
                    sendMessages(_messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
