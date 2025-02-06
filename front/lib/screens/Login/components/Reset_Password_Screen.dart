import 'package:flutter/material.dart';
import 'package:ggg_hhh/screens/users/homepageUsers/HomePageScreenUsers.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  ResetPasswordScreen({required this.email, required this.code});
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureTextNewPassword = true;
  bool _obscureTextConfirmPassword = true;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/forgotpassword.PNG',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: defaultPadding),
              const Text(
                "أدخل كلمة المرور الجديدة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureTextNewPassword,
                  decoration: InputDecoration(
                    hintText: "كلمة المرور الجديدة",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextNewPassword = !_obscureTextNewPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureTextConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "تأكيد كلمة المرور",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    _resetPassword(context);
                  },
                  child: const Text("تحديث كلمة المرور"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور وتأكيد كلمة المرور غير متطابقتين')),
      );
      return;
    }

    var body = {
      "code": widget.code,
      "email": widget.email,
      "newPassword":newPassword

    };

    try {
      var response = await http.patch(
        Uri.parse('http://172.29.32.1:4000/api/v1/auth/forgetpassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print("Req Sent");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تغيير كلمة السر ')),
        );
        _showSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الاتصال بالخادم: $error')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/like.PNG',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),
              const Text(
                "تم إعادة تعيين كلمة المرور بنجاح.",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>LoginForm()),
                );
              },
              child: const Text("حسناً"),
            ),
          ],
        );
      },
    );
  }
}
