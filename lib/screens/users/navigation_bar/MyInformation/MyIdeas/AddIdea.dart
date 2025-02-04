import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../Controllers/ideaController.dart';
import '../../../../../constants.dart';
import 'MyIdeas.dart';

class AddideaScreen extends StatefulWidget {
  @override
  _AddideaScreenState createState() => _AddideaScreenState();
}

class _AddideaScreenState extends State<AddideaScreen> {

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String selectedCategory = '';
  bool isPublic = false;

  void addIdea() async {
    IdeaController ideaController = IdeaController();
    var result = await ideaController.addIdea(
        descriptionController.text,
        isPublic,
        selectedCategory,
    );

    if (result != null && result['success']) {
      print("Idea added successfully!");
      _showSuccessDialog();
    } else {
      print("Failed to add idea: ${result?['message']}");
      Fluttertoast.showToast(
        msg: "Failed to add idea: ${result?['message']}",
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
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Your idea has been added successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
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
                  'إضافة فكرة',
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
                _buildLabeledTextField('شرح مبسط عن الفكرة', descriptionController, maxLength: 140, maxLines: 3),
                SizedBox(height: 10),
                Text('ما هو مجال الفكرة', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDropdownField(),
                SizedBox(height: 10),
                _buildLabeledTextField('الإيميل', emailController),
                SizedBox(height: 20),
                _buildVisibilityDropdown(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyIdeasScreen()),
                          );
                        },
                        child: Text('إلغاء'),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed:() {
                          addIdea();
                        },
                        child: Text('حفظ '),
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

  Widget _buildLabeledTextField(String label, TextEditingController controller, {int maxLines = 1, int? maxLength}) {
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
              counterText: '',
            ),
          ),
        ),
        if (maxLength != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('0/$maxLength', style: TextStyle(color: Colors.grey)),
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
            items: [
              'تعليمي',
              'تواصل اجتماعي',
              'التواصل والإعلام',
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
              'الزراعة',
              'خدمات إعلانية',
              'انترنت الأشياء',
              'الملابس',
              'الطاقة',
              'الأطفال',
              'البرنامج كخدمة',
              'ذكاء اصطناعي',
              'تعليم الآلة',
              'خدمات منزلية',
              'ألعاب',
              'التمويل الجماعي',
              'هدايا',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              selectedCategory = value ?? '';
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('هل تود مشاركة الفكرة بشكل عام أم تفضل الاحتفاظ بها خاصة؟', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem<String>(
                value: 'خاص',
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('خاص'),
                ),
              ),
              DropdownMenuItem<String>(
                value: 'عام',
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('عام'),
                ),
              ),
            ],
            onChanged: (value) {
              isPublic = value == 'عام';
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    emailController.dispose();
    super.dispose();
  }
}