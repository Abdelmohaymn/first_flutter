
import 'package:first_flutter/shared/components/constants.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.isEmailVerified,
    this.image,
    this.cover,
    this.bio,
  });

  UserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image']??defaultProfileImage;
    cover = json['cover']??defaultCoverImage;
    bio = json['bio']??'write your bio...';
    isEmailVerified = json['isEmailVerified']??false;
  }

  Map<String,dynamic> toJson(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image==defaultProfileImage?null:image,
      'cover':cover==defaultCoverImage?null:cover,
      'bio':bio=='write your bio...'?null:bio,
      'isEmailVerified':isEmailVerified
    };
  }

}