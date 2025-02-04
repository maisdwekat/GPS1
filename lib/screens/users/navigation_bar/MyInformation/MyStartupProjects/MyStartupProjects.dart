import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../homepageUsers/HomePageScreenUsers.dart';
import 'AddStartupProject.dart';
import '../MyAccount.dart';
import '../MyIdeas/MyIdeas.dart';
import 'PreviewProject.dart';

class MyStartupProjectsScreen extends StatefulWidget {
  @override
  _MyStartupProjectsScreenState createState() => _MyStartupProjectsScreenState();
}

class _MyStartupProjectsScreenState extends State<MyStartupProjectsScreen> {
  String _profileImage = ''; // متغير لتخزين مسار الصورة

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path; // تحديث مسار الصورة
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
            icon: Icon(Icons.home, color: Colors.white), // أيقونة الصفحة الرئيسية
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => homepagescreen()), // استبدل بـ HomePageScreen()
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // المستطيل العلوي باللون الكحلي
            Container(
              color: Color(0xFF0A1D47),
              height: 30,
            ),
            // المستطيل الأبيض يحتوي على صورة الحساب واسم الشخص
            Container(
              color: Colors.grey[200], // لون رمادي
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر لليمين
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
                          radius: 80, // زيادة الحجم هنا
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
            // خط أفقي بين المستطيلين
            Container(
              height: 2, // ارتفاع الخط
              color: Color(0xFF0A1D47), // لون الخط
            ),
            // المستطيل الثاني باللون السكني بدون أيقونات
            Container(
              color: Colors.grey[200], // لون رمادي
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyIdeasScreen()),
                      );
                    },
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
            Container(
              height: 2, // ارتفاع الخط
              color: Color(0xFF0A1D47), // لون الخط
            ),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerRight, // محاذاة العنوان لليمين
              margin: EdgeInsets.only(right: 80.0), // بعد 80 بكسل من الجهة اليمنى
              child: Text(
                'مشاريعي الناشئة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 20), // مسافة بين العنوان والإشعارات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // مربع المشروع الجديد (إشارة الموجب) في أقصى اليمين
                Container(
                  width: 250,
                  height: 350,
                  padding: EdgeInsets.all(10),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 60,
                            color: Color(0xFF0A1D47),
                          ),
                        ),
                      ),
                      SizedBox(height: 55),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddStartupProjectScreen()),
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0A1D47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'إنشاء مشروع جديد',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                // مربع المشروع الأول (الذي يحتوي على الصورة) بجانب المشروع الجديد من جهة اليسار
                Container(
                  width: 250,
                  height: 350,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 30), // إضافة مسافة من اليمين
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
                      Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/p1 (2).jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'اسم المشروع',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'مجال المشروع',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
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
                            Container(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PreviewProjectScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0A1D47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'معاينة',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddStartupProjectScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF0A1D47),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'تعديل',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'حالة المشروع',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 100), // يمكنك تغيير القيمة حسب الحاجة

          ],
        ),
      ),
    );
  }
}