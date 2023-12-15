
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_cubit.dart';
import 'package:first_flutter/layout/shop_app/shop_layout/cubit/shop_states.dart';
import 'package:first_flutter/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopSettingsScreen extends StatelessWidget{
  ShopSettingsScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopHomeCubit,ShopHomeStates>(
      listener: (BuildContext context, ShopHomeStates state) {
        if(state is ShopUpdateProfSuccessState){
          if(state.model.status!){
            defaultToast(
                message:state.model.message!,
                state: ToastStates.SUCCESS
            );
          }else{
            defaultToast(
                message:state.model.message!,
                state: ToastStates.ERROR
            );
          }
        }
      },
      builder: (BuildContext context, ShopHomeStates state) {
        var cubit = ShopHomeCubit.get(context);
        if(cubit.loginModel!=null){
          nameController.text = cubit.loginModel!.data!.name!;
          emailController.text =  cubit.loginModel!.data!.email!;
          phoneController.text = cubit.loginModel!.data!.phone!;
        }
        return ConditionalBuilder(
            condition: cubit.loginModel!=null,
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopUpdateProfLoadingState)
                          const LinearProgressIndicator(),
                          const SizedBox(height: 20,),
                      DefaultTextField(
                          controller: nameController,
                          type: TextInputType.text,
                          label: 'Name',
                          prefix: Icons.person,
                          validate: (value){
                            if(value==null||value.isEmpty){
                              return 'Name mustn\'t be empty';
                            }
                          }
                      ),
                      const SizedBox(height: 20,),
                      DefaultTextField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email',
                          prefix: Icons.email,
                          validate: (value){
                            if(value==null||value.isEmpty){
                              return 'Email mustn\'t be empty';
                            }
                          }
                      ),
                      const SizedBox(height: 20,),
                      DefaultTextField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'Phone',
                          prefix: Icons.phone,
                          validate: (value){
                            if(value==null||value.isEmpty){
                              return 'Phone mustn\'t be empty';
                            }
                          }
                      ),
                      const SizedBox(height: 20,),
                      defaultButton(
                          onClick: (){
                            if(formKey.currentState!.validate()){
                                cubit.updateProfileData(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text
                                );
                            }
                          },
                          text: 'Update'
                      ),
                      const SizedBox(height: 20,),
                      ConditionalBuilder(
                          condition: state is !ShopHomeLogoutLoadingState,
                          builder: (context)=>defaultButton(
                              onClick: (){
                                cubit.signOut(context);
                              },
                              text: 'Logout'
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator(),)
                      )
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator(),)
        );
      },
    );
  }

}