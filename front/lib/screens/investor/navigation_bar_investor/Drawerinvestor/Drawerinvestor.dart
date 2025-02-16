import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';

import '../../../Welcome/welcome_screen.dart';
import '../MyInformation/MyAccount.dart';
import '../MyInformation/MyInvestments.dart';
import '../MyInformation/calendar.dart';

class Drawerinvestor extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

   Drawerinvestor({Key? key, required this.scaffoldKey}) : super(key: key);
  TokenController tokenController=TokenController();
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
            title: const Text('التقويم'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  Calender()));
            },
          ),
          ListTile(
            title: const Text('تسجيل خروج'),
            onTap: () {
              tokenController.logout();
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        ],
      ),
    );
  }
}