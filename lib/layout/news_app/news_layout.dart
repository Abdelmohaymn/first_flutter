
import 'package:first_flutter/modules/news_app/search/search.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/cubit/cubit.dart';
import 'package:first_flutter/shared/news_cubit/news_cubit.dart';
import 'package:first_flutter/shared/news_cubit/news_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsLayout extends StatelessWidget{
  const NewsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewsCubit()..getData(
        country: 'eg',
        category: 'business'
      ),
      child: BlocConsumer<NewsCubit,NewsStates>(
        listener: (context,state) { },
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                  'News',
              ),
              actions: [
                IconButton(
                    onPressed: (){
                      NewsCubit.get(context).emptySearchArticles();
                      NavigateTo(context,SearchScreen());
                    },
                    icon: const Icon(Icons.search)
                ),
                IconButton(
                    onPressed: (){
                      AppCubit.get(context).changeAppThemeMode();
                    },
                    icon: const Icon(Icons.brightness_4_outlined)
                )
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottomNavIndex(index);
              },
            ),
          );
        },
      ),
    );
  }


}