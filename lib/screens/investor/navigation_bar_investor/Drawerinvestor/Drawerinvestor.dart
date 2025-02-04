import 'package:flutter/material.dart';

import '../../../Welcome/welcome_screen.dart';
import '../MyInformation/MyAccount.dart';
import '../MyInformation/MyInvestments.dart';

class Drawerinvestor extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const Drawerinvestor({Key? key, required this.scaffoldKey}) : super(key: key);

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreeninvestor()));
            },
          ),
          ListTile(
            title: const Text('استثماراتي'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyInvestmentsScreen()));
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