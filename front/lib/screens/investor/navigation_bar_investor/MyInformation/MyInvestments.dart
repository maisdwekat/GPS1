import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../Investments/RequestFormUpdate.dart';
import '../../homepageinvestor/HomePageScreeninvestor.dart';
import 'MyAccount.dart';
import '../../../../Investments/Request_form.dart';

class MyInvestmentsScreen extends StatefulWidget {
  @override
  _MyInvestmentsScreenState createState() => _MyInvestmentsScreenState();
}

class _MyInvestmentsScreenState extends State<MyInvestmentsScreen> {
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
            Container(
              color: Colors.grey[200], // لون رمادي
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
            Container(
              height: 2,
              color: Color(0xFF0A1D47),
            ),
            Container(
              color: Colors.grey[200], // لون رمادي
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavButton(context, 'استثماراتي',MyInvestmentsScreen ()),
                  _buildNavButton(context, 'حسابي', ProfileScreeninvestor()),
                ],
              ),
            ),
            Container(
              height: 2,
              color: Color(0xFF0A1D47),
            ),
            SizedBox(height: 20),

            // عنوان الجداول
            Text(
              'الاستثمارات الحالية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),

            // عرض جدول الاستثمارات الحالية
            _buildCurrentInvestmentsTable(),

            SizedBox(height: 20),

            // عنوان طلبات الاستثمار
            Text(
              'طلبات الاستثمار',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 10),

            // عرض جدول طلبات الاستثمار
            _buildInvestmentRequestsTable(),

            SizedBox(height: 40), // مساحة فارغة في نهاية الصفحة
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
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

  Widget _buildCurrentInvestmentsTable() {
    return Container(
      padding: EdgeInsets.all(10),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('إجراءات', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('نموذج الطلب', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('نموذج الاستثمار', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('اسم المشروع', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // الانتقال إلى صفحة نموذج التعديل
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestFormUpdateScreen()), // استبدل بـ EditInvestmentForm()
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // إظهار إشعار تأكيد الحذف
                    _showDeleteConfirmationDialog(context, 'مشروع 1');
                  },
                ),
              ],
            )),
            DataCell(_buildButton('الطلب', () {
              // الانتقال إلى صفحة نموذج الطلب
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestFormScreen()), // استبدل بـ RequestForm()
              );
            })),
            DataCell(_buildButton('الاستثمار', () {
              // منطق نموذج الاستثمار
            })),
            DataCell(Text('مشروع 1')),
          ]),
          DataRow(cells: [
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // الانتقال إلى صفحة نموذج التعديل
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestFormUpdateScreen()), // استبدل بـ EditInvestmentForm()
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // إظهار إشعار تأكيد الحذف
                    _showDeleteConfirmationDialog(context, 'مشروع 2');
                  },
                ),
              ],
            )),
            DataCell(_buildButton('الطلب', () {
              // الانتقال إلى صفحة نموذج الطلب
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestFormScreen()), // استبدل بـ RequestForm()
              );
            })),
            DataCell(_buildButton('الاستثمار', () {
              // منطق نموذج الاستثمار
            })),
            DataCell(Text('مشروع 2')),
          ]),
        ],
      ),
    );
  }

// دالة لإظهار إشعار تأكيد الحذف
  void _showDeleteConfirmationDialog(BuildContext context, String projectName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل تريد حذف الاستثمار التالي: $projectName؟'),
          actions: [
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
              },
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () {
                // منطق الحذف هنا
                Navigator.of(context).pop(); // إغلاق الحوار بعد الحذف
              },
            ),
          ],
        );
      },
    );
  }
  List<String> projects = ['مشروع A', 'مشروع B'];


  Widget _buildInvestmentRequestsTable() {
    return Container(
      padding: EdgeInsets.all(10),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('إجراءات', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('نموذج الطلب', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('نموذج الاستثمار', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('اسم المشروع', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: projects.map((project) {
          return DataRow(cells: [
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // الانتقال إلى صفحة نموذج التعديل
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestFormUpdateScreen()), // استبدل بـ EditInvestmentForm()
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // حذف السطر مباشرة
                    setState(() {
                      projects.remove(project);
                    });
                  },
                ),
              ],
            )),
            DataCell(_buildButton('الطلب', () {
              // الانتقال إلى صفحة نموذج الطلب
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestFormScreen()), // استبدل بـ RequestForm()
              );
            })),
            DataCell(_buildButton('الاستثمار', () {
              // منطق نموذج الاستثمار
            })),
            DataCell(Text(project)),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPressed) {
    return Container(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0A1D47),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // زوايا دائرية
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}