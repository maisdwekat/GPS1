import 'package:flutter/material.dart';

import '../../ContactUs/AIChat.dart';
import '../../ContactUs/Chat.dart';
import '../../Success_stories/Success_stories.dart';
import '../../Success_stories/Success_stories_investor.dart';
import '../../WhoWeAre/WhoWeAre.dart';
import '../../WhoWeAre/WhoWeAre_investor.dart';
import '../../users/navigation_bar/StartUpsHub/Ideas/Ideas.dart';
import '../../users/navigation_bar/StartUpsHub/Projects/Projects.dart';
import '../homepageinvestor/HomePageScreeninvestor.dart';

class NavigationBarinvestor extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onSelectContact;

  const NavigationBarinvestor({
    Key? key,
    required this.scaffoldKey,
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
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 16),
                  _buildPopupMenuButton(context, Icons.notifications, _buildNotificationsList),
                  const SizedBox(width: 16),
                  _buildPopupMenuButton(context, Icons.messenger, _buildMessagesList),
                ],
              ),
              const Spacer(),
              Row(
                children: [
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
                  _buildLink('قصص نجاح', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessStoriesScreeninvestor()));
                  }),
                  const SizedBox(width: 20),
                  _buildDropdownButton(
                    'حاضنة ستارت أب',
                    [
                      DropdownMenuItem(value: 'المشاريع', child: Text('المشاريع')),
                      DropdownMenuItem(value: 'الأفكار', child: Text('الأفكار')),
                    ],
                        (value) {
                      if (value == 'المشاريع') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectsScreen.investor()));
                      } else if (value == 'الأفكار') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => IdeasScreen.invstor()));
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildHoverLink('من نحن', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WhoWeAreScreeninvestor()));
                  }),
                  const SizedBox(width: 20),
                  _buildHoverLink('الرئيسية', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreeninvestor()));
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  


  Widget _buildPopupMenuButton(BuildContext context, IconData icon, Widget Function(BuildContext) itemBuilder) {
    return PopupMenuButton(
      icon: Icon(icon),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: itemBuilder(context),
          ),
        ];
      },
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    List<Map<String, String>> messages = [
      {
        'userName': 'أحمد',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'كيف حالك؟',
        'time': '10:30 AM',
      },
      {
        'userName': 'سارة',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'هل تريد الذهاب إلى السينما؟',
        'time': '9:15 AM',
      },
      {
        'userName': 'محمد',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'أحتاج مساعدتك في المشروع.',
        'time': 'Yesterday',
      },
      {
        'userName': 'ليلى',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': 'هل رأيت آخر الأخبار؟',
        'time': '2 days ago',
      },
      {
        'userName': 'عامر',
        'userImage': 'assets/images/defaultpfp.jpg',
        'message': ' الأخبار؟',
        'time': '5 days ago',
      },
    ];

    return Container(
      width: 250,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الرسائل',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(
                  messages[index]['userName']!,
                  messages[index]['userImage']!,
                  messages[index]['message']!,
                  messages[index]['time']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    List<Map<String, String>> notifications = [
      {
        'title': 'إشعار 1',
        'message': 'هذا هو نص الإشعار الأول.',
      },
      {
        'title': 'إشعار 2',
        'message': 'هذا هو نص الإشعار الثاني.',
      },
      {
        'title': 'إشعار 3',
        'message': 'هذا هو نص الإشعار الثالث.',
      },
    ];

    return Container(
      width: 250,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإشعارات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(
                  notifications[index]['title']!,
                  notifications[index]['message']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(String userName, String userImage, String message, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(userImage),
            radius: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildHoverLink(String title, VoidCallback onTap) {
    return MouseRegion(
      onEnter: (_) {
        // تغيير اللون عند المرور فوق العنصر
      },
      onExit: (_) {
        // إعادة اللون عند الخروج
      },
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, // اللون الافتراضي
          ),
        ),
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
}