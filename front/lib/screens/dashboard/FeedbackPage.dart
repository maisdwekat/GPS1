import 'package:flutter/material.dart';
import '../../Controllers/feedbackController.dart';
import '../ContactUs/Chat.dart';
import '../Welcome/welcome_screen.dart';
import 'ActiveUsersTable.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic>? feedbackList = []; // Change the type here
  final FeedbackController feedbackController = FeedbackController();

  @override
  void initState() {
    super.initState();
    getAllFeedback();
  }

  Future<void> getAllFeedback() async {
    // Make sure the method returns List<Map<String, String>>
    feedbackList = await feedbackController.getAllFeedbackForAdmin();
    print(feedbackList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context, feedbackList)),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF4A4A4A),
      child: Column(
        children: [
          const SizedBox(height: 70),
          _buildMenuItem(context, "لوحة التحكم", DashboardPage()),
          _buildMenuItem(context, "المستخدمون", UsersPage()),
          _buildMenuItem(context, "المشاريع", ProjectsPage()),
          _buildMenuItem(context, "الأفكار", IdeasPage()),
          _buildMenuItem(context, "الدورات", Courses()),
          _buildMenuItem(context, "أكثر المستخدمين نشاطًا", ActiveUsers()),
          _buildMenuItem(context, "الفيد باك", FeedbackPage()),
          _buildMenuItem(context, "المنح", Grantpage()),
          _buildMenuItem(context, "الإشعارات", Notifications()),
          _buildMenuItem(context, "الرسائل", ChatScreen()),
          _buildMenuItem(context, "تسجيل خروج", WelcomeScreen()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white54)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildMainContent(BuildContext context, feedbackList) {
    return feedbackList == null
        ? Center(child: CircularProgressIndicator())
        : Center(
      child: Column(
        children: [
          _buildHeader(),
          _buildTitle(),
          Expanded(
              child: feedbackList == null
                  ? Center(child: CircularProgressIndicator())
                  : FeedbackTable(feedbackList: feedbackList)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const Text(
        "الفيدباك",
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(color: const Color(0xFF2B2B2B)),
      child: Row(
        children: [
          const Spacer(),
          _buildSearchBar(),
          const SizedBox(width: 20),
          const ProfileCard(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          hintText: "بحث",
          hintStyle: const TextStyle(color: Colors.white54),
          fillColor: const Color(0xFF4A4A4A),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white54),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackTable extends StatefulWidget {
  List<dynamic>? feedbackList;

  FeedbackTable({Key? key, required this.feedbackList}) : super(key: key);

  @override
  State<FeedbackTable> createState() => _FeedbackTableState();
}

class _FeedbackTableState extends State<FeedbackTable> {
  FeedbackController feedbackController = FeedbackController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF4A4A4A),
                borderRadius: BorderRadius.circular(8)),
            child: DataTable(
              columnSpacing: 16,
              horizontalMargin: 10,
              dataRowHeight: 48,
              columns: const [
                DataColumn(
                    label: Text("اسم المستخدم",
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text("البريد الإلكتروني",
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text("الفيدباك",
                        style: TextStyle(color: Colors.white))),
                DataColumn(
                    label: Text("الإجراءات",
                        style: TextStyle(color: Colors.white))),
              ],
              rows: widget.feedbackList!.map((feedback) {
                return DataRow(cells: [
                  DataCell(Text(feedback["userName"]!,
                      style: const TextStyle(color: Colors.white))),
                  DataCell(Text(feedback["createdBy"]!,
                      style: const TextStyle(color: Colors.white))),
                  DataCell(
                      // Text(feedback["description"]!,
                      // style: const TextStyle(color: Colors.white))
                    IconButton(
                      icon:Icon( Icons.preview_outlined,),
                      onPressed: () {
                        showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) {

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 300.0,vertical: 200.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Scaffold(
                                  body: SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Center(child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(feedback["description"]!),
                                          SizedBox(
                                              width: 80,
                                              child: ElevatedButton(onPressed: (){
                                                Navigator.of(context).pop();
                                              }, child: Text('اغلاق')))
                                        ],
                                      ))),
                                ),
                              ),
                            );


                        },);


                      },
                    )
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        String feedbackId = feedback["_id"]!;
                        feedbackController.deleteFeedback(feedbackId);
                        if (widget.feedbackList != null) {
                          widget.feedbackList!.clear();
                          widget.feedbackList =
                          await feedbackController.getAllFeedbackForAdmin();
                        } else {
                          widget.feedbackList =
                          await feedbackController.getAllFeedbackForAdmin();
                        }
                        setState(() {});

                        // Handle delete action here
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: const Color(0xFF4A4A4A),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/defaultpfp.jpg"),
            radius: 19,
          ),
          const SizedBox(width: 10.0),
          const Text(
            "اسم الادمن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}