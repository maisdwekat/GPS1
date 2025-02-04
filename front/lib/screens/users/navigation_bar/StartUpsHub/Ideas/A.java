// أيقونة التعليقات
Column(
  children: [
    IconButton(
      icon: Icon(Icons.comment, color: kPrimaryColor),
      onPressed: () {
        setState(() {
          _showAbout = false; // تعيين الحالة لتظهر التعليقات
        });
      },
    ),
    Text(
      '${item['commentsCount']}', // عدد التعليقات
      style: TextStyle(fontSize: 12), // حجم النص
    ),
  ],
),