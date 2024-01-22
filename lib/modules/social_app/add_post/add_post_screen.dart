
import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class AddPostScreen extends StatelessWidget
{
  final BuildContext socialCubitContext;
  AddPostScreen({required this.socialCubitContext,super.key});

  var postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SocialCubit>(socialCubitContext),
      child: BlocConsumer<SocialCubit,SocialStates>(
        listener: (BuildContext context, SocialStates state) {
          if(state is SocialPostSuccessState){
            defaultToast(message: 'Posted successfully', state: ToastStates.SUCCESS);
          }else if(state is SocialPostErrorState){
            defaultToast(message: 'Error: ${state.error}', state: ToastStates.ERROR);
          }
        },
        builder: (BuildContext context, SocialStates state) {
          var cubit = SocialCubit.get(context);
          
          return WillPopScope(
            onWillPop: () async {
              cubit.onBackFromAddPostScreen(context);
              return false;
            },
            child: Scaffold(
              appBar: defaultAppBar(
                context: context,
                title: 'Add post',
                onBack: (){cubit.onBackFromAddPostScreen(context);},
                actions: [
                  defaultTextButton(
                    onClick:(){
                      if(postTextController.text.isNotEmpty || cubit.postImage!=null){
                        cubit.createNewPost(text: postTextController.text, context: context);
                      }
                    },
                    text: 'post',
                  ),

                ]
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children:[
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          if(state is SocialPostLoadingState)
                            const LinearProgressIndicator(
                              minHeight: 2,
                            ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(cubit.userModel!.image??defaultProfileImage),
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                cubit.userModel!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            child: TextFormField(
                              controller: postTextController,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'What are you thinking about?',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                              ),
                              maxLines: null,
                              onChanged: (value){
                              },
                            ),
                          ),
                          const SizedBox(height:20,),
                          if(cubit.postImage!=null)
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: double.infinity,
                              height: 150,
                              alignment: AlignmentDirectional.topEnd,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(cubit.postImage!),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              child: TouchRippleEffect(
                                rippleColor: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                onTap: (){
                                  cubit.deletePostImage();
                                },
                                child: const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: defaultColor,
                                  child: Icon(
                                    IconBroken.Delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          //Expanded(child: Container()),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: (){
                                  cubit.getImage(type: 'postImage');
                                },
                                child: const Row(
                                  children: [
                                    Icon(IconBroken.Image),
                                    SizedBox(width: 5,),
                                    Text('Add a photo')
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: (){},
                                child: const Text('# tags'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] ,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}