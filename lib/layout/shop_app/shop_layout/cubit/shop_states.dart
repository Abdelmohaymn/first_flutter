
import 'package:first_flutter/models/shop_models/ShopHomeModel.dart';
import 'package:first_flutter/models/shop_models/change_favorite.dart';
import 'package:first_flutter/models/shop_models/login_model.dart';

abstract class ShopHomeStates {}

class ShopHomeInitialState extends ShopHomeStates{}

class ShopHomeBottomNavState extends ShopHomeStates{}

class ShopHomeLoadingState extends ShopHomeStates{}

class ShopHomeSuccessState extends ShopHomeStates{
  final ShopHomeModel model;
  ShopHomeSuccessState(this.model);
}

class ShopHomeErrorState extends ShopHomeStates{
  final String error;
  ShopHomeErrorState(this.error);
}

class ShopCategoriesSuccessState extends ShopHomeStates{}

class ShopCategoriesErrorState extends ShopHomeStates{}

class ShopHomeChangeFavoriteState extends ShopHomeStates{}

class ShopHomeChangeFavoriteSuccessState extends ShopHomeStates{
  final ChangeFavoriteModel model;
  ShopHomeChangeFavoriteSuccessState(this.model);
}

class ShopHomeChangeFavoriteErrorState extends ShopHomeStates{}

class ShopFavoritesLoadingState extends ShopHomeStates{}

class ShopFavoritesSuccessState extends ShopHomeStates{}

class ShopFavoritesErrorState extends ShopHomeStates{}

class ShopHomeLoginLoadingState extends ShopHomeStates{}

class ShopHomeLoginSuccessState extends ShopHomeStates{}

class ShopHomeLoginErrorState extends ShopHomeStates{}

class ShopHomeLogoutLoadingState extends ShopHomeStates{}

class ShopHomeLogoutSuccessState extends ShopHomeStates{}

class ShopUpdateProfLoadingState extends ShopHomeStates{}

class ShopUpdateProfSuccessState extends ShopHomeStates{
  final ShopLoginModel model;
  ShopUpdateProfSuccessState(this.model);
}

class ShopUpdateProfErrorState extends ShopHomeStates{}