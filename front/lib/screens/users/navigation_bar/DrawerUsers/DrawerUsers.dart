import 'package:flutter/material.dart';

import '../../../Welcome/welcome_screen.dart';
import '../MyInformation/MyAccount.dart';
import '../MyInformation/MyIdeas/MyIdeas.dart';
import '../MyInformation/MyStartupProjects/MyStartupProjects.dart';

class DrawerUsers extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerUsers({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: SizedBox.shrink(),
          ),
          ListTile(
            title: const Text('حسابي'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            title: const Text('مشاريعي الناشئة'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyStartupProjectsScreen()));
            },
          ),
          ListTile(
            title: const Text('افكاري'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyIdeasScreen()));
            },
          ),
          ListTile(
            title: const Text('تسجيل خروج'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        ],
      ),
    );
  }
}