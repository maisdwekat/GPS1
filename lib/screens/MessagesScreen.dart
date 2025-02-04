import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> messages = [
      {
        'userName': 'أحمد',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'كيف حالك؟',
        'time': '10:30 AM',
      },
      {
        'userName': 'سارة',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'هل تريد الذهاب إلى السينما؟',
        'time': '9:15 AM',
      },
      // Add more messages as needed
    ];

    return Scaffold(
      appBar: AppBar(title: Text('الرسائل')),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(
            messages[index]['userName']!,
            messages[index]['userImage']!,
            messages[index]['message']!,
            messages[index]['time']!,
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(String userName, String userImage, String message, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(userImage),
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}