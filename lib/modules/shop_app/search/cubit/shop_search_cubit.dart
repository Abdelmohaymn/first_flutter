
import 'package:bloc/bloc.dart';
import 'package:first_flutter/models/shop_models/search_model.dart';
import 'package:first_flutter/modules/shop_app/search/cubit/shop_search_states.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/network/end_points.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopSearchCubit extends Cubit<ShopSearchStates>{
  
  ShopSearchCubit():super(ShopSearchInitialState());
  
  static ShopSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;
  
  void searchProducts(String search){
    emit(ShopSearchLoadingState());
    DioHelper.postData(
      path: SEARCH_PRODUCTS,
      data: {'text':search},
      token: token
    ).then((value){
      model = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessState());
    }).catchError((error){
      emit(ShopSearchErrorState());
    });
  }
  
}