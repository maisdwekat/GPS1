import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Widget/investor/investorHeader.dart';
import '../../../../Widget/user_information_header.dart';
import '../../homepageinvestor/HomePageScreeninvestor.dart';
import 'MyInvestments.dart';

class ProfileScreeninvestor extends StatefulWidget {
  const ProfileScreeninvestor({super.key});

  @override
  _ProfileScreeninvestorState createState() => _ProfileScreeninvestorState();
}

class _ProfileScreeninvestorState extends State<ProfileScreeninvestor> {
  String _profileImage = '';
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _gender = 'ذكر';
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _birthDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void _goToEditPassword() {
    // هنا يمكنك استبدال EditPasswordPage بصفحتك الخاصة
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white), // أيقونة الصفحة الرئيسية
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageScreeninvestor()), // استبدل بـ HomePageScreen()
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xFF0A1D47),
              height: 30,
            ),
            UserInformationHeader(),
            Investorheader(),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 80.0),
              child: Text(
                'حسابي',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              width: 700,
              color: Colors.grey[200],
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.only(top: 40, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'معلومات الحساب',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  _buildEditableRow('الاسم الكامل', Icons.edit, _fullNameController),
                  SizedBox(height: 10),
                  _buildGenderDropdown(),
                  SizedBox(height: 10),
                  _buildEditableRow('البريد الإلكتروني', Icons.edit, _emailController),
                  SizedBox(height: 10),
                  _buildBirthDateRow(),
                  SizedBox(height: 10),
                  _buildEditableRowWithNavigation('كلمة المرور', Icons.edit, _passwordController, _goToEditPassword),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePageScreeninvestor()),
                      );
                    },
                    child: Text('حفظ التعديلات'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 50),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      backgroundColor: Color(0xFF0A1D47),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(String title, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 300,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF0A1D47)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(icon, color: Color(0xFF0A1D47)),
                  onPressed: () {
                    // هنا يمكنك إضافة أي وظيفة إضافية عند الضغط على الأيقونة
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableRowWithNavigation(String title, IconData icon, TextEditingController controller, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 300,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF0A1D47)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: controller,
                      readOnly: true, // يجعل الحقل غير قابل للتحرير
                      decoration: InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(icon, color: Color(0xFF0A1D47)),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBirthDateRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'تاريخ الميلاد',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 300,
          child: GestureDetector(
            onTap: () => _selectBirthDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF0A1D47)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextField(
                        controller: _birthDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Color(0xFF0A1D47)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'الجنس',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 300,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF0A1D47)),
            ),
            child: DropdownButtonFormField<String>(
              value: _gender,
              items: [
                DropdownMenuItem(value: 'ذكر', child: Text('ذكر')),
                DropdownMenuItem(value: 'أنثى', child: Text('أنثى')),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }


}

// تأكد من إضافة صفحة EditPasswordPage في مشروعك
class EditPasswordPage extends StatefulWidget {
  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تغيير كلمة المرور"),
        backgroundColor: Color(0xFF0A1D47),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'تغيير كلمة المرور',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildEditableRow('كلمة المرور الحالية', _currentPasswordController, _isCurrentPasswordVisible, (value) {
                  setState(() {
                    _isCurrentPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                _buildEditableRow('كلمة المرور الجديدة', _newPasswordController, _isNewPasswordVisible, (value) {
                  setState(() {
                    _isNewPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                _buildEditableRow('تأكيد كلمة المرور', _confirmPasswordController, _isConfirmPasswordVisible, (value) {
                  setState(() {
                    _isConfirmPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // هنا يمكنك إضافة منطق حفظ التعديلات
                    Navigator.pop(context); // العودة إلى الصفحة السابقة
                  },
                  child: Text('حفظ التعديلات'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 50),
                    backgroundColor: Color(0xFF0A1D47),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String title, TextEditingController controller, bool isVisible, Function(bool) onVisibilityChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 300,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF0A1D47)),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF0A1D47),
                  ),
                  onPressed: () {
                    onVisibilityChanged(!isVisible);
                  },
                ),
              ),
              obscureText: !isVisible,
            ),
          ),
        ),
      ],
    );
  }
}