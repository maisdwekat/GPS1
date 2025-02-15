import 'dart:convert';

import 'package:ggg_hhh/models/user_model.dart';

class ChatModel {
  String userid;
  String name;
  List massages;
  ChatModel({required this.userid,required this.name,required this.massages});
  factory ChatModel.fromJson(dynamic json, List<User>users) {
    String userid = json['userId'].toString();
    print(userid);
    String name=users.where((element) => element.id==userid).first.name;
    print(json['messages']);
    return ChatModel(userid: userid, name: name, massages:json['messages'] as List);
  }
}
