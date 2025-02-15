import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/chatController.dart';

class ChatTextFormField extends StatefulWidget {
   ChatTextFormField({super.key,required this.replyController,required this.userId,required this.onTap});
   String userId;
   final onTap;
  final TextEditingController replyController ;

  @override
  State<ChatTextFormField> createState() => _ChatTextFormFieldState();
}

class _ChatTextFormFieldState extends State<ChatTextFormField> {
  ChatController chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return widget.userId==''?SizedBox(): Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.replyController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "اكتب ردك هنا...",
              fillColor: Color(0xFF4A4A4A),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Colors.green),
          onPressed: () async {
            if (widget.replyController.text.isNotEmpty) {
              await chatController.sendMessageAdmin(widget.replyController.text, widget.userId);
              widget.onTap();
              widget.replyController.clear();
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
