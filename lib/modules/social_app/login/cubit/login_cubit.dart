

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter/modules/social_app/login/cubit/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates>{

  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    emit(SocialLoginPasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password
}){
    emit(SocialLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    )
    .then((value){
      print('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHH${value.user!.uid}');
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      //print('Errorrrrr ${error.toString()}');
      emit(SocialLoginErrorState(error.toString()));
    });
  }

}