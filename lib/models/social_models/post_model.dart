

import 'package:first_flutter/models/social_models/user_model.dart';

class PostModel {
  late String uId;
  String? pId;
  String? text;
  String? postImage;
  late String dateTime;
  UserModel? user;
  List<String>?usersLikes;
  int likesCount=0;

  PostModel({
    required this.uId,
    this.text,
    this.postImage,
    required this.dateTime,
  });

  PostModel.fromJson(Map<String,dynamic> json){
    pId = json['pId'];
    uId = json['uId'];
    text = json['text'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
  }

  Map<String,dynamic> toJson(){
    return {
      'pId':pId,
      'uId':uId,
      'text':text,
      'postImage':postImage,
      'dateTime':dateTime,
    };
  }

}