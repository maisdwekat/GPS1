import 'package:flutter/material.dart';
import '../Welcome/welcome_screen.dart';
import '../users/navigation_bar/NavigationBarUsers.dart';
import 'ActiveUsersTable.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class chat extends StatefulWidget {
  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<chat> {
  List<Map<String, String>> currentChatMessages = [];

  final List<Map<String, String>> messages = [
    {'user': 'User1', 'message': 'Hello, how are you?'},
    {'user': 'User2', 'message': 'Need help with my project.'},
    {'user': 'User3', 'message': 'Can you share the document?'},
  ];

  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
          _buildUserMessages(),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF4A4A4A),
      child: Column(
        children: [
          SizedBox(height: 70),
          _buildMenuItem(context, "لوحة التحكم", DashboardPage()),
          _buildMenuItem(context, "المستخدمون", UsersPage()),
          _buildMenuItem(context, "المشاريع", ProjectsPage()),
          _buildMenuItem(context, "الأفكار", IdeasPage()),
          _buildMenuItem(context, "الدورات", Courses()),
          _buildMenuItem(context, "أكثر المستخدمين نشاطًا", ActiveUsers()),
          _buildMenuItem(context, "الفيد باك", FeedbackPage()),
          _buildMenuItem(context, "المنح", Grantpage()),
          _buildMenuItem(context, "الاشعارات", Notifications()),
          _buildMenuItem(context, "الرسائل", chat()),
          _buildMenuItem(context, "تسجيل خروج", WelcomeScreen()),

        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Color(0xFF3A3A3A),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: currentChatMessages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(currentChatMessages[index]);
                    },
                  ),
                ),
                _buildReplyField(), // حقل الرد في الأسفل
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    bool isUser = message['user'] != 'Admin'; // تغيير الشرط بناءً على دور المستخدم
    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.grey[700] : Colors.blue[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message['message']!,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        children: [
          Spacer(),
          _buildSearchBar(),
          SizedBox(width: 20),
          ProfileCard(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          hintText: "بحث",
          hintStyle: TextStyle(color: Colors.white54),
          fillColor: Color(0xFF4A4A4A),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white54),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserMessages() {
    return Container(
      width: 250,
      color: Color(0xFF4A4A4A),
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              messages[index]['user']!,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              messages[index]['message']!,
              style: TextStyle(color: Colors.white54),
            ),
            onTap: () {
              setState(() {
                // عند اختيار محادثة، يتم تحميل الرسائل الخاصة بها
                currentChatMessages = [
                  {'user': messages[index]['user']!, 'message': messages[index]['message']!},
                  // يمكنك إضافة المزيد من الرسائل هنا إذا لزم الأمر
                ];
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildReplyField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: replyController,
            decoration: InputDecoration(
              hintText: "اكتب ردك هنا...",
              fillColor: Color(0xFF4A4A4A),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.green),
          onPressed: () {
            if (replyController.text.isNotEmpty) {
              setState(() {
                currentChatMessages.add({
                  'user': 'Admin',
                  'message': replyController.text,
                });
                replyController.clear();
              });
            }
          },
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/defaultpfp.jpg"),
            radius: 19,
          ),
          SizedBox(width: 10.0),
          Text(
            "اسم الادمن",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}