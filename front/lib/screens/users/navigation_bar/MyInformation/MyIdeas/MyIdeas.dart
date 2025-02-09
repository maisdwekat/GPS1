import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../../../Controllers/ideaController.dart';
import '../../../homepageUsers/HomePageScreenUsers.dart';
import 'AddIdea.dart';
import '../MyAccount.dart';
import '../MyStartupProjects/MyStartupProjects.dart';
import 'PreviewIdea.dart';

class MyIdeasScreen extends StatefulWidget {
  @override
  _MyIdeasScreenState createState() => _MyIdeasScreenState();
}

class _MyIdeasScreenState extends State<MyIdeasScreen> {
  final IdeaController _ideaController = IdeaController(); // إنشاء مثيل
  String _profileImage = '';
  List<Map<String, dynamic>> _ideas = []; // قائمة الأفكار

  @override
  void initState() {
    super.initState();
    ideaGet(); // جلب الأفكار عند بدء الشاشة
  }

  Future<void> ideaGet() async {
    print("ideaGet() called");

    List<Map<String, dynamic>>? ideas = await _ideaController.getAllForUser();
    if (ideas == null) {
      print("❌ فشل في جلب الأفكار!");
      setState(() {
        _ideas = []; // تعيين قائمة الأفكار إلى فارغة
      });
    } else if (ideas.isEmpty) {
      print("✅ لا توجد أفكار متاحة.");
      setState(() {
        _ideas = []; // تعيين قائمة الأفكار إلى فارغة
      });
    } else {
      print("✅ تم جلب الأفكار:");
      setState(() {
        _ideas = ideas; // تعيين الأفكار المستخرجة
      });
      for (var idea in ideas) {
        print("📌 التصنيف: ${idea['category']}, الوصف: ${idea['description']}, متاحة للجميع: ${idea['isPublic']}");
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path;
      });
    }
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
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => homepagescreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: Color(0xFF0A1D47), height: 30),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'اسم الشخص',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: _profileImage.isNotEmpty
                              ? FileImage(File(_profileImage))
                              : const AssetImage('assets/images/defaultpfp.jpg') as ImageProvider,
                          child: _profileImage.isEmpty
                              ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                              : null,
                        ),
                        const Icon(Icons.edit, color: Color(0xFF0A1D47)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: Color(0xFF0A1D47)),
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: ideaGet,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Text('أفكاري', style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyStartupProjectsScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Text('مشاريعي الناشئة', style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Text('حسابي', style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: Color(0xFF0A1D47)),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 80.0),
              child: Text(
                'أفكاري',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 20),
            // استخدام Wrap لعرض الأفكار
            Wrap(
              spacing: 10, // المسافة بين المربعات
              runSpacing: 10, // المسافة بين الصفوف
              children: [
                for (var idea in _ideas)
                  _buildIdeaCard(idea), // استخدام _ideas هنا

              ],
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaCard(Map<String, dynamic> idea) {
    print('بطاقة الفكرة: $idea'); // طباعة الفكرة للتحقق من القيم
    print('here ********************************************* is id ${idea['_id'].toString()}'); // طباعة الفكرة للتحقق من القيم

    return Container(
      width: 200, // عرض البطاقة
      height: 400, // ارتفاع البطاقة
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10, bottom: 10), // المسافة بين المربعات
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // تحديد مساحة الصورة
          Container(
            width: 100, // عرض الصورة
            height: 100, // ارتفاع الصورة
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _profileImage.isNotEmpty
                    ? FileImage(File(_profileImage))
                    : AssetImage('assets/images/defaultimg.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity, // عرض كامل
            child: Text(
              idea['category'] ?? 'غير محدد', // تأكد من استخدام المفتاح الصحيح
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity, // عرض كامل
            height: 100, // ارتفاع معين، يمكنك تغيير القيمة حسب الحاجة
            child: Text(
              idea['description'] ?? 'لا يوجد وصف', // تأكد من استخدام المفتاح الصحيح
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 150,
            height: 2,
            color: Color(0xFFE0E0E0),
          ),

          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PreviewIdeaScreen(ideaId: idea['_id'],)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A1D47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8), // تقليل ارتفاع الزر
                      ),
                      child: Text(
                        'معاينة',
                        style: TextStyle(color: Colors.white, fontSize: 10), // تصغير حجم الخط
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // إضافة مسافة بين الأزرار
                Expanded(
                  child: SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddideaScreen.toUpdate(ideaId: idea['_id'])),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0A1D47),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8), // تقليل ارتفاع الزر
                      ),
                      child: Text(
                        'تعديل',
                        style: TextStyle(color: Colors.white, fontSize: 10), // تصغير حجم الخط
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity, // عرض كامل
            child: Text(
              (idea['isPublic'] == true || idea['isPublic'] == 1) ? 'عام' : 'خاص',
              style: TextStyle(fontSize: 14, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}