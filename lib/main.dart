import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/modules/onboarding_screen.dart';
import 'package:shop_app/shared/cubit/shop_cubit/cubit.dart';
import 'package:shop_app/shared/cubit/shop_login_cubit/cubit.dart';
import 'package:shop_app/shared/networks/local/cache_helper.dart';
import 'package:shop_app/shared/networks/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/bloc_observer.dart';
import 'package:shop_app/shared/styles/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool onBoarding = CacheHelper.getData("onBoarding");
  token = CacheHelper.getData("token");
  Widget widget;

  if (onBoarding != null) {
    if (token != null)
      widget = HomeLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }
  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget widget;
  MyApp({Key key, this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeProducts()
            ..getCategories()
            ..getUserData()
            ..getFavProducts(),
        ),
        BlocProvider(
          create: (context) => ShopLoginCubit(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SHOP APP',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: widget),
    );
  }
}
