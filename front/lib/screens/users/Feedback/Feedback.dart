import 'package:flutter/material.dart';
import '../../../Controllers/feedbackController.dart';
import '../../basic/footer.dart';
import '../../basic/header.dart';
import '../navigation_bar/DrawerUsers/DrawerUsers.dart';
import '../navigation_bar/NavigationBarUsers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // لتحويل البيانات إلى JSON
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  FeedbackController feedbackController = FeedbackController();
  // void _submitFeedback() async {
  //   if (_formKey.currentState!.validate()) {
  //     final email = _emailController.text;
  //     final feedback = _feedbackController.text;
  //
  //     // إعداد بيانات الفيدباك
  //     final Map<String, String> data = {
  //       'email': email,
  //       'feedback': feedback,
  //     };
  //
  //     // إرسال بيانات الفيدباك إلى الباك إند
  //     final response = await http.post(
  //       Uri.parse('https://your-backend-url.com/api/feedback'), // استبدل بعنوان URL الخاص بك
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(data),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // الفيدباك تم إرساله بنجاح
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('تم إرسال الفيدباك بنجاح!')),
  //       );
  //       // يمكنك إعادة تعيين الحقول هنا إذا رغبت
  //       _emailController.clear();
  //       _feedbackController.clear();
  //     } else {
  //       // حدث خطأ أثناء الإرسال
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('حدث خطأ أثناء إرسال الفيدباك.')),
  //       );
  //     }
  //   }
  // }





  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController(); // تعريف المتحكم للبريد الإلكتروني
  final _formKey = GlobalKey<FormState>();
  bool _isTyping = false; // حالة لتتبع الكتابة


  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() {
      setState(() {
        _isTyping = _feedbackController.text.isNotEmpty; // تحديث الحالة عند الكتابة
      });
    });
  }


  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey), // استدعاء Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(), // استدعاء الهيدر
            NavigationBarUsers(
              onSelectContact: (value) {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            const SizedBox(height: 40),
            _buildFeedbackForm(),
            const SizedBox(height: 40),
            Footer(), // استدعاء الفوتر
          ],
        ),
      ),
    );
  }
  Widget _buildFeedbackForm() {
    return Center(
      child: Container(
        width: 700, // عرض المستطيل الخارجي
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20), // زوايا مدورة
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5), // ظل بسيط
            ),
          ],
        ),
        padding: EdgeInsets.all(20), // هوامش داخلية
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'نحن نحب سماع آرائكم! يرجى تقديم الفيدباك الخاص بك',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, // خط عريض
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // محاذاة العناصر إلى اليسار
                children: [
                  // عنوان البريد الإلكتروني
                  // Text(
                  //   'البريد الإلكتروني',
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 5), // فراغ بين العنوان وحقل الإدخال
                  // // حقل إدخال البريد الإلكتروني
                  // TextFormField(
                  //   controller: _emailController,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10), // زوايا مدورة
                  //       borderSide: BorderSide(color: Colors.orangeAccent), // لون الحدود
                  //     ),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'يرجى إدخال البريد الإلكتروني';
                  //     }
                  //     // التحقق من تنسيق البريد الإلكتروني
                  //     String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  //     RegExp regex = RegExp(pattern);
                  //     if (!regex.hasMatch(value)) {
                  //       return 'يرجى إدخال بريد إلكتروني صالح';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 20),
                  // عنوان الفيدباك
                  Text(
                    'شارك رأيك معنا',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5), // فراغ بين العنوان وحقل الإدخال
                  // حقل إدخال الفيدباك
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 5,
                    textAlign: TextAlign.right, // بدء الكتابة من اليمين
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // زوايا مدورة
                        borderSide: BorderSide(color: Colors.white54), // لون الحدود
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الفيدباك';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center( // وضع الزر في المنتصف
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) { // التحقق من صحة النموذج
                          await feedbackController.addFeedback(_feedbackController.text);

                          // إظهار رسالة نجاح
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إرسال الفيدباك بنجاح!')),
                          );

                          // مسح النص في حقل الإدخال
                          _feedbackController.clear();
                        }
                      },
                      child: Text('إرسال الفيدباك'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A1D47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // زوايا مدورة
                        ),
                        minimumSize: Size(150, 50), // تغيير حجم الزر (عرض, ارتفاع)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}