import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:html' as html;

import '../../../Controllers/AuthController.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../investor/homepageinvestor/HomePageScreeninvestor.dart';
import '../../users/homepageUsers/HomePageScreenUsers.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  String _gender = 'male';
  String _role = 'user';
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  void registerUser(BuildContext context) async {
    AuthController authController = AuthController();
    var regBody = {
      "name": _usernameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "phoneNumber": _phoneController.text,
      "gender": _gender,
      "role": _role,
    };

    print("Attempting to register user with the following data:");
    print("Name: ${regBody['name']}");
    print("Email: ${regBody['email']}");
    print("password: ${regBody['password']}");
    print("Phone: ${regBody['phoneNumber']}");
    print("Gender: ${regBody['gender']}");
    print("Role: ${regBody['role']}");

    final result = await authController.signup(
      regBody['name']!,
      regBody['email']!,
      regBody['password']!,
      regBody['phoneNumber']!,
      regBody['gender']!,
      regBody['role']!,
    );

    if (result['success']) {
      print("Registration successful!");
      _showSuccessDialog();
    } else {
      print("Registration failed: ${result['message']}");
      Fluttertoast.showToast(
        msg: "Registration failed: ${result['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showSuccessDialog() {
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
                "لقد تم إنشاء حسابك بنجاح",
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // الانتقال إلى الصفحة المناسبة بناءً على الدور
                if (_role == 'user') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => homepagescreen()),
                  );
                } else if (_role == 'investor') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageScreeninvestor()),
                  );                 }
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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
            icon: Icons.person,
            hint: "اسم المستخدم",
            controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'يرجى إدخال اسم المستخدم';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            icon: Icons.email,
            hint: "البريد الإلكتروني",
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            icon: Icons.lock,
            hint: "كلمة المرور",
            controller: _passwordController,
            obscureText: _obscureTextPassword,
            toggleVisibility: () {
              setState(() {
                _obscureTextPassword = !_obscureTextPassword;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'يرجى إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'يجب أن تكون كلمة المرور مكونة من 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            icon: Icons.lock,
            hint: "تأكيد كلمة المرور",
            controller: _confirmPasswordController,
            confirmationController: _passwordController,
            obscureText: _obscureTextConfirmPassword,
            toggleVisibility: () {
              setState(() {
                _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
              });
            },
            validator: (value) {
              if (value != _passwordController.text) {
                return 'كلمة المرور غير متطابقة';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            icon: Icons.phone,
            hint: "رقم الهاتف",
            controller: _phoneController,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(),
          const SizedBox(height: 16),
          _buildUserTypeDropdown(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                registerUser(context);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
            ),
            child: Text("إنشاء حساب".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextEditingController? confirmationController,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          icon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: toggleVisibility != null
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          )
              : null,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: DropdownButtonFormField<String>(
        value: _gender,
        items: [
          DropdownMenuItem<String>(
            value: 'male',
            child: Text("ذكر"),
          ),
          DropdownMenuItem<String>(
            value: 'female',
            child: Text("أنثى"),
          ),
        ],
        decoration: InputDecoration(
          hintText: "اختر الجنس",
          icon: const Icon(Icons.person_outline),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _gender = value!;
          });
        },
      ),
    );
  }

  Widget _buildUserTypeDropdown() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: DropdownButtonFormField<String>(
        value: _role,
        items: [
          DropdownMenuItem<String>(
            value: 'user',
            child: Text("مستخدم"),
          ),
          DropdownMenuItem<String>(
            value: 'investor',
            child: Text("مستثمر"),
          ),
        ],
        decoration: InputDecoration(
          hintText: "اختر الفئة",
          icon: const Icon(Icons.group),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _role = value!;
          });
        },
      ),
    );
  }
}