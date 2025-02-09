import 'package:flutter/material.dart';
import 'package:ggg_hhh/Widget/bmc_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../ChatForInquiries/ChatForInquiries.dart';
import '../../../../investor/navigation_bar_investor/MyInformation/RequestFormUpdate.dart';
import '../../../../investor/navigation_bar_investor/MyInformation/Request_form.dart';
import '../MyAccount.dart';
import '../MyIdeas/MyIdeas.dart';
import 'CreateBusinessPlan.dart';
import 'MyStartupProjects.dart';

class PreviewProjectScreen extends StatefulWidget {
  @override
  _PreviewProjectScreenState createState() => _PreviewProjectScreenState();
}

class _PreviewProjectScreenState extends State<PreviewProjectScreen> {
  String _profileImage = '';
  Widget? _selectedContent; // تغيير إلى نوع Widget?

  @override
  void initState() {
    super.initState();
    _selectedContent = Container(); // بدء كفارغ
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

  void _updateContent(Widget content) {
    setState(() {
      _selectedContent = content; // تعيين المحتوى كـ Widget
    });
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 0, // لتحديد موقعها من الأسفل
              left: 0, // لتحديد موقعها من اليسار
              child: Container(
                width: 400,
                height: 600, // يمكنك تعديل الحجم كما تحتاج
                child: ChatForInquiriesScreen(), // استبدل هذا بالمحتوى الخاص بك
              ),
            ),
          ],
        );
      },
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildProfileSection(),
            Divider(color: Color(0xFF0A1D47)),
            _buildNavigationBar(),
            Divider(color: Color(0xFF0A1D47)),
            _buildMainContent(),
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

  Widget _buildProfileSection() {
    return Container(
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
                      : const AssetImage('assets/images/defaultpfp.jpg'),
                  child: _profileImage.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 30, color: Colors.grey)
                      : null,
                ),
                const Icon(Icons.edit, color: Color(0xFF0A1D47)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      height: 50,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('أفكاري', MyIdeasScreen()),
          _buildNavItem('مشاريعي الناشئة', MyStartupProjectsScreen()),
          _buildNavItem('حسابي', ProfileScreen()),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(title, style: TextStyle(color: Color(0xFF001F3F))),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildProjectDetails(),
            ),
            SizedBox(width: 20),
            _buildProjectSummary(),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProjectDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'عنوان المشروع الرئيسي',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 20),
          _buildProjectActions(),
          SizedBox(height: 20),
          // عرض المحتوى المحدد بناءً على الضغط
          if (_selectedContent != null) ...[
            _selectedContent!, // استخدام ! لأننا نعرف أنه ليس null هنا
            SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionItem('المستثمرين الحاليين', () {
          _updateContent(_buildExistinginvestorsContent()); // تعيين كـ Widget
        }),
        _buildActionItem('طلبات الاستثمار', () {
          _updateContent(_buildInvestmentRequestsContent()); // تعيين كـ Widget
        }),
        _buildActionItem('الملاحظات', () {
          _updateContent(_buildProjectNotesContent()); // تعيين كـ Widget
        }),
        _buildActionItem('نموذج العمل التجاري', () {
          _updateContent(
              _buildBusinessModelContent(context)); // تعيين كـ Widget
        }),
        _buildActionItem('سير المشروع', () {
          _updateContent(_buildProjectProgressContent()); // تعيين كـ Widget
        }),
        _buildActionItem('حول', () {
          _updateContent(_buildAboutContent()); // تعيين كـ Widget
        }),
      ],
    );
  }

////////////////////////////////////////////////////

  Widget _buildAboutContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAboutSection('صاحب المشروع', 'أحمد محمد', 20, 18),
          _buildAboutSection(
            'البريد الإلكتروني',
            GestureDetector(
              onTap: () {
                _showChatDialog(context);
              },
              child: Text(
                'ahmed@example.com',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            16,
            16,
          ),
          _buildAboutSection(
              'الموقع الالكتروني ',
              GestureDetector(
                onTap: () {},
                child: Text(
                  'www.example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline, // إضافة خط تحت النص
                  ),
                ),
              ),
              16,
              14),
          _buildProgressSection('تاريخ الإنشاء', '2024', 20, 18),
          _buildAboutSection(
              'نبذة عن المشروع',
              'يطمح المشروع إلى تحقيق نتائج ملموسة تسهم في تحسين العمليات المختلفة...',
              16,
              14),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
      String title, dynamic content, double titleSize, double contentSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        content is Widget
            ? content
            : Text(
                content,
                style: TextStyle(fontSize: contentSize),
                textAlign: TextAlign.right,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProgressSection(
      String title, String year, double titleSize, double contentSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        // عرض السنة فقط
        Text(
          year, // استخدم السنة التي تم تمريرها
          style: TextStyle(fontSize: contentSize),
          textAlign: TextAlign.right,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: 10),
      ],
    );
  }

////////////////////////////////////////////////////
  Widget _buildProjectProgressContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          _buildProgressSectionWithProgress(
              'المرحلة الحالية', 'مرحلة التحقق والتخطيط', 20, 18, 0.4),
        ],
      ),
    );
  }

  Widget _buildProgressSectionWithProgress(String title, String content,
      double titleSize, double contentSize, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: contentSize),
          textAlign: TextAlign.right,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: 10),
        Container(
          width: 200, // عرض الشريط المحدد
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300], // لون الخلفية
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 200 * progress, // حساب العرض بناءً على النسبة
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green, // لون الشريط المكتمل
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  ////////////////////////////////////////////////////

  Widget _buildBusinessModelContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: BmcWidget.pre(isPre: true),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateBusinessPlanScreen.toUpdate()),
              );
            },
            child: Text('تعديل'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50), // تحديد الطول والعرض للزر
            ),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////
  List<Note> notes = []; // قائمة الملاحظات

  Widget _buildProjectNotesContent() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200], // لون خلفية المستطيل السكني
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'الملاحظات',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...notes.map((note) {
            int index = notes.indexOf(note);
            return _buildNoteSection(note, index);
          }).toList(),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _showAddNoteDialog(),
            child: Icon(Icons.add),
            backgroundColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(Note note, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.orangeAccent),
                // لون أيقونة التعديل
                onPressed: () => _showEditNoteDialog(note.content, index),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.orangeAccent),
                // لون أيقونة الحذف
                onPressed: () => _deleteNote(index),
              ),
            ],
          ),
          SizedBox(width: 10), // مسافة بين الأيقونات والنص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(note.content, style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                Text(
                  '${note.date.day}/${note.date.month}/${note.date.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNote(String content) {
    setState(() {
      notes.add(Note(
        content: content,
        date: DateTime.now(),
      ));
    });
  }

  void _editNote(int index, String newContent) {
    setState(() {
      notes[index].content = newContent;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  void _showAddNoteDialog() {
    String newNoteContent = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('إضافة ملاحظة جديدة'),
          content: Container(
            width: 400, // عرض ثابت للحوار
            height: 200, // ارتفاع ثابت للحوار
            child: TextField(
              onChanged: (value) {
                newNoteContent = value;
              },
              decoration: InputDecoration(hintText: 'محتوى الملاحظة'),
              maxLines: 5, // عدد الأسطر الأقصى
              keyboardType: TextInputType.multiline, // نوع لوحة المفاتيح
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newNoteContent.isNotEmpty) {
                  _addNote(newNoteContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(String currentContent, int index) {
    String updatedNoteContent = currentContent;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل الملاحظة'),
          content: Container(
            width: 400, // عرض ثابت للحوار
            height: 200, // ارتفاع ثابت للحوار
            child: TextField(
              onChanged: (value) {
                updatedNoteContent = value;
              },
              decoration: InputDecoration(hintText: 'محتوى الملاحظة'),
              controller: TextEditingController(text: currentContent),
              maxLines: 5,
              // عدد الأسطر الأقصى
              keyboardType: TextInputType.multiline, // نوع لوحة المفاتيح
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updatedNoteContent.isNotEmpty) {
                  _editNote(index, updatedNoteContent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////////////////////
  List<String> investmentRequests = [
    'طلب استثمار1',
    'طلب استثمار2',
    'طلب استثمار3',
  ];

  Widget _buildInvestmentRequestsContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'طلبات الاستثمار',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold), // عنوان كبير
          ),
          SizedBox(height: 15), // فراغ قبل الجدول
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.4), // عرض أكبر للاسم
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.2),
            },
            children: [
              _buildHeaderInvestmentRequestsRow(), // إضافة صف العناوين
              ...investmentRequests
                  .map((name) => buildInvestmentRequestsRow(name))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderInvestmentRequestsRow() {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              Text(
                'الإجراءات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                'نموذج الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              Text(
                'اسم المستثمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
      ],
    );
  }

  TableRow buildInvestmentRequestsRow(String name) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الزر والخط السفلي
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red), // أيقونة الحذف
                onPressed: () {
                  _deleteInvestmentRequest(name); // استدعاء دالة الحذف
                },
              ),
              SizedBox(height: 8), // فراغ بين الأيقونات والخط السفلي
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الزر والخط السفلي
              SizedBox(
                width: 180, // عرض الزر
                child: ElevatedButton(
                  onPressed: () => _showInvestmentDetailsDialog(),
                  child: Text('نموذج الطلب'),
                ),
              ),
              SizedBox(height: 8), // فراغ بين الزر والخط السفلي
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الزر والخط السفلي
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
            ],
          ),
        ),
      ],
    );
  }

  void _deleteInvestmentRequest(String title) {
    setState(() {
      investmentRequests.remove(title); // حذف العنصر من القائمة
    });
    print('تم حذف: $title');
  }

  void _showInvestmentDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.5, // عرض الـ Dialog
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'معلومات المستثمر',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField('اسم المستثمر', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('البريد الإلكتروني', width: 0.4),
                  SizedBox(height: 20),
                  Text(
                    'تفاصيل الاستثمار',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField('اسم المشروع', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مبلغ الاستثمار', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نوع الاستثمار', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('تاريخ البدء بالاستثمار', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('تاريخ الاستحقاق', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نسبة الاستثمار', width: 0.4),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مدة الاستثمار', width: 0.4),
                  SizedBox(height: 20),
                  _buildLabeledTextField('ملاحظات إضافية',
                      width: 0.4, maxLines: 3),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.2, // ضبط عرض الزر
                          child: ElevatedButton(
                            onPressed: () {
                              // تنفيذ عملية القبول
                              Navigator.of(context).pop();
                            },
                            child: Text('قبول'),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.2, // ضبط عرض الزر
                          child: ElevatedButton(
                            onPressed: () {
                              // تنفيذ عملية الرفض
                              Navigator.of(context).pop();
                            },
                            child: Text('رفض'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabeledTextField(String label,
      {int maxLines = 1, double width = 0.4}) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, textAlign: TextAlign.right),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////

  List<String> investors = [
    'مستثمر 1',
    'مستثمر 2',
    'مستثمر 3',
  ];

  Widget _buildExistinginvestorsContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'المستثمرين الحاليين',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold), // عنوان كبير
          ),
          SizedBox(height: 15), // فراغ قبل الجدول
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.4), // عرض أكبر للاسم
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.2),
            },
            children: [
              _buildHeaderRow(), // إضافة صف العناوين
              ...investors.map((name) => _buildInvestorRow(name)).toList(),
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
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              Text(
                'الإجراءات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              Text(
                'نموذج الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              Text(
                'اسم المستثمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8), // فراغ أسفل النص
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildInvestorRow(String name) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red), // أيقونة الحذف
                onPressed: () {
                  _deleteInvestor(name); // استدعاء دالة الحذف
                },
              ),
              SizedBox(width: 8), // فراغ بين الأيقونات
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue), // أيقونة التعديل
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RequestFormUpdateScreen()), // استبدل بـ EditInvestmentForm()
                  );
                },
              ),
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              SizedBox(
                width: 180, // عرض الزر
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RequestFormScreen()), // استبدل بـ RequestForm()
                    );
                  },
                  child: Text('نموذج الطلب'),
                ),
              ),
              SizedBox(height: 8), // فراغ بين الزر والخط السفلي
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
              Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8), // فراغ بين الاسم والخط السفلي
            ],
          ),
        ),
      ],
    );
  }

  void _showRequestFormDialog() {
    // تنفيذ منطق عرض نموذج الطلب
  }

  void _editInvestor(String name) {
    // تنفيذ منطق تعديل المستثمر
    print('تعديل: $name');
  }

  void _deleteInvestor(String name) {
    setState(() {
      investors.remove(name); // حذف المستثمر من القائمة
    });
    print('تم حذف: $name');
  }
}

////////////////////////////////////////////////////////
Widget _buildActionItem(String title, Function action) {
  return GestureDetector(
    onTap: () {
      action(); // استدعاء الدالة
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001F3F)),
      ),
    ),
  );
}

Widget _buildProjectSummary() {
  return Container(
    width: 250,
    height: 350,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(right: 10, left: 20),
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
        Text(
          'وصف مختصر',
          style: TextStyle(fontSize: 14, color: Colors.green),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class Note {
  String content;
  DateTime date;

  Note({required this.content, required this.date});
}
