import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'Otp_Verification_Screen.dart'; // تأكد من استيراد الشاشة الصحيحة
import 'package:http/http.dart' as http;

import 'Reset_Password_Screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _showSuccessDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xE2122088),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                "لقد تم ارسال الرمز الى بريدك بنجاح تحقق منه",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpVerificationScreen(email:email),
                  ),
                );
              },
              child: const Text(
                "حسناً",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void sendCode(BuildContext context) async {
    var email = _emailController.text.trim();
    print("$email");

    var regBody = {"email": email};
    try {
      var response = await http.patch(

        Uri.parse('http://172.29.32.1:4000/api/v1/auth/sendcode'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      print("Request Sent..\n");

      if (response.statusCode == 200) {
        _showSuccessDialog(context, email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to server: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/email.PNG',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                "أدخل بريدك الإلكتروني لارسال رمز لإعادة تعيين كلمة المرور",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "البريد الإلكتروني",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () => sendCode(context),
                  child: const Text("أرسل "),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
