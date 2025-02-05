import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart'; // Import GetX
import 'package:intl/intl.dart';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../../constants.dart';
import 'CreateBusinessPlan.dart'; // تأكد من استيراد الصفحة التالية
import 'dart:html' as html; // For web
class AddStartupProjectScreen extends StatefulWidget {
  @override
  _AddStartupProjectScreenState createState() => _AddStartupProjectScreenState();
}

class _AddStartupProjectScreenState extends State<AddStartupProjectScreen> {
  String? selectedCity; // متغير لتخزين المدينة المختارة
  String? selectedProjectField; // لتخزين مجال المشروع
  String? selectedStage; // لتخزين المرحلة الحالية
  bool? selectedVisibility; // لتخزين الرؤية (خاص = false / عام = true)

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? creationDate; // لتخزين تاريخ الإنشاء (يمكن أن يكون نصًا)
  String? isoDate;  // لتخزين التاريخ بالتنسيق المطلوب
  DateTime dateTime = DateTime.now();
  final TextEditingController _shortDescriptionController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  int shortDescriptionLength = 0;
  int summaryLength = 0;

  // استدعاء ProjectController
  final ProjectController projectController = Get.put(ProjectController());

  @override
  void initState() {
    super.initState();
    projectController.getToken(); // استدعاء الدالة للحصول على التوكن
    _shortDescriptionController.addListener(() {
      setState(() {
        shortDescriptionLength = _shortDescriptionController.text.length;
      });
    });
    _summaryController.addListener(() {
      setState(() {
        summaryLength = _summaryController.text.length;
      });
    });
  }
  final ImagePicker _picker = ImagePicker();
  String? imagePath; // تأكد من أن لديك قيمة لمتغير imagePath

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path; // Store the selected image path
      });
      print('تم اختيار الصورة: ${image.path}');
    }
  }

  Future<void> sendDataToBackend() async {
    ProjectController projectController =ProjectController();
    try {
      String? tokenValue = await projectController.getToken();
      var request = http.MultipartRequest('POST', Uri.parse('${projectController.baseUrl}/add'));
      request.headers.addAll({
        'token': 'token__$tokenValue',
      });

      request.fields['title'] = _projectNameController.text;
      request.fields['description'] = _shortDescriptionController.text;
      request.fields['current_stage'] = selectedStage ?? '';
      request.fields['isPublic'] = selectedVisibility != null ? (selectedVisibility! ? 'عام' : 'خاص') : '';
      request.fields['location'] = selectedCity ?? '';
      request.fields['category'] = selectedProjectField ?? '';
      request.fields['website'] = _websiteController.text;
      request.fields['email'] = _emailController.text;
      request.fields['summary'] = _summaryController.text;
      request.fields['date'] = creationDate ?? '';


      print('اسم المشروع: ${_projectNameController.text}');
      print('الوصف: ${_shortDescriptionController.text}');
      print('المرحلة الحالية: $selectedStage');
      print('الرؤية: ${selectedVisibility}');
      print('المدينة: $selectedCity');
      print('مجال المشروع: $selectedProjectField');
      print('الموقع الإلكتروني: ${_websiteController.text}');
      print('الإيميل: ${_emailController.text}');
      print('الملخص: ${_summaryController.text}');
      print('تاريخ الإنشاء: $creationDate');
      print('مسار الصورة: $imagePath');
      print('التوكن: $tokenValue');

      if (imagePath != null) {
        var imageFile = File(imagePath!); // تحويل المسار إلى كائن ملف
        var multipartFile = await http.MultipartFile.fromPath(
          'image', // نفس اسم المفتاح المطلوب في الباك
          imageFile.path,
        );
        request.files.add(multipartFile);
        // إذا كانت الصورة موجودة
        // var imageFile = File(imagePath!);
        // var imageStream = http.ByteStream(imageFile.openRead());
        // var imageLength = await imageFile.length();
        //
        // var multipartFile = http.MultipartFile(
        //   'image', // نفس اسم المفتاح الذي يحتاجه الـ backend
        //   imageStream,
        //   imageLength,
        //   filename: imageFile.path.split('/').last,
        // );
        //
        // request.files.add(multipartFile);
      } else {
        print('الصورة غير موجودة');
      }

      // إرسال الطلب
      final response = await request.send();
      final responseBody = await response.stream.bytesToString(); // تحويل الاستجابة إلى نص
      final responseData = json.decode(responseBody); // تحويل النص إلى JSON

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: $responseData");

      if (response.statusCode == 200 && responseData['message'] == "تمت الاضافة بنجاخ") {
        print('تم إرسال البيانات بنجاح!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateBusinessPlanScreen()),
        );
      } else {
        print('فشل في إرسال البيانات: ${responseData['message'] ?? response.reasonPhrase}');
        Fluttertoast.showToast(
          msg: "فشل في إرسال البيانات: ${responseData['message'] ?? 'خطأ غير معروف'}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('حدث خطأ: $e');
      Fluttertoast.showToast(
        msg: "حدث خطأ أثناء الإرسال: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إضافة مشروع ناشئ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
                Text(
                  'تنويه: جميع الحقول مطلوبة حتى يتم نشر المشروع',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
                _buildLabeledTextField('اسم المشروع', controller: _projectNameController, maxLines: 1),
                SizedBox(height: 10),
                Text('ما هو مجال المشروع', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDropdownField(),
                SizedBox(height: 10),
                Text('تاريخ إنشاء المشروع', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 120, child: _buildDateInputField()),
                  ],
                ),
                SizedBox(height: 10),
                Text('اختر المدينة', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                _buildCityDropdown(),
                SizedBox(height: 10),
                SizedBox(height: 20),
                Text('المرحلة الحالية للمشروع', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                _buildStageDropdownField(),
                SizedBox(height: 10),
                SizedBox(height: 30),
                _buildLabeledTextField('شرح مبسط عن المشروع', maxLength: 140, maxLines: 3, controller: _shortDescriptionController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('$shortDescriptionLength/140', style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 20),
                _buildLabeledTextField('الموقع الإلكتروني', controller: _websiteController, maxLines: 1),
                SizedBox(height: 30),
                _buildLabeledTextField('الإيميل', controller: _emailController, maxLines: 1),
                SizedBox(height: 20),
                Text('أضف صورة لمشروعك', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                Image.asset("assets/images/defaultpfp.jpg"),
                SizedBox(height: 10),
                _buildImageUploadField(),
                SizedBox(height: 30),
                _buildVisibilityDropdown(),
                _buildLabeledTextField('ملخص عن المشروع', maxLines: 5, maxLength: 2000, controller: _summaryController),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('$summaryLength/2000', style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('إلغاء'),
                      ),
                    ),
                    // SizedBox(
                    //   width: 150,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //     },
                    //     child: Text('حفظ'),
                    //   ),
                    // ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          sendDataToBackend(); // استدعاء دالة إرسال البيانات
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateBusinessPlanScreen()), // الانتقال إلى صفحة BMC
                          );
                        },
                        child: Text('التالي'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: selectedCity,
            items: [
              'نابلس',
              'جنين',
              'قلقيلية',
              'رام الله',
              'طولكرم',
            ].map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCity = value; // تخزين المدينة المختارة
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(String label, {int maxLines = 1, int? maxLength, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              counterText: '', // Hide default counter
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: selectedProjectField,
            items: [
              'تعليمي',
              'تواصل اجتماعي',
              'تواصل وإعلام',
              'تجارة إلكترونية',
              'مالي وخدمات الدفع',
              'موسيقى وترفيه',
              'أمن إلكتروني',
              'صحة',
              'نقل وتوصيل',
              'تصنيع',
              'منصة إعلانية',
              'تسويق إلكتروني',
              'محتوى',
              'زراعة',
              'خدمات إعلانية',
              'إنترنت الأشياء',
              'ملابس',
              'طاقة',
              'أطفال',
              'برنامج كخدمة (SaaS)',
              'ذكاء اصطناعي',
              'تعليم آلة',
              'خدمات منزلية',
              'ألعاب',
              'تمويل جماعي',
              'هدايا',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedProjectField = value; // تخزين مجال المشروع
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStageDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: selectedStage,
            items: [
              'مرحلة دراسة الفكرة',
              'مرحلة التحقق والتخطيط',
              'مرحلة التمويل والتأمين',
              'مرحلة تأسيس الفريق والموارد',
              'مرحلة الإطلاق والنمو',
            ].map((String stage) {
              return DropdownMenuItem<String>(
                value: stage,
                child: Text(stage),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedStage = value; // تخزين المرحلة الحالية
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('تاريخ إنشاء المشروع (YYYY-MM-DD)',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              // Validate if the input is in the format YYYY-MM-DD
              RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
              if (value.isNotEmpty && regExp.hasMatch(value)) {
                setState(() {
                  creationDate = value; // Store the valid date
                });
                print('تم اختيار تاريخ صالح: $creationDate');
                // DateTime dateTime = DateFormat('yyyy-MM-dd').parse(value);
                // String isoDate = dateTime.toUtc().toIso8601String();
                // dateTime = DateTime.parse(value);  // تحديث dateTime بالقيمة المدخلة
                // isoDate = dateTime.toUtc().toIso8601String().replaceAll('Z', '+00:00');
                // print('تم اختيار تاريخ صالح: $isoDate');

              } else {
                // Optionally show an error message or handle invalid input
                print('Invalid date format. Please use YYYY-MM-DD.');
              }
            },
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '2025-01-20', // Example hint
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadField() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: imagePath == null
            ? Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey,
            size: 50,
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(8),
          // child: kIsWeb
          //     ? FutureBuilder<Uint8List>(
          //   future: _convertFileToBytes(imagePath!),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          //       return Image.memory(snapshot.data!, fit: BoxFit.cover);
          //     } else {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //   },
          // )
          //     : Image.file(
          //   File(imagePath!),
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }

// دالة لتحويل الملف إلى Uint8List لعرضه في الويب
//   Future<Uint8List> _convertFileToBytes(String path) async {
//     File file = File(path);
//     return await file.readAsBytes();
//   }

  Widget _buildVisibilityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('هل ترغب في جعل المشروع خاصًا أم عامًا؟', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<bool>(
            value: selectedVisibility,
            items: [
              DropdownMenuItem<bool>(
                value: false, // خاص
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('خاص'),
                ),
              ),
              DropdownMenuItem<bool>(
                value: true, // عام
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('عام'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedVisibility = value; // تخزين الرؤية
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}