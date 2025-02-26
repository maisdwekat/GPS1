import 'package:flutter/material.dart';

import '../../../../Controllers/token_controller.dart';
import '../../../../Widget/user_information_header.dart';
import '../../../../constants.dart';
import '../../homepageUsers/HomePageScreenUsers.dart';
import 'MyIdeas/MyIdeas.dart';
import 'MyStartupProjects/MyStartupProjects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // New phone controller
  String _gender = 'male';
  TokenController token = TokenController();

  Future<void> _fetchUserData() async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      //return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';

    try {
      final response = await http.get(
        Uri.parse('http://$ip:4000/api/v1/auth/getAccount'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var userData = data['user'];
        print(" $data");
        setState(() {
          _fullNameController.text =
              userData['name'] ?? ''; // الآن نصل إلى name داخل 'user'
          _emailController.text =
              userData['email'] ?? ''; // الوصول إلى email داخل 'user'
          _birthDateController.text =
              '2020'; // يمكنك تعديل هذا كما تراه مناسباً
          _gender =
              userData['gender'] ?? 'male'; // الوصول إلى gender داخل 'user'
          _phoneController.text = userData['phoneNumber'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في جلب بيانات المستخدم')),
        );
      }
    } catch (error) {
      print('Error: $error');
      //return {'success': false, 'message': "An error occurred"};
    }
  }

  Future<void> _updateUserData() async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      //return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    try {
      final response = await http.patch(
        Uri.parse('http://$ip:4000/api/v1/auth/updateUserInfo'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
        body: json.encode({
          'name': _fullNameController.text,
          'email': _emailController.text,
          // 'birthDate': _birthDateController.text,
          'phoneNumber': _phoneController.text, // Sending phone
          'gender': _gender,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث البيانات بنجاح')),
        );
      } else {
        print("Failed Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحديث البيانات')),
        );
      }
    } catch (error) {
      print('Error: $error');
      //return {'success': false, 'message': "An error occurred"};
    }
  }

  void _goToEditPassword() {
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
            icon: Icon(Icons.home, color: Colors.white),
            // أيقونة الصفحة الرئيسية
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        homepagescreen()), // استبدل بـ HomePageScreen()
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            UserInformationHeader(),
            _buildHorizontalLine(),
            _buildNavigationBar(),
            _buildHorizontalLine(),
            SizedBox(height: 40),
            _buildProfileInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF0A1D47),
      height: 30,
    );
  }

  Widget _buildHorizontalLine() {
    return Container(
      height: 2,
      color: Color(0xFF0A1D47),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      color: Colors.grey[200],
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('أفكاري', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyIdeasScreen()));
          }),
          _buildNavItem('مشاريعي الناشئة', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyStartupProjectsScreen()));
          }),
          _buildNavItem('حسابي', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Text(title, style: TextStyle(color: Color(0xFF001F3F))),
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Container(
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
          _buildEditableRow('البريد الإلكتروني', Icons.edit, _emailController),
          SizedBox(height: 10),
          _buildGenderDropdown(),
          SizedBox(height: 10),
          _buildEditableRow('رقم الهاتف', Icons.phone, _phoneController),
          // New phone field
          SizedBox(height: 10),
          _buildEditableRowWithNavigation('كلمة المرور', Icons.edit,
              _passwordController, _goToEditPassword),
          SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEditableRow(
      String title, IconData icon, TextEditingController controller) {
    return _buildRowWithIcon(title, icon, controller, false);
  }

  Widget _buildEditableRowWithNavigation(String title, IconData icon,
      TextEditingController controller, VoidCallback onPressed) {
    return _buildRowWithIcon(title, icon, controller, true, onPressed);
  }

  Widget _buildRowWithIcon(String title, IconData icon,
      TextEditingController controller, bool isReadOnly,
      [VoidCallback? onPressed]) {
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
                      readOnly: isReadOnly,
                      decoration: InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(icon, color: Color(0xFF0A1D47)),
                  onPressed: onPressed ?? () {},
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
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
                DropdownMenuItem(value: 'male', child: Text('male')),
                DropdownMenuItem(value: 'female', child: Text('female')),
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

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        _updateUserData();
      },
      child: Text('حفظ التعديلات'),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300, 50),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        backgroundColor: Color(0xFF0A1D47),
      ),
    );
  }
}

class EditPasswordPage extends StatefulWidget {
  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('كلمات المرور الجديدة لا تتطابق')),
      );
      return;
    }

    final response = await http.put(
      Uri.parse('https://your-backend-url.com/api/user/change-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'currentPassword': _currentPasswordController.text,
        'newPassword': _newPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تغيير كلمة المرور')),
      );
    }
  }

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
                _buildPasswordField(
                    'كلمة المرور الحالية',
                    _currentPasswordController,
                    _isCurrentPasswordVisible, (value) {
                  setState(() {
                    _isCurrentPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                _buildPasswordField('كلمة المرور الجديدة',
                    _newPasswordController, _isNewPasswordVisible, (value) {
                  setState(() {
                    _isNewPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                _buildPasswordField(
                    'تأكيد كلمة المرور',
                    _confirmPasswordController,
                    _isConfirmPasswordVisible, (value) {
                  setState(() {
                    _isConfirmPasswordVisible = value;
                  });
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePassword,
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

  Widget _buildPasswordField(String title, TextEditingController controller,
      bool isVisible, Function(bool) onVisibilityChanged) {
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
