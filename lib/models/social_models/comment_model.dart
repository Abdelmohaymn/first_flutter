

import 'package:first_flutter/models/social_models/user_model.dart';

class CommentModel {
  late String uId;
  late String pId;
  String? text;
  late UserModel user;
  String dateTime = DateTime.now().toString();

  CommentModel({
    required this.uId,
    required this.pId,
    this.text,
  });

  CommentModel.fromJson(Map<String,dynamic> json){
    pId = json['pId'];
    uId = json['uId'];
    text = json['text'];
    dateTime = json['dateTime'];
  }

  Map<String,dynamic> toJson(){
    return {
      'pId':pId,
      'uId':uId,
      'text':text,
      'dateTime':dateTime,
    };
  }

}