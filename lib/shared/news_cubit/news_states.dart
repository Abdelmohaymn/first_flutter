
abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsBottomNavState extends NewsStates {}

class NewsLoadingDataState extends NewsStates {}

class NewsGetSuccessDataState extends NewsStates {}

class NewsGetErrorDataState extends NewsStates {
  final String error;
  NewsGetErrorDataState(this.error);
}

class NewsEmptySearchArticleState extends NewsStates{}