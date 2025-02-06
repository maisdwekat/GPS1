import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../Controllers/ideaController.dart';
import '../../../../../constants.dart';
import '../../../../ChatForInquiries/ChatForInquiries.dart';
import '../MyAccount.dart';
import 'MyIdeas.dart';
import '../MyStartupProjects/MyStartupProjects.dart';

class PreviewIdeaScreen extends StatefulWidget {
  @override
  _PreviewIdeaScreenState createState() => _PreviewIdeaScreenState();
  final String ideaId;
  const PreviewIdeaScreen({super.key, required this.ideaId});

}

class _PreviewIdeaScreenState extends State<PreviewIdeaScreen> {
  final IdeaController _ideaController = IdeaController();
  @override
  void initState() {
    super.initState();
    ideaGet(); // جلب الأفكار عند بدء الشاشة

  }
  String? _id;
  String? _description;
  String? _emailContact;
  bool? _isPublic;
  String? _category;
  Map<String, dynamic>? _createdBy;
  List<Map<String, dynamic>> _comment = [];
  List<Map<String, dynamic>> _likes = [];
  String? _createdAt;
  Future<void> ideaGet() async {
    print("ideaGet() called");
    final ideas = await _ideaController.getIdea(widget.ideaId);

    if (ideas != null && ideas.isNotEmpty) {
      setState(() {
        // تخزين القيم القادمة من getIdea
        _id = ideas[0]['_id'];
        _description = ideas[0]['description'];
        _emailContact = ideas[0]['emailContact'];
        _isPublic = ideas[0]['isPublic'];
        _category = ideas[0]['category'];
        _createdBy = ideas[0]['createdBy'];
        _comment = List<Map<String, dynamic>>.from(ideas[0]['comments']);
        _likes = List<Map<String, dynamic>>.from(ideas[0]['likes']);
        _createdAt = ideas[0]['createdAt'];
      });
      print('Successfully fetched idea: $_description');
      print('Idea ID: $_id');
      print('Description: $_description');
      print('Email Contact: $_emailContact');
      print('Is Public: $_isPublic');
      print('Category: $_category');
      print('Created By: ${_createdBy?['name']}');
      print('Created By ID: ${_createdBy?['_id']}');
      print('Created At: $_createdAt');

// طباعة التعليقات (comments)
      print('Comments:');
      _comment.forEach((comment) {
        print('Comment ID: ${comment['_id']}');
        print('Comment Content: ${comment['content']}');
        print('Comment Created By: ${comment['userName']}');
        print('Comment Created At: ${comment['createdAt']}');

        // طباعة اللايكات الخاصة بالتعليق
        if (comment['likes'] != null && comment['likes'].isNotEmpty) {
          comment['likes'].forEach((like) {
            print('Like ID: ${like['_id']}');
            print('Like Created At: ${like['createdAt']}');
          });
        } else {
          print('No likes for this comment');
        }
      });

// طباعة اللايكات (likes) العامة للفكرة
      print('Likes:');
      _likes.forEach((like) {
        print('Like ID: ${like['_id']}');
        print('Like Created By: ${like['createdBy']}');
        print('Like Created At: ${like['createdAt']}');
      });

    } else {
      print('No idea data found');
    }
  }

  final List<Map<String, dynamic>> _comments = [
    {
      'userName': 'محمد',
      'comment': 'هذا تعليق رائع!',
      'userImageUrl': 'assets/images/defaultpfp.jpg',
      'isLiked': false,
      'likesCount': 0,
    },
    // Add more comments as needed
  ];

  // تعريف projectData هنا
  Map<String, dynamic> projectData = {
    'commentsCount': 0,
    'likesCount': 0,
    'isLiked': false,
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isHoveringAbout = false;
  bool _isHoveringComments = false;
  final TextEditingController _commentController = TextEditingController();
  bool _showAbout = true; // اجعل "حول" تظهر كافتراضي
  Map<String, dynamic> item = {
    'commentsCount': 0,
    'likesCount': 0,
    'isLiked': false,
  };

  String _profileImage = ''; // متغير لتخزين مسار الصورة
  String _displayedText = ''; // المتغير لتخزين النص المعروض
  String? _displayedImagePath; // المتغير لتخزين مسار الصورة المعروضة


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image.path; // تحديث مسار الصورة
      });
    }
  }

  void _updateContent(String title, {String? imagePath}) {
    setState(() {
      _displayedText = title;
      _displayedImagePath = imagePath;
    });
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
            _buildHorizontalLine(),
            _buildNavigationBar(),
            _buildHorizontalLine(),
            SizedBox(height: 40),
            _buildProjectCards(),
            SizedBox(height: 100), // يمكنك تغيير القيمة حسب الحاجة
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
          _buildNavItem('أفكاري', MyIdeasScreen()),
          _buildNavItem('مشاريعي الناشئة', MyStartupProjectsScreen()),
          _buildNavItem('حسابي', ProfileScreen()),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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

  Widget _buildProjectCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 40),
                    _buildProjectOptions(),
                    SizedBox(height: 20),
                    _showAbout ? _buildAboutContent() : _buildCommentList(),
                    SizedBox(height: 20),
                    if (!_showAbout) _buildCommentBox(),
                  ],
                ),
              ),
            ),
            Container(
              width: 250,
              height: 400,
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
              child: _buildProjectSummary(),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProjectOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildProjectOption('التعليقات', "تعليقات عن الفكرة ", false),
        SizedBox(width: 20),
        _buildProjectOption('حول', "حول الفكرة", true),
      ],
    );
  }

  Widget _buildProjectOption(String title, String text, bool isAbout) {
    return MouseRegion(
      onEnter: (_) => _changeHoverState(isAbout, true),
      onExit: (_) => _changeHoverState(isAbout, false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAbout = isAbout;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isAbout
                      ? (_isHoveringAbout ? Colors.orange : Color(0xFF0A1D47))
                      : (_isHoveringComments ? Colors.orange : Color(0xFF0A1D47)),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: title.length * 12.0,
                height: 2,
                color: Color(0xFF0A1D47),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeHoverState(bool isAbout, bool isHovering) {
    setState(() {
      if (isAbout) {
        _isHoveringAbout = isHovering;
      } else {
        _isHoveringComments = isHovering;
      }
    });
  }

  Widget _buildCommentBox() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Transform.rotate(
                angle: 3.14159,
                child: Icon(Icons.send, color: Color(0xFF0A1D47)),
              ),
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  setState(() {
                    _comments.add({
                      'userName': 'أنت', // أو اسم المستخدم الحالي
                      'comment': _commentController.text,
                      'userImageUrl': 'assets/images/defaultpfp.jpg',
                      'isLiked': false,
                      'likesCount': 0, // إضافة عدد الإعجابات
                    });
                  });
                  _commentController.clear();
                }
              },
            ),
            Expanded(
              child: TextField(
                controller: _commentController,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقا',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: _comments.isNotEmpty
            ? ListView.builder(
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            var commentData = _comments[index];
            return _buildCommentItem(
              commentData['userName']!,
              commentData['comment']!,
              commentData['userImageUrl']!,
              commentData['isLiked'], // تمرير حالة الإعجاب
              commentData['likesCount'], // تمرير عدد الإعجابات
              index, // تمرير الفهرس
            );
          },
        )
            : Center(child: Text('لا توجد تعليقات بعد.')),
      ),
    );
  }

  Widget _buildCommentItem(String userName, String comment, String userImageUrl, bool isLiked, int likesCount, int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 4),
                  Text(
                    comment,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _comments[index]['isLiked'] = !_comments[index]['isLiked']; // تغيير حالة الإعجاب
                            if (_comments[index]['isLiked']) {
                              _comments[index]['likesCount']++; // زيادة عدد الإعجابات
                            } else {
                              _comments[index]['likesCount']--; // تقليل عدد الإعجابات
                            }
                          });
                        },
                      ),
                      Text(
                        '${_comments[index]['likesCount']}', // عرض عدد الإعجابات
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            ClipOval(
              child: Image.asset(
                userImageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'صاحب الفكرة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          Text(
            'أحمد محمد',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10),
          Text(
            'البريد الإلكتروني',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          GestureDetector(
            onTap: () {
              _showChatDialog(context);
            },
            child: Text(
              'ahmed@example.com',
              style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'شرح عن الفكرة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          Text(
            'هذه الفكرة تهدف إلى تحسين تجربة المستخدم في التطبيقات من خلال تقديم واجهة مستخدم سهلة الاستخدام.',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 400,
                height: 600,
                child: ChatForInquiriesScreen(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectSummary() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/defaultimg.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'مجال الفكرة',
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
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.comment, color: kPrimaryColor),
                  onPressed: () {
                    setState(() {
                      _showAbout = false;
                    });
                  },
                ),
                Text(
                  '${_comments.length}', // استخدام عدد التعليقات مباشرة
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: projectData['isLiked'] ? Colors.red : kPrimaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      projectData['isLiked'] = !projectData['isLiked'];
                      if (projectData['isLiked']) {
                        projectData['likesCount']++;
                      } else {
                        projectData['likesCount']--;
                      }
                    });
                  },
                ),
                Text(
                  '${projectData['likesCount']}', // استخدام عدد الإعجابات
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}