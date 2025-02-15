import 'package:flutter/material.dart';

class AdminHeaders extends StatelessWidget {
  const AdminHeaders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        children: [
          Spacer(),
      Container(
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
      ),
          SizedBox(width: 20),
      Container(
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
      )        ],
      ),
    );;
  }
}

