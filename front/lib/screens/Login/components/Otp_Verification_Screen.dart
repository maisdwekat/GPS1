import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import 'Reset_Password_Screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();

}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void verifyOtp(BuildContext context) async {
    var code = _otpController.text.trim();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(email:widget.email,code:code),
      ),
    );
  }
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

  void resendCode(BuildContext context) async {
    // var regBody = {"email": widget.email.trim()};
    var email = widget.email.trim();
    print("$email");

    var regBody = {"email": email};
    try {
      var response = await http.patch(
        Uri.parse('http://192.168.1.19:4000/api/v1/auth/sendcode'),
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
                'assets/images/code1.PNG',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                "أدخل رمز التحقق الذي أرسل إلى بريدك الإلكتروني",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "الرمز",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () => verifyOtp(context),
                  child: const Text("تحقق"),
                ),
              ),
              TextButton(
                onPressed: () => resendCode(context),
                child: const Text("إعادة إرسال الرمز"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
