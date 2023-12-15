
import 'package:first_flutter/models/shop_models/register_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates{
  final RegisterModel model;
  ShopRegisterSuccessState(this.model);
}

class ShopRegisterErrorState extends ShopRegisterStates{}

class ShopRegisterPasswordVisibilityState extends ShopRegisterStates{}