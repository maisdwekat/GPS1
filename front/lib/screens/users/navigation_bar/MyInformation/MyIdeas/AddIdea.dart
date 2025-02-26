import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ggg_hhh/screens/users/homepageUsers/HomePageScreenUsers.dart';
import '../../../../../Controllers/ideaController.dart';
import '../../../../../constants.dart';

List<String> categories = [
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
];

class AddideaScreen extends StatefulWidget {
  bool toUpdate = false;
  String? ideaId;
  bool isLoading = true;

  AddideaScreen({Key? key}) : super(key: key);

  AddideaScreen.toUpdate({Key? key, this.toUpdate = true, required this.ideaId})
      : super(key: key);

  @override
  _AddideaScreenState createState() => _AddideaScreenState();
}

class _AddideaScreenState extends State<AddideaScreen> {
  final TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  bool isPublic = false;
  IdeaController ideaController = IdeaController();

  getIdeaDataToUpdate() async {
    var result = await ideaController.getIdea(widget.ideaId.toString());
    descriptionController.text = result!['description'].toString();
    selectedCategory = result['category'];
    isPublic = result['isPublic'];
    setState(() {
      widget.isLoading = false;
    });
    print(result);
  }

  getIdeaDataToAdd() async {
    descriptionController.text = '';
    selectedCategory = categories.first;
    isPublic = false;
    setState(() {
      widget.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.toUpdate == true) {
      getIdeaDataToUpdate();
    } else {
      selectedCategory = categories.first;
      isPublic = false;
      getIdeaDataToAdd();
    }
  }

  void updateIdea() async {
    IdeaController ideaController = IdeaController();
    var result = await ideaController.updateIdea(descriptionController.text,
        isPublic, selectedCategory!, widget.ideaId.toString());
    if (result != null) {
      print("Idea updated successfully!");
      _showSuccessDialog('updated');
    } else {
      print("Failed to update idea: ${result?['message']}");
      Fluttertoast.showToast(
        msg: "Failed to update idea: ${result?['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void addIdea() async {
    IdeaController ideaController = IdeaController();
    var result = await ideaController.addIdea(
      descriptionController.text,
      isPublic,
      selectedCategory!,
    );

    if (result != null && result['success']) {
      print("Idea added successfully!");
      _showSuccessDialog('added');
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

  void _showSuccessDialog(String status) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Your idea has been $status successfully."),
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
      body: widget.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'تنويه: جميع الحقول مطلوبة حتى يتم نشر المشروع',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20),
                      _buildLabeledTextField(
                          'شرح مبسط عن الفكرة', descriptionController,
                          maxLength: 140, maxLines: 3),
                      SizedBox(height: 10),
                      Text('ما هو مجال الفكرة',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      _buildDropdownField(),
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
                                Navigator.pop(context); // العودة للصفحة السابقة
                              },
                              child: Text('إلغاء'),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.toUpdate == true) {
                                  updateIdea();
                                } else {
                                  addIdea();
                                }
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => homepagescreen()),
                                  (Route<dynamic> route) => false,
                                );
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

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {int maxLines = 1, int? maxLength}) {
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
    selectedCategory ?? categories.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            items: categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              selectedCategory = value ?? categories.first;
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
    List<String> visibilityOptions = ['عام', 'خاص'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('هل تود مشاركة الفكرة بشكل عام أم تفضل الاحتفاظ بها خاصة؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 700,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: isPublic ? 'عام' : 'خاص',
            items: visibilityOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(value),
                ),
              );
            }).toList(),
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
    super.dispose();
  }
}
