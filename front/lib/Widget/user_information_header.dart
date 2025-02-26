import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../Controllers/token_controller.dart';

class UserInformationHeader extends StatefulWidget {
  const UserInformationHeader({super.key});

  @override
  State<UserInformationHeader> createState() => _UserInformationHeaderState();
}

class _UserInformationHeaderState extends State<UserInformationHeader> {
  Uint8List? _profileImage;
  TokenController tokenController = TokenController();
  var user;
  String? token;
  void _getToken() async {
    String? savedToken = await tokenController.getToken();

    if (savedToken != null) {
      print('تم العثور على التوكن: $savedToken');
      var user =await tokenController.decodedToken(savedToken);
      this.user=user['name'];

  }
  setState(() {

  });
  }
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImage = bytes;
      });
    }
  }
  @override
  void initState() {
    _getToken(); // استدعاء دالة _getToken
    if(token!=null){
      print("not null $token");
      user= tokenController.decodedToken(token!);
    }
    else{
      print("token is null");
    }
    print(token);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.grey[200],
      padding: EdgeInsets.all(10),
      child:user==null? Center(child: CircularProgressIndicator()): Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
          user,
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
                  backgroundImage: _profileImage != null
                      ? MemoryImage(_profileImage!)
                      : const AssetImage('assets/images/defaultpfp.jpg') as ImageProvider,
                  child: _profileImage == null
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
}

