import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/AuthController.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../../investor/homepageinvestor/HomePageScreeninvestor.dart';
import '../../users/homepageUsers/HomePageScreenUsers.dart';
import '../../Login/components/forgot_password.dart'; // تأكد من استيراد صفحة استعادة كلمة المرور
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  // إنشاء مفتاح للتحقق من صحة النموذج
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? role; // متغير لحفظ التوكن وعرضه

  // دالة للحصول على التوكن
  void _getToken(BuildContext context) async {
    AuthController authController = AuthController();
    String? savedToken = await authController.getToken();

    if (savedToken != null) {
      print('تم العثور على التوكن: $savedToken');

      Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);
      String role = decodedToken['role'];
      print('تم فك تشفير التوكن، الدور: $role');

      if (role == 'investor') {
        print('توجيه إلى صفحة المستثمر');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageScreeninvestor()),
        );
      } else if (role == 'user') {
        print('توجيه إلى الصفحة الرئيسية للمستخدم');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepagescreen()),
        );
      } else if (role == 'admin') {
        print('توجيه إلى الصفحة الرئيسية للمسؤول');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepagescreen()),
        );
      } else {
        print('الدور غير معترف به: $role');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role not recognized: $role')),
        );
      }
    } else {
      print('لم يتم العثور على التوكن');
    }
  }
  void loginUser(BuildContext context) async {
    var email = _emailController.text;
    var password = _passwordController.text;

    // استدعاء AuthController
    AuthController authController = AuthController();

    var result = await authController.login(email, password);

    if (result['success']) {
      _getToken(context);
      // تسجيل الدخول ناجح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );

    } else {
      // عرض رسالة خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // ربط الـformKey
      child: Column(
        children: [
          TextFormField(
            controller: _emailController, // ربط الـcontroller هنا
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "البريد الإلكتروني",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              final emailRegExp = RegExp(emailPattern);
              if (!emailRegExp.hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController, // ربط الـcontroller هنا
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "كلمة المرور",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                loginUser(context); // إرسال البيانات إذا كانت صحيحة
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fix the errors')),
                );
              }
            },
            child: Text(
              "تسجيل الدخول".toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold, // جعل النص بالخط العريض
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(), // الانتقال إلى صفحة استعادة كلمة المرور
                ),
              );
            },
            child: const Text(
              "هل نسيت كلمة المرور؟",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold, // جعل النص بالخط العريض
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
