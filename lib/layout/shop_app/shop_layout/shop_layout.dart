import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/modules/shop_app/search/search_screen.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopHomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context)=> ShopHomeCubit()..getHomeData()..getCategoriesData()
        ..getFavoritesData()..getProfileData(),
      child: BlocConsumer<ShopHomeCubit,ShopHomeStates>(
        listener: (BuildContext context, ShopHomeStates state) {  },
        builder: (BuildContext context, ShopHomeStates state) {
          var cubit = ShopHomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
                title:const Text('Salla'),
                actions: [
                  IconButton(
                      onPressed: (){
                        NavigateTo(context, ShopSearchScreen(homeContext: context,));
                      },
                      icon: const Icon(Icons.search)
                  )
                ],
            ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomItems,
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