
import 'package:first_flutter/models/shop_models/register_model.dart';
import 'package:first_flutter/modules/shop_app/Register/cubit/Register_states.dart';
import 'package:first_flutter/shared/network/end_points.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{

  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;
  RegisterModel? registerModel;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    emit(ShopRegisterPasswordVisibilityState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
}){

    emit(ShopRegisterLoadingState());
    DioHelper.postData(
        path: REGISTER,
        data: {
          'name':name,
          'email':email,
          'password':password,
          'phone':phone
        }
    ).then((value){
      registerModel = RegisterModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(registerModel!));
    }).catchError((error){
      emit(ShopRegisterErrorState());
    });
  }

}