
import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter/layout/social_app/social_layout.dart';
import 'package:first_flutter/modules/shop_app/onboarding/onboarding.dart';
import 'package:first_flutter/modules/social_app/login/social_login.dart';
import 'package:first_flutter/shared/block_observer.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/cubit/cubit.dart';
import 'package:first_flutter/shared/cubit/states.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:first_flutter/shared/network/remote/dio_helper.dart';
import 'package:first_flutter/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'firebase_options.dart';


//for handshake error
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await SharedPrefHelper.init();

  Widget startSocial = const OnboardingScreen();
  bool onBoarding = SharedPrefHelper.getData(key: 'onBoarding')??true;
  bool isDark = SharedPrefHelper.getData(key: 'isDark')??false;
  /*token = SharedPrefHelper.getData(key: 'token');*/
  uId = SharedPrefHelper.getData(key: 'uId');
  if(!onBoarding){
    startSocial = (uId!=null)?SocialLayout():SocialLoginScreen();
  }

  runApp(MyApp(startScreen:startSocial,isDark:isDark));
}

class MyApp extends StatelessWidget {

  final Widget startScreen;
  final bool isDark;
  const MyApp({
    required this.startScreen,
    required this.isDark,
    Key? key
  }) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       /* BlocProvider(
            create: (context) => NewsCubit()..getData(
                country: 'eg',
                category: 'business'
            ),
        ),*/
        BlocProvider(
            create: (context) => AppCubit()
        ),
        /*BlocProvider(
            create: (context)=> ShopHomeCubit()..getHomeData()..getCategoriesData()
              ..getFavoritesData()..getProfileData()
        )*/
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
              theme: lightTheme ,
              darkTheme: darkTheme,
              themeMode: isDark?ThemeMode.dark:ThemeMode.light,
              home: startScreen
          );
        }
      ),
    );
  }
}

