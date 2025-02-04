import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> notifications = [
      {
        'title': 'إشعار 1',
        'message': 'هذا هو نص الإشعار الأول.',
      },
      {
        'title': 'إشعار 2',
        'message': 'هذا هو نص الإشعار الثاني.',
      },
      // Add more notifications as needed
    ];

    return Scaffold(
      appBar: AppBar(title: Text('الإشعارات')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationItem(
            notifications[index]['title']!,
            notifications[index]['message']!,
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}