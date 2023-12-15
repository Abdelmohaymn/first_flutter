
class ChangeFavoriteModel {
  bool? status;
  String? message;

  ChangeFavoriteModel.fromJson(Map<String,dynamic>json){
    status = json['status'];
    message = json['message'];
  }
}