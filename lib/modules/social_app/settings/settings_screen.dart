
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/modules/social_app/edit_profile/edit_profile.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialSettingsScreen extends StatelessWidget{
  const SocialSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (BuildContext context, SocialStates state) {  },
      builder: (BuildContext context, SocialStates state) {
        var cubit = SocialCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConditionalBuilder(
              condition: cubit.userModel!=null,
              builder: (context)=> Column(
                children: [
                  if(state is SocialLogoutLoadingState)
                    const LinearProgressIndicator(),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 185,
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(cubit.userModel!.cover??'https://venngage-wordpress.s3.amazonaws.com/uploads/2018/04/arrows-in-circles.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4) ,
                                topRight: Radius.circular(4),
                              )
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 38,
                          backgroundImage: NetworkImage(cubit.userModel!.image??'https://i.pinimg.com/564x/09/e4/30/09e430cffab1d633f178e3228e9f9b81.jpg'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    cubit.userModel!.name!,
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    cubit.userModel!.bio??'write your bio...',
                    style: const TextStyle(color: Colors.grey,fontSize: 13),
                  ),
                  const SizedBox(height: 20,),
                  const Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'posts',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'posts',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'posts',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'posts',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: OutlinedButton(
                          onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                              'Add photos'
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: (){
                            NavigateTo(context, EditProfileScreen(socialCubitContext: context,));
                          },
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          child: const Icon(
                              Icons.edit_outlined
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              fallback: (context)=> const Center(child: CircularProgressIndicator(),)
          )
        );
      },
    );
  }

}