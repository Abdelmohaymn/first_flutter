class RegisterModel {

  RegisterModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

}

class Data {

  Data.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    image = json['image'];
    token = json['token'];
  }
  String? name;
  String? email;
  String? phone;
  num? id;
  String? image;
  String? token;

}