import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/register_screen.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/states.dart';
import 'package:shop_app/shared/networks/local/cache_helper.dart';
import 'package:shop_app/shared/styles/constants.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLoginCubit, ShopLoginStates>(
      listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.loginModel.status) {
            showToast(text: state.loginModel.message, color: Colors.green)
                .then((value) {
              token = state.loginModel.data.token;
              CacheHelper.setData(
                      key: "token", value: state.loginModel.data.token)
                  .then((value) {
                navigateToAndFinish(context: context, page: HomeLayout());
              });
            });
          } else {
            showToast(text: state.loginModel.message, color: Colors.red);
          }
        } else if (state is ShopLoginErrorState) {
          showToast(text: state.error, color: Colors.red);
        }
      },
      builder: (context, state) {
        ShopLoginCubit cubit = ShopLoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "login now to browse our hot offers",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      defaultFormField(
                          controller: emailController,
                          label: "Email Address",
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Email Must Not Be Empty";
                            }
                          },
                          prefix: Icons.email_outlined,
                          type: TextInputType.emailAddress),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                          suffix: cubit.suffix,
                          suffixFunction: () {
                            cubit.changePasswordVisibility();
                          },
                          isPassword: cubit.isPassword,
                          controller: passwordController,
                          label: "Password",
                          validate: (String value) {
                            if (value.isEmpty) {
                              return "Password is too short";
                            }
                          },
                          prefix: Icons.lock_outline,
                          type: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState.validate()) {
                              cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context) => defaultButton(
                            text: "Login",
                            function: () {
                              if (formKey.currentState.validate()) {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            }),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          defaultTextButton(
                              function: () {
                                navigateTo(
                                    context: context, page: RegisterScreen());
                              },
                              text: "Register")
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
