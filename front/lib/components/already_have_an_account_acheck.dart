import 'package:flutter/material.dart';
import 'package:ggg_hhh/constants.dart';
import '../screens/Login/components/forgot_password.dart'; // تأكد من استيراد صفحة استعادة كلمة المرور
import '../screens/Signup/signup_screen.dart'; // تأكد من استيراد الصفحة المناسبة

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;

  const AlreadyHaveAnAccountCheck({
    super.key,
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "سجل الآن" : "تسجيل الدخول",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

        ),
        const SizedBox(width: 5), // إضافة مسافة بين النصين

        Text(
          login ? "ليس لديك حساب؟ " : "لديك حساب بالفعل؟ ",
          style: const TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),


      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // ... (نموذج الإدخال الآخر)
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(), // تأكد من استيراد الصفحة المناسبة
                ),
              );
            },
            child: const Text(
              "هل نسيت كلمة المرور؟",
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
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