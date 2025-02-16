import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../Investments/RequestFormUpdate.dart';
import '../../../../Widget/DeletionAndModificationRequestsWidget.dart';
import '../../../../Widget/investor/investorHeader.dart';
import '../../../../Widget/user_information_header.dart';
import '../../homepageinvestor/HomePageScreeninvestor.dart';
import 'MyAccount.dart';
import '../../../../Investments/Request_form.dart';

class MyInvestmentsScreen extends StatefulWidget {
  @override
  _MyInvestmentsScreenState createState() => _MyInvestmentsScreenState();
}

class _MyInvestmentsScreenState extends State<MyInvestmentsScreen> {
  String _profileImage = ''; // متغير لتخزين مسار الصورة
  final List<String> investors = [
    'حذف ',
    ' تعديل ',
    ' تعديل',
  ];
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
            UserInformationHeader(),

            Investorheader(),

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

            SizedBox(height: 10),
            _buildDeletionAndModificationRequestsContent(context),// مساحة فارغة في نهاية الصفحة
            SizedBox(height: 20),
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
  Widget _buildDeletionAndModificationRequestsContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'طلبات الحذف والتعديل',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.4),
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.2),
            },
            children: [
              _buildHeaderRow(),
              ...investors.map((name) => _buildInvestorRow(name, context)).toList(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                'نموذج الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text(
                'نوع الطلب ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildInvestorRow(String name, BuildContext context) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestFormScreen(), // استبدل بـ RequestForm()
                      ),
                    );
                  },
                  child: Text('نموذج الطلب'),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
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