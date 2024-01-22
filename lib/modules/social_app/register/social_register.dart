

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/social_layout.dart';
import 'package:first_flutter/modules/social_app/login/social_login.dart';
import 'package:first_flutter/modules/social_app/register/cubit/register_cubit.dart';
import 'package:first_flutter/modules/social_app/register/cubit/register_states.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterScreen extends StatelessWidget{
  SocialRegisterScreen({super.key});

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit,SocialRegisterStates>(
          listener: (context, state) {
            if(state is SocialRegisterCreateUserSuccessState){
              SharedPrefHelper.saveData(key: 'uId', value: state.uId).then((value){
                uId = state.uId;
                NavigateWithoutBack(context,  SocialLayout());
              });

            }else if(state is SocialRegisterErrorState){
              defaultToast(message: state.message, state: ToastStates.ERROR);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Register',
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Register now to communicate with new friends',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: Theme.of(context).colorScheme.background
                            ),
                          ),
                          const SizedBox(height: 30,),
                          DefaultTextField(
                              controller: nameController,
                              type: TextInputType.text,
                              label: 'Name',
                              prefix: Icons.person,
                              validate: (value){
                                if(value==null || value.isEmpty){
                                  return 'Name mustn\'t be empty';
                                }
                              },
                              iconsColor: Theme.of(context).colorScheme.background
                          ),
                          const SizedBox(height: 20,),
                          DefaultTextField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              label: 'Email',
                              prefix: Icons.email,
                              validate: (value){
                                if(value==null || value.isEmpty){
                                  return 'Please enter your email';
                                }
                              },
                              iconsColor: Theme.of(context).colorScheme.background
                          ),
                          const SizedBox(height: 20,),
                          DefaultTextField(
                              controller: passwordController,
                              type: TextInputType.visiblePassword,
                              label: 'Password',
                              prefix: Icons.lock_outline,
                              suffix: SocialRegisterCubit.get(context).isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined,
                              validate: (value){
                                if(value==null || value.isEmpty){
                                  return 'Password is too short';
                                }
                              },
                              suffixPressed: (){
                                SocialRegisterCubit.get(context).changePasswordVisibility();
                              },
                              isPassword: SocialRegisterCubit.get(context).isPassword,
                              iconsColor: Theme.of(context).colorScheme.background
                          ),
                          const SizedBox(height: 20,),
                          DefaultTextField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              label: 'Phone',
                              prefix: Icons.phone,
                              validate: (value){
                                if(value==null || value.isEmpty){
                                  return 'Phone mustn\'t be empty';
                                }
                              },
                              iconsColor: Theme.of(context).colorScheme.background
                          ),
                          const SizedBox(height: 30,),
                          ConditionalBuilder(
                              condition: state is !SocialRegisterLoadingState,
                              builder: (context) => defaultButton(
                                onClick: (){
                                  if(formKey.currentState!.validate()){
                                    SocialRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text
                                    );
                                  }
                                },
                                text: 'Register',
                              ),
                              fallback: (context)=> const Center(child: CircularProgressIndicator())
                          ),
                          const SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Have an account?',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface
                                ),
                              ),
                              defaultTextButton(
                                onClick:(){
                                  NavigateTo(context, SocialLoginScreen());
                                },
                                text: 'Log in',
                              )
                            ],
                          )
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