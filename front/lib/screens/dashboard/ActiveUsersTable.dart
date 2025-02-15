import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';
import '../../Controllers/token_controller.dart';
import '../../Controllers/user_to_Admin_controller.dart';
import '../../Widget/admin/sidebar.dart';
import '../../models/user_model.dart';
import '../Welcome/welcome_screen.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';

class ActiveUsers extends StatefulWidget {
  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
 List<User> users = [];
 UserToAdminController userToAdminController = UserToAdminController();

 getUsers() async {
   List<dynamic>? fetchingUsers=await userToAdminController.getUsers();
   if(fetchingUsers!=null){

     users=fetchingUsers.map((e) => User.fromJson(e),).toList();
     users.removeWhere((element) => element.lastLogin==null,);
     users.removeWhere((element) => element.role=="admin",);
     users.sort((User a, User b) => b.lastLogin!.compareTo(a.lastLogin!));

     setState(() {

     });

   }
 }

  @override
  void initState() {
    getUsers();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B), // تغيير لون الخلفية هنا
      body: Row(
        children: [
          Sidebar(),
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              Expanded(child: UserActivityTable(users: users,)), // عرض جدول النشاط
              _buildUserActivityBoxes(), // عرض مربعات النشاط
            ],
          ),
        ),
      ],
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

  Widget _buildUserActivityBoxes() {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActivityBox("صفحة المشاريع", Colors.blue, 70),
          _buildActivityBox("صفحة الأفكار", Colors.green, 50),
          _buildActivityBox("صفحة الدورات", Colors.orange, 30),
          _buildActivityBox("صفحة الاستثمار", Colors.red, 90),
        ],
      ),
    );
  }

  Widget _buildActivityBox(String title, Color color, double percentage) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.white54,
            color: Colors.white,
          ),
          SizedBox(height: 4),
          Text(
            "${percentage.toStringAsFixed(0)}% من الزيارات",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class UserActivityTable extends StatelessWidget {
  final List<User> users;
  UserActivityTable({Key? key, required this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF4A4A4A), // لون خلفية الجدول
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columnSpacing: 8,
              horizontalMargin: 10,
              dataRowHeight: 48,
              columns: [
                DataColumn(label: Container(width: 100, child: Text("اسم المستخدم", style: TextStyle(color: Colors.white)))),
                DataColumn(label: Container(width: 150, child: Text("البريد الإلكتروني", style: TextStyle(color: Colors.white)))),
                DataColumn(label: Container(width: 100, child: Text("عدد الأنشطة", style: TextStyle(color: Colors.white)))),
                DataColumn(label: Container(width: 150, child: Text("تاريخ آخر نشاط", style: TextStyle(color: Colors.white)))),
                DataColumn(label: Container(width: 100, child: Text("مستوى النشاط", style: TextStyle(color: Colors.white)))),
              ],
              rows: users.map((user) {
                return _createRow(user.name, user.email, 20, dateFormater(user.lastLogin!), "نشط");
              }).toList(),
              // [
              //   _createRow("مستخدم 1", "user1@example.com", 20, "2024-12-01", "نشط"),
              //   _createRow("مستخدم 2", "user2@example.com", 15, "2024-12-02", "متوسط"),
              //   _createRow("مستخدم 3", "user3@example.com", 5, "2024-12-03", "قليل"),
              // ],

            ),
          ),
        ),
      ),
    );
  }

  DataRow _createRow(String username, String email, int activities, String lastActivityDate, String activityLevel) {
    return DataRow(cells: [
      DataCell(Text(username, style: TextStyle(color: Colors.white))),
      DataCell(Text(email, style: TextStyle(color: Colors.white))),
      DataCell(Text(activities.toString(), style: TextStyle(color: Colors.white))),
      DataCell(Text(lastActivityDate, style: TextStyle(color: Colors.white))),
      DataCell(Text(activityLevel, style: TextStyle(color: Colors.white))),
    ]);
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