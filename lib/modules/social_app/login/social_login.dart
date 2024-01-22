

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/social_app/social_layout.dart';
import 'package:first_flutter/modules/social_app/login/cubit/login_cubit.dart';
import 'package:first_flutter/modules/social_app/login/cubit/login_states.dart';
import 'package:first_flutter/modules/social_app/register/social_register.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:first_flutter/shared/components/constants.dart';
import 'package:first_flutter/shared/network/local/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginScreen extends StatelessWidget{
  SocialLoginScreen({super.key});


  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
        listener: (context, state) {
          if(state is SocialLoginSuccessState){
            SharedPrefHelper.saveData(key: 'uId', value: state.uId).then((value){
              uId = state.uId;
              NavigateWithoutBack(context,  SocialLayout());
            });
          }else if(state is SocialLoginErrorState){
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
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          'Login now to communicate with your friends',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.background
                          ),
                        ),
                        const SizedBox(height: 30,),
                        DefaultTextField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'Email address',
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
                            suffix: SocialLoginCubit.get(context).isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined,
                            validate: (value){
                              if(value==null || value.isEmpty){
                                return 'Password is too short';
                              }
                            },
                            onSubmit: (value){
                              if(formKey.currentState!.validate()){
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }
                            },
                            suffixPressed: (){
                              SocialLoginCubit.get(context).changePasswordVisibility();
                            },
                            isPassword: SocialLoginCubit.get(context).isPassword,
                            iconsColor: Theme.of(context).colorScheme.background
                        ),
                        const SizedBox(height: 20,),
                        ConditionalBuilder(
                            condition: state is !SocialLoginLoadingState,
                            builder: (context) => defaultButton(
                              onClick: (){
                                if(formKey.currentState!.validate()){
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                }
                              },
                              text: 'login',
                            ),
                            fallback: (context)=> const Center(child: CircularProgressIndicator())
                        ),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface
                              ),
                            ),
                            defaultTextButton(
                              onClick:(){
                                NavigateTo(context, SocialRegisterScreen());
                              },
                              text: 'register',
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