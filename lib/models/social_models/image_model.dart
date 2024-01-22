
class ImageModel {
  late String hash;
  late String downloadUrl;

  ImageModel({
    required this.hash,
    required this.downloadUrl
  });

  ImageModel.fromJson(Map<String,dynamic> json){
    hash = json['hash'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String,dynamic> toJson(){
    return {
      'hash':hash,
      'downloadUrl':downloadUrl,
    };
  }
}