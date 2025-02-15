import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/screens/users/homepageUsers/HomePageScreenUsers.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:get/get.dart'; // Import GetX
import 'package:intl/intl.dart';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../../constants.dart';
import 'CreateBusinessPlan.dart'; // تأكد من استيراد الصفحة التالية
import 'dart:html' as html; // For web
import 'package:http_parser/http_parser.dart';
class AddStartupProjectScreen extends StatefulWidget {
  bool toUpdate = false;
  String? projectID ;

  AddStartupProjectScreen({super.key});
  AddStartupProjectScreen.toUpdate({super.key,this.toUpdate=true,required this.projectID});
  @override
  _AddStartupProjectScreenState createState() =>
      _AddStartupProjectScreenState();
}

class _AddStartupProjectScreenState extends State<AddStartupProjectScreen> {
  String? selectedCity; // متغير لتخزين المدينة المختارة
  String? selectedProjectField; // لتخزين مجال المشروع
  String? selectedStage; // لتخزين المرحلة الحالية
  bool? selectedVisibility; // لتخزين الرؤية (خاص = false / عام = true)

  final TextEditingController titleController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? creationDate; // لتخزين تاريخ الإنشاء (يمكن أن يكون نصًا)
  String? isoDate; // لتخزين التاريخ بالتنسيق المطلوب
  DateTime dateTime = DateTime.now();
  final TextEditingController shortDescriptionController =
      TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  int shortDescriptionLength = 0;
  int summaryLength = 0;

  // استدعاء ProjectController
  final TokenController token = TokenController();
  getdata() async {
    var data = await ProjectController().getByIdForUser(widget.projectID!);
    setState(() {
      titleController.text = data!['title'];
      websiteController.text = data['website'];
      emailController.text = data['email'];
      shortDescriptionController.text = data['description'];
      summaryController.text = data['summary'];
      creationDate = data['date'];
      selectedCity = data['location'];
      selectedProjectField = data['category'];
      selectedStage = data['current_stage'];
      selectedVisibility = data['isPublic'];
      imagePath = data['image'];
    });
    print(data);
  }

  @override
  void initState() {
    super.initState();
    if(widget.toUpdate){
      getdata();
    }else{}
    shortDescriptionController.addListener(() {
      setState(() {
        shortDescriptionLength = shortDescriptionController.text.length;
      });
    });
    summaryController.addListener(() {
      setState(() {
        summaryLength = summaryController.text.length;
      });
    });
  }
  final formKey=GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? imagePath; // Path of the selected image
  Uint8List imageBytes = Uint8List(0); // Bytes of the selected image
  http.MultipartFile? imageFile; // Multipart file for the image

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web-specific file picking
      final input = html.FileUploadInputElement();
      input.accept = 'image/*'; // Restrict to image files
      input.click();

      input.onChange.listen((event) async {
        final file = input.files!.first; // Get the selected file
        print("📂 File selected (Web): ${file.name}");
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) async {
          setState(() {
            imageBytes = reader.result as Uint8List; // Store image bytes
            imagePath = file.name; // Store file name as path
          });

          // Create MultipartFile for the image
          imageFile = http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: file.name,
            contentType: MediaType('image', 'png'),
          );
          print("📂 Image file created for Web with size: ${imageBytes.length} bytes");
        });

        reader.readAsArrayBuffer(file); // Read the file as bytes
      });
    } else {
      // Mobile-specific file picking
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imagePath = image.path; // Store image path
        });

        final bytes = await image.readAsBytes();
        setState(() {
          imageBytes = bytes; // Store image bytes
        });

        // Create MultipartFile for the image
        imageFile = await http.MultipartFile.fromPath('image', image.path);
      }
    }
  }

  // Future<void> sendDataToBackend() async {
  //   ProjectController projectController =ProjectController();
  //   try {
  //     String? tokenValue = await token.getToken();
  //     var request = http.MultipartRequest('POST', Uri.parse('${projectController.baseUrl}/add'));
  //     request.headers.addAll({
  //       'token': 'token__$tokenValue',
  //     });
  //
  //     request.fields['title'] = _projectNameController.text;
  //     request.fields['description'] = _shortDescriptionController.text;
  //     request.fields['current_stage'] = selectedStage ?? '';
  //     request.fields['isPublic'] = selectedVisibility != null ? (selectedVisibility! ? 'عام' : 'خاص') : '';
  //     request.fields['location'] = selectedCity ?? '';
  //     request.fields['category'] = selectedProjectField ?? '';
  //     request.fields['website'] = _websiteController.text;
  //     request.fields['email'] = _emailController.text;
  //     request.fields['summary'] = _summaryController.text;
  //     request.fields['date'] = creationDate ?? '';
  //
  //
  //     print('اسم المشروع: ${_projectNameController.text}');
  //     print('الوصف: ${_shortDescriptionController.text}');
  //     print('المرحلة الحالية: $selectedStage');
  //     print('الرؤية: ${selectedVisibility}');
  //     print('المدينة: $selectedCity');
  //     print('مجال المشروع: $selectedProjectField');
  //     print('الموقع الإلكتروني: ${_websiteController.text}');
  //     print('الإيميل: ${_emailController.text}');
  //     print('الملخص: ${_summaryController.text}');
  //     print('تاريخ الإنشاء: $creationDate');
  //     print('مسار الصورة: $imagePath');
  //     print('التوكن: $tokenValue');
  //
  //     if (imagePath != null) {
  //       var imageFile = File(imagePath!); // تحويل المسار إلى كائن ملف
  //       var multipartFile = await http.MultipartFile.fromPath(
  //         'image', // نفس اسم المفتاح المطلوب في الباك
  //         imageFile.path,
  //       );
  //       request.files.add(multipartFile);
  //       // إذا كانت الصورة موجودة
  //       var imageStream = http.ByteStream(imageFile.openRead());
  //       var imageLength = await imageFile.length();
  //
  //       http.MultipartFile(
  //         'image', // نفس اسم المفتاح الذي يحتاجه الـ backend
  //         imageStream,
  //         imageLength,
  //         filename: imageFile.path.split('/').last,
  //       );
  //
  //       request.files.add(multipartFile);
  //     } else {
  //       print('الصورة غير موجودة');
  //     }
  //
  //     // إرسال الطلب
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString(); // تحويل الاستجابة إلى نص
  //     final responseData = json.decode(responseBody); // تحويل النص إلى JSON
  //
  //     print("Response Status Code: ${response.statusCode}");
  //     print("Response Body: $responseData");
  //
  //     if (response.statusCode == 200 && responseData['message'] == "تمت الاضافة بنجاخ") {
  //       print('تم إرسال البيانات بنجاح!');
  //
  //     } else {
  //       print('فشل في إرسال البيانات: ${responseData['message'] ?? response.reasonPhrase}');
  //       Fluttertoast.showToast(
  //         msg: "فشل في إرسال البيانات: ${responseData['message'] ?? 'خطأ غير معروف'}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     }
  //   } catch (e) {
  //     print('حدث خطأ: $e');
  //     Fluttertoast.showToast(
  //       msg: "حدث خطأ أثناء الإرسال: $e",
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }
  // }
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Form(
          key:formKey ,
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
                  _buildLabeledTextField('اسم المشروع',
                      controller: titleController, maxLines: 1),
                  SizedBox(height: 10),
                  Text('ما هو مجال المشروع',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildDropdownField(),
                  SizedBox(height: 10),
                  Text('تاريخ إنشاء المشروع',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(width: 120, child: _buildDateInputField()),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('اختر المدينة',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildCityDropdown(),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Text('المرحلة الحالية للمشروع',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildStageDropdownField(),
                  SizedBox(height: 10),
                  SizedBox(height: 30),
                  _buildLabeledTextField('شرح مبسط عن المشروع',
                      maxLength: 140,
                      maxLines: 3,
                      controller: shortDescriptionController),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$shortDescriptionLength/140',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField('الموقع الإلكتروني',
                      controller: websiteController, maxLines: 1),
                  SizedBox(height: 30),
                  _buildLabeledTextField('الإيميل',
                      controller: emailController, maxLines: 1,validation:(value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },),
                  SizedBox(height: 20),
                  widget.toUpdate?SizedBox():Text('أضف صورة لمشروعك',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  widget.toUpdate?_buildImageToUpdate() as Widget:_buildImageUploadField() as Widget,
                  SizedBox(height: 30),
                  // _buildVisibilityDropdown(),
                  _buildLabeledTextField('ملخص عن المشروع',
                      maxLines: 5,
                      maxLength: 2000,
                      controller: summaryController,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$summaryLength/2000',
                        style: TextStyle(color: Colors.grey)),
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
                          onPressed: () async {
                            ProjectController projectController = ProjectController();

                            // استدعاء الدالة والحصول على النتيجة
                               if(formKey.currentState!.validate()) {
                              if (widget.toUpdate) {
                                dynamic res =
                                    await projectController.updateproject(
                                  widget.projectID!,
                                  titleController.text,
                                  shortDescriptionController.text,
                                  selectedStage!,
                                  selectedVisibility ?? true,
                                  selectedCity!,
                                  selectedProjectField!,
                                  websiteController.text,
                                  emailController.text,
                                  summaryController.text,
                                  dateTime.toString(),
                                );
                                if (res['message'] == 'Success') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => homepagescreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  print('خطأ: ${res['message']}');
                                }
                              } else {
                                Map<String, dynamic> response =
                                    await projectController.addProject(
                                  title: titleController.text,
                                  description: shortDescriptionController.text,
                                  current_stage: selectedStage!,
                                  isPublic: selectedVisibility ?? true,
                                  location: selectedCity!,
                                  category: selectedProjectField!,
                                  website: websiteController.text,
                                  email: emailController.text,
                                  summary: summaryController.text,
                                  date: dateTime.toString(),
                                  imageFile: imageFile!,
                                );

                                // التحقق مما إذا كانت العملية ناجحة
                                if (response['success'] == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateBusinessPlanScreen(
                                              id: response['data']['project']
                                                  ['_id'],
                                            )),
                                  );
                                } else {}
                              }
                            }
                          },
                          child: Text(widget.toUpdate?'حفظ':'التالي'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

  Widget _buildLabeledTextField(String label,
      {int maxLines = 1, int? maxLength, TextEditingController? controller ,var validation}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
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
          child: TextFormField(
            validator: validation,
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
              'الصحة',
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
            controller: dateController,
            onChanged: (value) {
              // // Validate if the input is in the format YYYY-MM-DD
              // RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
              // if (value.isNotEmpty && regExp.hasMatch(value)) {
              //   setState(() {
              //     creationDate = value; // Store the valid date
              //   });
              //   print('تم اختيار تاريخ صالح: $creationDate');
              //   // DateTime dateTime = DateFormat('yyyy-MM-dd').parse(value);
              //   // String isoDate = dateTime.toUtc().toIso8601String();
              //   // dateTime = DateTime.parse(value);  // تحديث dateTime بالقيمة المدخلة
              //   // isoDate = dateTime.toUtc().toIso8601String().replaceAll('Z', '+00:00');
              //   // print('تم اختيار تاريخ صالح: $isoDate');
              // } else {
              //   // Optionally show an error message or handle invalid input
              //   print('Invalid date format. Please use YYYY-MM-DD.');
              // }
            },
            readOnly: true,
            onTap: () {
               showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  setState(() {
                    creationDate =selectedDate.toString();
                    dateController.text = dateFormater(selectedDate);
                    
                  });
                }
              }
              );
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
            child: Image.memory(imageBytes, fit: BoxFit.cover),
          ),
        ));
  }
  Widget _buildImageToUpdate() {
    return Container(
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
        child: Image.network(imagePath!, fit: BoxFit.cover),
      ),
    );
  }

// دالة لتحويل الملف إلى Uint8List لعرضه في الويب

  Widget _buildVisibilityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('هل ترغب في جعل المشروع خاصًا أم عامًا؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold)),
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
