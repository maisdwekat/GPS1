import 'package:flutter/material.dart';

import '../../Controllers/token_controller.dart';
import '../../screens/Welcome/welcome_screen.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final Widget page;
  const MenuItem({super.key, required this.title, required this.page});

  @override
  Widget build(BuildContext context) {
     return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
      onTap: () {
        if (page is WelcomeScreen) {
          TokenController tokenController=TokenController();
          tokenController.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),(route) => false,);
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }},
    );;
  }
}

