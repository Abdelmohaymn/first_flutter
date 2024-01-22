

import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/modules/social_app/add_post/add_post_screen.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLayout extends StatelessWidget{
  SocialLayout({super.key});

  late var cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData()..getPosts()..getUsers(),
      child: BlocConsumer<SocialCubit,SocialStates>(
        listener: (context, state) {
          if(state is SocialAddPostState){
              NavigateTo(context, AddPostScreen(socialCubitContext:context));
          }
        },
        builder: (context, state) {
          cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.getTitle()),
              actions: [
                IconButton(
                    onPressed: (){},
                    icon: const Icon(IconBroken.Notification)
                ),
                IconButton(
                    onPressed: (){},
                    icon: const Icon(IconBroken.Search)
                ),
                defaultTextButton(onClick: (){cubit.logout(context);}, text: 'logout'),
              ],
            ),
            body:  /*ConditionalBuilder(
              condition: cubit.userModel!=null,
              builder: (context) => Column(
                children: [
                  if(!FirebaseAuth.instance.currentUser!.emailVerified)
                      Container(
                      color: Colors.amber.withOpacity(.6),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.exclamationmark_octagon),
                          const SizedBox(width: 20,),
                          const Text('Please verify your email',style: TextStyle(color: Colors.black),),
                          const Spacer(),
                          TextButton(
                              onPressed: (){
                                FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value){
                                  defaultToast(
                                      message: 'Check your email',
                                      state: ToastStates.SUCCESS
                                  );
                                }).catchError((error){
                                  defaultToast(
                                      message: error.toString(),
                                      state: ToastStates.ERROR
                                  );
                                });
                              },
                              child: const Text('Send')
                          )
                        ],
                      ),
                    ),
                      const SizedBox(height: 10,),

                ],
              ),
              fallback: (context) => const Center(child: CircularProgressIndicator(),),
            )*/
            cubit.defaultScreen(),
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.items,
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