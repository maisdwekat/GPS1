import 'package:flutter/material.dart';
import '../users/navigation_bar/NavigationBarUsers.dart';
import 'ActiveUsersTable.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chatscreen.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, String>> courses = [];
  String selectedGroup = 'جميع المستخدمين'; // المتغير لتخزين الخيار المحدد
  TextEditingController emailController = TextEditingController();
  TextEditingController notificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
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
        _buildTitle(),
        SizedBox(height: 20),
        _buildNotificationForm(), // إضافة نموذج الإشعار
      ],
    );
  }
  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "الاشعارات",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget _buildNotificationForm() {
    return Container(
      width: 600, // تحديد عرض المستطيل
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "إرسال إشعار",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedGroup,
            dropdownColor: Color(0xFF4A4A4A),
            style: TextStyle(color: Colors.white),
            items: <String>[
              'جميع المستخدمين',
              'جميع المستثمرين',
              'بريد إلكتروني محدد'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedGroup = newValue!;
                // إذا تم اختيار "بريد إلكتروني محدد"، يتم مسح محتوى حقل البريد الإلكتروني
                if (selectedGroup != 'بريد إلكتروني محدد') {
                  emailController.clear();
                }
              });
            },
          ),
          SizedBox(height: 10),
          // عرض حقل البريد الإلكتروني فقط إذا تم اختيار "بريد إلكتروني محدد"
          if (selectedGroup == 'بريد إلكتروني محدد') ...[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "البريد الإلكتروني",
                hintStyle: TextStyle(color: Colors.white54),
                fillColor: Color(0xFF2B2B2B),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              style: TextStyle(color: Colors.white), // لون النص
            ),
            SizedBox(height: 10),
          ],
          TextField(
            controller: notificationController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "اكتب الإشعار هنا...",
              hintStyle: TextStyle(color: Colors.white54),
              fillColor: Color(0xFF2B2B2B),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            style: TextStyle(color: Colors.white), // لون النص
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              String email = emailController.text;
              String notification = notificationController.text;

              // منطق إرسال الإشعار هنا
              print('إرسال إشعار إلى: $selectedGroup');
              if (selectedGroup == 'بريد إلكتروني محدد') {
                print('البريد الإلكتروني: $email');
              }
              print('الإشعار: $notification');
              // يمكنك إضافة طلب HTTP هنا لإرسال الإشعار
            },
            child: Text("إرسال"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
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