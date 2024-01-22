
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/cubit/social_cubit.dart';
import 'package:first_flutter/layout/social_app/cubit/social_states.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/styles/colors.dart';
import 'package:first_flutter/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class EditProfileScreen extends StatelessWidget{

  final BuildContext socialCubitContext;
  EditProfileScreen({required this.socialCubitContext,super.key});

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider.value(
      value: BlocProvider.of<SocialCubit>(socialCubitContext),
      child: BlocConsumer<SocialCubit,SocialStates>(
        listener: (BuildContext context, SocialStates state) {
          if(state is SocialUpdateUserDataSuccessState){
            defaultToast(
                message: 'Updated successfully',
                state: ToastStates.SUCCESS
            );
          }else if(state is SocialUpdateUserDataErrorState){
            defaultToast(
                message: 'Error: ${state.error}',
                state: ToastStates.ERROR
            );
          }
        },
        builder: (BuildContext context, SocialStates state) {
          var cubit = SocialCubit.get(context);
          nameController.text = cubit.userModel!.name!;
          if(cubit.userModel!.bio!=null){
            bioController.text = cubit.userModel!.bio!;
          }

          return WillPopScope(
            onWillPop: () async{
              cubit.onBackFromEditScreen(context);
              return false;
            },
            child: Scaffold(
              appBar: defaultAppBar(
                onBack: (){
                  cubit.onBackFromEditScreen(context);
                },
                context:context,
                title: 'Edit profile',
                actions:[
                  ConditionalBuilder(
                      condition: state is !SocialUpdateUserDataLoadingState,
                      builder: (context) => defaultTextButton(
                        onClick: (){
                          if(formKey.currentState!.validate()){
                            cubit.updateUserData(name: nameController.text, bio: bioController.text,context:context);
                          }
                        },
                        text: 'update',
                      ),
                      fallback: (context)=> const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2,)
                        ),
                      )
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: 185,
                              color: Colors.white,
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: double.infinity,
                                height: 150,
                                alignment: Alignment.topRight,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: cubit.defaultCoverImage(),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4) ,
                                      topRight: Radius.circular(4),
                                    )
                                ),
                                child: TouchRippleEffect(
                                  rippleColor: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: (){
                                    cubit.getImage(type: 'cover');
                                  },
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: defaultColor,
                                    child: Icon(
                                      IconBroken.Camera,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 38,
                                backgroundImage: cubit.defaultProfImage(),
                                child: Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: TouchRippleEffect(
                                    rippleColor: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: (){
                                      cubit.getImage(type: 'profile');
                                    },
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: defaultColor,
                                      child: Icon(
                                        IconBroken.Camera,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        DefaultTextField(
                            controller: nameController,
                            type: TextInputType.text,
                            label: 'Name',
                            prefix: IconBroken.User,
                            validate: (value){
                              if(value==null||value.isEmpty){
                                return 'Name must not be empty';
                              }
                            }
                        ),
                        const SizedBox(height: 10,),
                        DefaultTextField(
                          controller: bioController,
                          type: TextInputType.text,
                          label: 'Bio',
                          prefix: IconBroken.Info_Circle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

}