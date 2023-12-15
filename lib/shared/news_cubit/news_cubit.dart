
import 'package:first_flutter/modules/news_app/business/business.dart';
import 'package:first_flutter/modules/news_app/science/science.dart';
import 'package:first_flutter/modules/news_app/sports/sports.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:first_flutter/shared/news_cubit/news_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit():super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<String> categories = ['business','sports','science',];
  List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.business
      ),
      label: 'Business'
    ),
    const BottomNavigationBarItem(
        icon: Icon(
            Icons.sports
        ),
        label: 'Sports'
    ),
    const BottomNavigationBarItem(
        icon: Icon(
            Icons.science
        ),
        label: 'Science'
    ),
  ];

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];

  List<dynamic> articles = [];
  List<dynamic> searchArticles = [];

  void changeBottomNavIndex(index){
    currentIndex = index;
    emit(NewsBottomNavState());
    getData(
        country: 'eg',
        category: categories[currentIndex]
    );
  }


  void getData({
    required String country,
    required String category
  }){
    emit(NewsLoadingDataState());
    DioHelper.getData(
      path: 'v2/top-headlines',
      query: {
        'country':country,
        'category':category,
        'apiKey':'c6664d39f646484293c47d5cae67c6f9'
      }
    ).then((value){
      articles = value.data['articles'];
      //print(articles[0]['title']);
      emit(NewsGetSuccessDataState());
    }).catchError((error){
      emit(NewsGetErrorDataState(error.toString()));
      //print('Errorrrrrrr : ${error.toString()}');
    });
  }

  void getSearchArticles({
    required String search
  }){
    emit(NewsLoadingDataState());
    DioHelper.getData(
        path: 'v2/everything',
        query: {
          'q':search,
          'apiKey':'c6664d39f646484293c47d5cae67c6f9'
        }
    ).then((value){
      searchArticles = value.data['articles'];
      emit(NewsGetSuccessDataState());
    }).catchError((error){
      emit(NewsGetErrorDataState(error.toString()));
    });
  }

  void emptySearchArticles(){
    searchArticles.clear();
    emit(NewsEmptySearchArticleState());
  }

}