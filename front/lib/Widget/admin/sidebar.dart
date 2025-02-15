import 'package:flutter/material.dart';

import '../../screens/Welcome/welcome_screen.dart';
import '../../screens/dashboard/ActiveUsersTable.dart';
import '../../screens/dashboard/Courses.dart';
import '../../screens/dashboard/Dashboard.dart';
import '../../screens/dashboard/FeedbackPage.dart';
import '../../screens/dashboard/Grants.dart';
import '../../screens/dashboard/IdeasPage.dart';
import '../../screens/dashboard/Notifications.dart';
import '../../screens/dashboard/ProjectsPage.dart';
import '../../screens/dashboard/UsersPage.dart';
import '../../screens/dashboard/chatscreen.dart';
import 'menu_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF4A4A4A),
      child: Column(
        children: [
          SizedBox(height: 70),
          MenuItem( title:"لوحة التحكم", page:DashboardPage()),
          MenuItem( title:"المستخدمون",page: UsersPage()),
          MenuItem(title:"المشاريع",page: ProjectsPage()),
          MenuItem(title: "الأفكار", page:IdeasPage()),
          MenuItem(title: "الدورات",page: Courses()),
          MenuItem(title: "أكثر المستخدمين نشاطًا",page: ActiveUsers()),
          MenuItem(title:"الفيد باك",page: FeedbackPage()),
          MenuItem(title: "المنح",page: Grantpage()),
          MenuItem(title:"الاشعارات",page: Notifications()),
          MenuItem(title: "الرسائل", page:chat()),
          MenuItem(title: "تسجيل خروج",page: WelcomeScreen()),




        ],
      ),
    );;
  }
}
