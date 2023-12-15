
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      )
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String,dynamic>? query,
    String? token,
    String lang = 'en'
}) async{

    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type':'application/json'
    };

    return await dio.get(
      path,
      queryParameters: query
    );
  }

  static Future<Response> postData({
    required String path,
    required Map<String,dynamic> data,
    Map<String,dynamic>? query,
    String? token,
    String lang = 'en'
  }) async{

    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type':'application/json'
    };
    return await dio.post(
      path,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String path,
    required Map<String,dynamic> data,
    Map<String,dynamic>? query,
    String? token,
    String lang = 'en'
  }) async{

    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
      'Content-Type':'application/json'
    };
    return await dio.put(
      path,
      data: data,
      queryParameters: query,
    );
  }

}