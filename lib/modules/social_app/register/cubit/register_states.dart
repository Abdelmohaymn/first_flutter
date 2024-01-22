

abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates{}

class SocialRegisterLoadingState extends SocialRegisterStates{}

class SocialRegisterSuccessState extends SocialRegisterStates{}

class SocialRegisterErrorState extends SocialRegisterStates{
  final String message;
  SocialRegisterErrorState(this.message);
}

class SocialRegisterCreateUserSuccessState extends SocialRegisterStates{
  final String uId;
  SocialRegisterCreateUserSuccessState(this.uId);
}

class SocialRegisterCreateUserErrorState extends SocialRegisterStates{}

class SocialRegisterPasswordVisibilityState extends SocialRegisterStates{}