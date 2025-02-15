import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/chatController.dart';
import 'package:ggg_hhh/Controllers/user_to_Admin_controller.dart';
import 'package:ggg_hhh/models/chat_model.dart';
import '../../Controllers/token_controller.dart';
import '../../Widget/chat/main_chat_show.dart';
import '../../models/user_model.dart';
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
  List<ChatModel> currentChatMessages = [];
  ChatController chatController = ChatController();
  UserToAdminController userToAdminController = UserToAdminController();
  List<User> users = [];
  List<ChatModel> chats = [];
  String? userId;
  List<dynamic> massages = [];

  final TextEditingController replyController = TextEditingController();

  getMessages() async {
    var fetchedMessages = await chatController.getMessagesToAdmin();
    var fetchingUsers = await userToAdminController.getUsers();


    if (fetchingUsers != null) {
      users = fetchingUsers.map((e) => User.fromJson(e),).toList();
      chats = fetchedMessages.map<ChatModel>((dynamic e) =>
          ChatModel.fromJson(e, users),).toList();
    }
    setState(() {

    });
  }

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: MainChatShow(massages: massages,userId:userId??'' , onTap: ()async{
            chats.clear();
            massages.clear();

              await getMessages();

              massages=chats.where((element) => element.userid==userId,).first.massages;
              print(massages);
           setState(() {
             
           });

          },)),
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
        if (page is WelcomeScreen) {
          TokenController tokenController = TokenController();
          tokenController.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page), (route) => false,);
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }




  Widget _buildUserMessages() {
    return Container(
      width: 250,
      color: Color(0xFF4A4A4A),
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              chats[index].name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              chats[index].massages.last['message'],
              style: TextStyle(color: Colors.white54),
            ),
            onTap: () {
              setState(() {
                massages = chats[index].massages;
                userId=chats[index].userid;
              });
            },
          );
        },
      ),
    );
  }

}

