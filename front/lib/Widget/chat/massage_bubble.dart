import 'package:flutter/material.dart';

class MassageBubble extends StatefulWidget {
  final dynamic massage;
  final onTap;
   MassageBubble({super.key, required this.massage,required this.onTap});

  @override
  State<MassageBubble> createState() => _MassageBubbleState();
}

class _MassageBubbleState extends State<MassageBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.massage['senderRole'] != 'admin' ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.massage['senderRole'] != 'admin' ? Colors.grey[700] : Colors.blue[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          widget.massage['message']!,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


