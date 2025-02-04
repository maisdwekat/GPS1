import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // لتحويل البيانات إلى JSON

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = []; // استخدام Map لتحديد نوع الرسالة

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({"text": _messageController.text, "type": "user"}); // إضافة رسالة المستخدم
        _messageController.clear();
      });

      // إرسال الرسالة إلى الخادم الذي يتواصل مع OpenAI API
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/ask'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'message': _messages.last['text']}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _messages.add({"text": data['response'], "type": "ai"}); // إضافة رد الذكاء الاصطناعي
          });
        } else {
          setState(() {
            _messages.add({"text": "حدث خطأ، حاول مرة أخرى.", "type": "ai"});
          });
        }
      } catch (e) {
        setState(() {
          _messages.add({"text": "فشل الاتصال بالخادم. تأكد من اتصال الإنترنت.", "type": "ai"});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI اسأل ",
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message["type"] == "user"; // تحديد نوع الرسالة

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.orange : Colors.grey[300], // تحديد اللون بناءً على نوع الرسالة
                          borderRadius: BorderRadius.circular(8.0), // زوايا مستديرة
                        ),
                        padding: EdgeInsets.all(12.0), // مساحة داخلية للمستطيل
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), // تحديد العرض الأقصى للمستطيل
                        child: Text(
                          message["text"]!,
                          style: TextStyle(color: Colors.black), // لون النص
                          textAlign: TextAlign.start, // محاذاة النص
                          maxLines: null, // السماح للنص بالانتقال إلى أسطر متعددة
                          overflow: TextOverflow.visible, // نص يظهر على عدة أسطر
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
                    maxLines: null, // السماح بإدخال نص متعدد الأسطر
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
    );
  }
}
