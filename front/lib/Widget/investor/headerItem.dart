import 'package:flutter/material.dart';

class Headeritem extends StatelessWidget {
  IconData? icon;
  final Widget screen;
  final String title;
   Headeritem({super.key,this.icon,required this.title,required this.screen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: Color(0xFF001F3F), size: 16),
            if (icon != null) SizedBox(width: 4),
            Text(title, style: TextStyle(color: Color(0xFF001F3F))),
          ],
        ),
      ),
    );;
  }
}


