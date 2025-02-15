import 'package:flutter/material.dart';
import 'package:ggg_hhh/screens/investor/navigation_bar_investor/Drawerinvestor/Drawerinvestor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../Controllers/ideaController.dart';
import '../../../../../Controllers/token_controller.dart';
import '../../../../../Widget/user_information_header.dart';
import '../../../../../constants.dart';
import '../../../../ChatForInquiries/ChatForInquiries.dart';
import '../../../../basic/header.dart';
import '../../../../investor/navigation_bar_investor/NavigationBarinvestor.dart';
import '../../DrawerUsers/DrawerUsers.dart';
import '../../NavigationBarUsers.dart';
import '../MyAccount.dart';
import 'MyIdeas.dart';
import '../MyStartupProjects/MyStartupProjects.dart';

class PreviewIdeaScreen extends StatefulWidget {
  @override
  _PreviewIdeaScreenState createState() => _PreviewIdeaScreenState();
  final String ideaId;
  bool isToInformation = false;
  String? role;

  PreviewIdeaScreen({super.key, required this.ideaId});

  PreviewIdeaScreen.toInfo(
      {super.key,
      required this.ideaId,
      this.isToInformation = true,
      required this.role});
}

class _PreviewIdeaScreenState extends State<PreviewIdeaScreen> {
  final IdeaController _ideaController = IdeaController();
  TokenController tokenController = TokenController();

  final List<Map<String, dynamic>> _comments = [];

  String? _id;
  String? _description;
  String ? _ownarIdeaId;
  String? _emailContact;
  bool? _isPublic;
  String? _category;

  // Map<String, dynamic>? _createdBy;
  String? _createdBy;

  List<dynamic> _comment = [];
  List<dynamic> _likesCommentList = [];
  List<dynamic> likesForIdeaList = [];
  int ideaLikesLength = 0;
  bool isLikedIdea = false;

  Future<void> getLikes() async {
    List<dynamic> likes = await _ideaController.getAllLikes(widget.ideaId);
    likesForIdeaList = likes.map((like) => like['createdBy']['_id']).toList();
    if (likesForIdeaList.isNotEmpty) {
      if (likesForIdeaList.contains(userid)) {
        isLikedIdea = true;
      }
      print('the problem is here');
      print(likesForIdeaList.toString());
      print('the problem is here');

      setState(() {
        ideaLikesLength = likesForIdeaList.length;
      });
    }
  }

  List<Map<String, dynamic>> _likes = [];
  String? _createdAt;

  Future<void> ideaGet() async {
    print("ideaGet() called");
    final ideas = await _ideaController.getIdea(widget.ideaId);

    if (ideas != null && ideas.isNotEmpty) {
      setState(() {
        // تخزين القيم القادمة من getIdea
        // _id = widget.ideaId;
        _description = ideas['description'];
        _ownarIdeaId = ideas['ownerId'];
        _emailContact = ideas['emailContact'];
        _isPublic = ideas['isPublic'];
        _category = ideas['category'];
        _createdBy = ideas['createdBy']['name'];
        _comment = List<Map<String, dynamic>>.from(ideas['comments']);
        _likes = List<Map<String, dynamic>>.from(ideas['likes']);
        _createdAt = ideas['createdAt'];
      });
      print('Successfully fetched idea: $_description');
      // print('Idea ID: $_id');
      print('Description: $_description');
      print('Email Contact: $_emailContact');
      print('Is Public: $_isPublic');
      print('Category: $_category');
      // print('Created By: ${_createdBy?['name']}');
      // print('Created By ID: ${_createdBy?['_id']}');
      print('Created At: $_createdAt');

// طباعة التعليقات (comments)
      print('Comments:');
      _comment.forEach((comment) {
        _comments.add(comment);
        // print('Comment ID: ${comment['_id']}');
        print('Comment Content: ${comment['content']}');
        print('Comment Created By: ${comment['userName']}');
        print('Comment Created At: ${comment['createdAt']}');

        // طباعة اللايكات الخاصة بالتعليق
        if (comment['likes'] != null && comment['likes'].isNotEmpty) {
          comment['likes'].forEach((like) {
            _likesCommentList.add(like['createdBy']);
            // print('Like ID: ${like['_id']}');
            print('Like Created At: ${like['createdAt']}');
          });
        } else {
          _likesCommentList = [];
          print('No likes for this comment');
        }
      });

// طباعة اللايكات (likes) العامة للفكرة
      print('Likes:');
      _likes.forEach((like) {
        // print('Like ID: ${like['_id']}');
        print('Like Created By: ${like['createdBy']}');
        print('Like Created At: ${like['createdAt']}');
      });
    } else {
      print('No idea data found');
    }
  }

  // تعريف projectData هنا

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

  String? userid;

  getUserId() async {
    String? savedToken = await tokenController.getToken();
    var user = tokenController.decodedToken(savedToken!);
    userid = user['id'];
  }

  @override
  void initState() {
    print(widget.role)  ;
    super.initState();

    getUserId();
    ideaGet(); // جلب الأفكار عند بدء الشاشة
    print('Likes################################');
    getLikes();
    print('Likes################################');
    print("user id is $userid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.role == null
          ? null
          : widget.role == 'user'
              ? DrawerUsers(scaffoldKey: _scaffoldKey)
              : Drawerinvestor(scaffoldKey: _scaffoldKey),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
        leading: widget.role == null
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.role == null ?  _buildHeader(): HeaderScreen(),

            widget.role == null
                ? SizedBox()
                : widget.role == 'user'
                    ? NavigationBarUsers(
              onSelectContact: (value) {
                print('Scaffold State: ${_scaffoldKey.currentState}');
                _scaffoldKey.currentState!.openDrawer();
              },
            )
                    : NavigationBarinvestor(
                        scaffoldKey: _scaffoldKey, onSelectContact: (value) {}),

            widget.role == null ? UserInformationHeader(): SizedBox(),
            widget.role == null ? _buildHorizontalLine() : SizedBox(),
            widget.role == null ? _buildNavigationBar() : SizedBox(),
            widget.role == null ? _buildHorizontalLine() : SizedBox(),
            SizedBox(height: 40),
            _buildProjectCards(),
            SizedBox(height: 100), // يمكنك تغيير القيمة حسب الحاجة
          ],
        ),
      ),
    );
  }

  fullWidget() {
    return Column(
      children: [
        _buildHeader(),
        UserInformationHeader(),
        _buildHorizontalLine(),
        _buildNavigationBar(),
        _buildHorizontalLine(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF0A1D47),
      height: 30,
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
                      : (_isHoveringComments
                          ? Colors.orange
                          : Color(0xFF0A1D47)),
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
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
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
                    _ideaController.addComment(
                        widget.ideaId, _commentController.text);
                    _comments.add({
                      '_id': DateTime.now().microsecond.toString(),
                      'userName': 'أنت', // أو اسم المستخدم الحالي
                      'content': _commentController.text,
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
                    comment: commentData['content']!,
                    commentId: commentData['_id']!,
                    isLiked: _likesCommentList.contains(
                      {"_id": userid.toString()},
                    ),
                    Likes: _likesCommentList,
                    userImageUrl: "assets/images/defaultpfp.jpg",

                    userName: commentData['userName']!,

                    // تمرير الفهرس
                  );
                },
              )
            : Center(child: Text('لا توجد تعليقات بعد.')),
      ),
    );
  }

  Widget _buildCommentItem({
    required List<dynamic> Likes,
    required String? commentId,
    required String userName,
    required String comment,
    required String userImageUrl,
    required bool isLiked,
    // required int index
  }) {
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
                            if (isLiked) {
                              _ideaController
                                  .addLikeForComment(commentId ?? "");
                              _likes.add({
                                '_id': DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                "createdAt": "2025-02-06T18:43:27.073Z"
                              });
                            } else {
                              _likes.removeLast();
                            }
                          });
                        },
                      ),
                      Text(
                        '${_likes.length}',
                        // عرض عدد الإعجابات
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
            _createdBy.toString(),
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
              !widget.isToInformation?SizedBox():
              _showChatDialog(context);
            },
            child: Text(
              _emailContact.toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline),
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
            _description.toString(),
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
                child: ChatForInquiriesScreen(id: _ownarIdeaId!,),
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
          _category.toString(),
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
          _isPublic != null && _isPublic == true ? "عام" : "خاص",
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
                    color: isLikedIdea ? Colors.red : kPrimaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isLikedIdea = !isLikedIdea;
                      if (isLikedIdea) {
                        _ideaController.addLikeForIdea(widget.ideaId);
                        ideaLikesLength++;
                      } else {
                        _ideaController.deleteLikeForIDea(widget.ideaId);

                        ideaLikesLength--;
                      }
                    });
                  },
                ),
                Text(
                  '${ideaLikesLength}', // استخدام عدد الإعجابات
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
