
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/models/shop_models/ShopHomeModel.dart';
import 'package:first_flutter/models/shop_models/categories_model.dart';
import 'package:first_flutter/models/shop_models/change_favorite.dart';
import 'package:first_flutter/models/shop_models/favorites_model.dart';
import 'package:first_flutter/models/shop_models/login_model.dart';
import 'package:first_flutter/modules/shop_app/categories/categories_screen.dart';
import 'package:first_flutter/modules/shop_app/favorites/favorites_screen.dart';
import 'package:first_flutter/modules/shop_app/login/shop_login.dart';
import 'package:first_flutter/modules/shop_app/products/products_screen.dart';
import 'package:first_flutter/modules/shop_app/settings/settings_screen.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/network/end_points.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopHomeCubit extends Cubit<ShopHomeStates>{

  ShopHomeCubit():super(ShopHomeInitialState());

  static ShopHomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const ShopProductsScreen(),
    const ShopCategoriesScreen(),
    const ShopFavoritesScreen(),
     ShopSettingsScreen()
  ];

  List<BottomNavigationBarItem> bottomItems = [
    defaultBottomNavItem('Home',Icons.home),
    defaultBottomNavItem('Categories',Icons.apps),
    defaultBottomNavItem('Favorites',Icons.favorite),
    defaultBottomNavItem('Settings',Icons.settings)
  ];

  ShopHomeModel? model;
  CategoriesModel? categoriesModel;
  ChangeFavoriteModel? changeFavModel;
  FavoritesModel? favoritesModel;
  ShopLoginModel? loginModel;
  ShopLoginModel? updateModel;
  Map<int,bool> favorites = {};


  void changeBottomNavIndex(int index){
    currentIndex = index;
    emit(ShopHomeBottomNavState());
  }

  void getHomeData(){
    emit(ShopHomeLoadingState());
    DioHelper.getData(
        path: HOME,
        token: token
    )
        .then((value) => {
          model = ShopHomeModel.fromJson(value.data),
          model!.data!.products!.forEach((element) {
            favorites[(element.id) as int] = element.inFavorites!;
          }),
          //print('Dataaaaaaa ${model!.status}'),
          emit(ShopHomeSuccessState(model!))
    }).catchError((error){
      //print('Error : ${error.toString()}');
      emit(ShopHomeErrorState(error.toString()));
    });
  }

  void getCategoriesData(){
    DioHelper.getData(
        path: CATEGORIES,
    )
        .then((value) => {
      categoriesModel = CategoriesModel.fromJson(value.data),
      print('Dataaaaaaa ${categoriesModel!.status}'),
      emit(ShopCategoriesSuccessState())
    }).catchError((error){
      print('Error : ${error.toString()}');
      emit(ShopCategoriesErrorState());
    });
  }

  void changeFavorite(productId){
    favorites[productId] = !favorites[productId]!;
    emit(ShopHomeChangeFavoriteState());
    DioHelper.postData(
        path: FAVORITES,
        data: {'product_id':productId},
        token: token
    ).then((value) => {
      changeFavModel = ChangeFavoriteModel.fromJson(value.data),
      if(!changeFavModel!.status!){
        favorites[productId] = !favorites[productId]!,
      }else{
        getFavoritesData()
      },
      emit(ShopHomeChangeFavoriteSuccessState(changeFavModel!))
    }).catchError((error){
      favorites[productId] = !favorites[productId]!;
      emit(ShopHomeChangeFavoriteErrorState());
    });
  }

  void getFavoritesData(){
    emit(ShopFavoritesLoadingState());
    DioHelper.getData(
      path: FAVORITES,
      token: token
    ).then((value) => {
      favoritesModel = FavoritesModel.fromJson(value.data),
      emit(ShopFavoritesSuccessState())
    }).catchError((error){
      emit(ShopFavoritesErrorState());
    });
  }

  void getProfileData(){
    emit(ShopHomeLoginLoadingState());
    DioHelper.getData(
        path: PROFILE,
        token: token
    ).then((value) => {
      loginModel = ShopLoginModel.fromJson(value.data),
      emit(ShopHomeLoginSuccessState())
    }).catchError((error){
      emit(ShopHomeLoginErrorState());
    });
  }

  void updateProfileData({
    required String name,
    required String email,
    required String phone
  }){
    emit(ShopUpdateProfLoadingState());
    DioHelper.putData(
        path: UPDATE_PROFILE,
        data:{
          'name':name,
          'email':email,
          'phone':phone,
        },
        token: token
    ).then((value) => {
      updateModel = ShopLoginModel.fromJson(value.data),
      if(updateModel!.status!){
        loginModel!.data!.name = name,
        loginModel!.data!.email = email,
        loginModel!.data!.phone = phone,
      },
      emit(ShopUpdateProfSuccessState(updateModel!))
    }).catchError((error){
      emit(ShopUpdateProfErrorState());
    });
  }


  void signOut(context){
    emit(ShopHomeLogoutLoadingState());
    SharedPrefHelper.removeData(key:'token').then((value) => {
      if(value){
        NavigateWithoutBack(context,ShopLoginScreen()),
        //currentIndex = 0,
        emit(ShopHomeLogoutSuccessState())
      }
    });
  }

}
