
import 'package:first_flutter/models/social_models/user_model.dart';

abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{
  final UserModel user;
  SocialGetUserSuccessState(this.user);
}

class SocialGetUserErrorState extends SocialStates{
  final String error;
  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavIndexState extends SocialStates{}

class SocialAddPostState extends SocialStates{}

class SocialPickImageSuccessState extends SocialStates{}

class SocialPickImageErrorState extends SocialStates{}

class SocialUpdateUserDataLoadingState extends SocialStates{}

class SocialUpdateUserDataSuccessState extends SocialStates{}

class SocialUpdateUserDataErrorState extends SocialStates{
  final String error;
  SocialUpdateUserDataErrorState(this.error);
}

class SocialPostLoadingState extends SocialStates{}

class SocialPostSuccessState extends SocialStates{}

class SocialPostErrorState extends SocialStates{
  final String error;
  SocialPostErrorState(this.error);
}

class SocialDeletePostImageState extends SocialStates{}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {}

class SocialGetUsersLoadingState extends SocialStates {}

class SocialGetUsersSuccessState extends SocialStates {}

class SocialGetUsersErrorState extends SocialStates {}

class SocialLikePostSuccessState extends SocialStates {}

class SocialChangeLikePostState extends SocialStates {}

class SocialLogoutLoadingState extends SocialStates {}

class SocialLogoutSuccessState extends SocialStates {}

class SocialAddCommentSuccessState extends SocialStates {}

class SocialGetCommentsLoadingState extends SocialStates {}

class SocialGetCommentsSuccessState extends SocialStates {}

class SocialCommentsErrorState extends SocialStates {}

class SocialChangeIconCommentColorState extends SocialStates {}


