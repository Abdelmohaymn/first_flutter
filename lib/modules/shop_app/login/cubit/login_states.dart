
import 'package:first_flutter/models/shop_models/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}

class ShopLoginSuccessState extends ShopLoginStates{
  final ShopLoginModel model;
  ShopLoginSuccessState(this.model);
}

class ShopLoginErrorState extends ShopLoginStates{
  final String error;

  ShopLoginErrorState(this.error);
}

class ShopLoginPasswordVisibilityState extends ShopLoginStates{}