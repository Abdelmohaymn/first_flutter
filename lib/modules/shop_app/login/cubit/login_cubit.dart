
import 'package:first_flutter/models/shop_models/login_model.dart';
import 'package:first_flutter/modules/shop_app/login/cubit/login_states.dart';
import 'package:first_flutter/shared/network/end_points.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{

  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    emit(ShopLoginPasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password
}){
    emit(ShopLoginLoadingState());

    DioHelper.postData(
        path: LOGIN,
        data: {
          'email':email,
          'password':password
        }
    ).then((value){
      //print(value.data['status']);
      emit(ShopLoginSuccessState(ShopLoginModel.fromJson(value.data)));
    }).catchError((error){
      print('Error ${error.toString()}');
      emit(ShopLoginErrorState(error.toString()));
    });
  }

}