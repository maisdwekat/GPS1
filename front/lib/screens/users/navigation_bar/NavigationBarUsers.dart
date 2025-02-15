import 'package:flutter/material.dart';

import '../../ContactUs/AIChat.dart';
import '../../ContactUs/Chat.dart';
import '../../MessagesScreen.dart';
import '../../NotificationsScreen.dart';
import '../../Success_stories/Success_stories.dart';
import '../../WhoWeAre/WhoWeAre.dart';
import '../Feedback/Feedback.dart';
import '../GrantsPage/GrantsPage.dart';
import 'MyInformation/MyIdeas/AddIdea.dart';
import 'MyInformation/MyStartupProjects/AddStartupProject.dart';
import 'StartUpsHub/Ideas/Ideas.dart';
import 'StartUpsHub/Projects/Projects.dart';
import '../homepageUsers/HomePageScreenUsers.dart';
import 'LaunchProject/Launch_your_project.dart';
import 'StartUpsHub/Courses/Courses.dart';

class NavigationBarUsers extends StatelessWidget {
  final Function(String) onSelectContact;

  const NavigationBarUsers({
    Key? key,
    required this.onSelectContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () => onSelectContact('open_drawer'), // Fix: Call the function
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(Icons.messenger),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesScreen()));
                    },
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildDropdownButton(
                    'اضافة الى الحاضنة',
                    [
                      DropdownMenuItem(value: 'فكرة', child: Text('فكرة')),
                      DropdownMenuItem(value: ' مشروع', child: Text(' مشروع')),
                    ],
                        (value) {
                      if (value == 'فكرة') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddideaScreen()));
                      } else if (value == ' مشروع') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddStartupProjectScreen()));
                      }
                    },
                  ),
                  const SizedBox(width: 20),

                  _buildDropdownButton(
                    'تواصل معنا',
                    [
                      DropdownMenuItem(value: 'دردشة مباشرة', child: Text('دردشة مباشرة')),
                      DropdownMenuItem(value: 'اسأل AI', child: Text('اسأل AI')),
                    ],
                        (value) {
                      if (value == 'دردشة مباشرة') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                      } else if (value == 'اسأل AI') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AIChatScreen()));
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildLink('فيدباك', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
                  }),
                  const SizedBox(width: 20),
                  _buildLink('المنح', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GrantsPage()));
                  }),
                  const SizedBox(width: 20),
                  _buildLink('قصص نجاح', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessStoriesScreen()));
                  }),
                  const SizedBox(width: 20),
                  _buildLink('أطلق مشروعك', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LaunchProjectScreen()));
                  }),
                  const SizedBox(width: 20),
                  _buildDropdownButton(
                    'حاضنة ستارت أب',
                    [
                      DropdownMenuItem(value: 'المشاريع', child: Text('المشاريع')),
                      DropdownMenuItem(value: 'الأفكار', child: Text('الأفكار')),
                      DropdownMenuItem(value: 'الدورات', child: Text('الدورات')),
                    ],
                        (value) {
                      if (value == 'المشاريع') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectsScreen()));
                      } else if (value == 'الأفكار') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => IdeasScreen()));
                      } else if (value == 'الدورات') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesScreen()));
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildLink('من نحن', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WhoWeAreScreen()));
                  }),
                  const SizedBox(width: 20),
                  _buildLink('الرئيسية', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => homepagescreen()));
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(String hint, List<DropdownMenuItem<String>> items, Function(String) onSelect) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text(
          hint,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onSelect(newValue);
          }
        },
        items: items,
      ),
    );
  }

  Widget _buildLink(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}