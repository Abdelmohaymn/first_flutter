

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter/models/social_models/user_model.dart';
import 'package:first_flutter/modules/social_app/register/cubit/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates>{

  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = false;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    emit(SocialRegisterPasswordVisibilityState());
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
}){
    FirebaseFirestore
        .instance
        .collection('users')
        .doc(uId)
        .set(UserModel(
            name: name,
            email: email,
            phone: phone,
            uId: uId,
            isEmailVerified: false
        ).toJson())
        .then((value) {
      emit(SocialRegisterCreateUserSuccessState(uId));
    }).catchError((error){
      print('Errorrrrrrrr : ${error.toString()}');
      emit(SocialRegisterCreateUserErrorState());
    });
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
}){

    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value){
      createUser(name: name, email: email, phone: phone, uId: value.user!.uid);
      //emit(SocialRegisterSuccessState());
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

}