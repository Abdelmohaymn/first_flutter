
import 'package:first_flutter/models/social_models/image_model.dart';

class MessageModel {
  late String senderId;
  late String receiverId;
  String? textMessage;
  ImageModel? image;
  late String dateTime;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    this.textMessage,
    this.image,
    required this.dateTime,
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    textMessage = json['textMessage'];
    dateTime = json['dateTime'];
    image = json['image']!=null? ImageModel.fromJson(json['image']):null;
  }

  Map<String,dynamic> toJson(){
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'textMessage':textMessage,
      'dateTime':dateTime,
      'image':image!=null? image!.toJson():null,
    };
  }

}