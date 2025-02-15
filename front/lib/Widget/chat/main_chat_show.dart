import 'package:flutter/material.dart';

import '../admin/headers.dart';
import 'chat_text_form_field.dart';
import 'massage_bubble.dart';

class MainChatShow extends StatefulWidget {
  final List<dynamic> massages;
  final String userId;
  final onTap;
  MainChatShow({super.key, required this.massages,required this.userId,required this.onTap,});
  @override
  State<MainChatShow> createState() => _MainChatShowState();
}

class _MainChatShowState extends State<MainChatShow> {
  final TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminHeaders(),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Color(0xFF3A3A3A),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:widget.massages.length,
                    itemBuilder: (context, index) {
                      return MassageBubble(massage:widget.massages[index] ,onTap:widget. onTap,);
                    },
                  ),
                ),
                ChatTextFormField(replyController: replyController,userId: widget.userId,onTap: widget.onTap,), // حقل الرد في الأسفل
              ],
            ),
          ),
        ),
      ],
    );;
  }
}

