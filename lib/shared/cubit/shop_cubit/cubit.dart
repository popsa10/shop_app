import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/fav_product_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/products_model.dart';
import 'package:shop_app/modules/categories_screen.dart';
import 'package:shop_app/modules/favorite_screen.dart';
import 'package:shop_app/modules/home_screen.dart';
import 'package:shop_app/modules/login_screen.dart';
import 'package:shop_app/modules/settings_screen.dart';
import 'package:shop_app/shared/components/defaults.dart';
import 'package:shop_app/shared/cubit/shop_cubit/states.dart';
import 'package:shop_app/shared/networks/local/cache_helper.dart';
import 'package:shop_app/shared/networks/remote/dio_helper.dart';
import 'package:shop_app/shared/networks/remote/end_points.dart';
import 'package:shop_app/shared/styles/constants.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    HomeScreen(),
    CategoriesScreen(),
    FavoriteScreen(),
    SettingsScreen()
  ];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Categories"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
  ];
  int currentIndex = 0;
  void changeBottomNav(int value) {
    currentIndex = value;
    emit(ShopChangeBottomNavState());
  }

  HomeModel homeModel;
  Map<int, bool> favorites = {};
  void getHomeProducts() {
    emit(ShopHomeLoadingState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });

      emit(ShopHomeSuccessState());
    }).catchError((error) {
      print("error is ${error.toString()}");
      emit(ShopHomeErrorState());
    });
  }

  CategoriesModel categoriesModel;
  void getCategories() {
    DioHelper.getData(url: CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopCategoriesErrorState());
    });
  }

  LoginModel userData;
  void getUserData() {
    emit(ShopUserProfileLoadingState());
    DioHelper.getData(url: PROFILE, token: token).then((value) {
      userData = LoginModel.fromJson(value.data);
      emit(ShopUserProfileSuccessState(userData));
    }).catchError((error) {
      print(error.toString());
      emit(ShopUserProfileErrorState());
    });
  }

  void getUpdateUserData({String name, String email, String phone}) {
    emit(ShopUpdateProfileLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      "name": name,
      "email": email,
      "phone": phone,
    }).then((value) {
      userData = LoginModel.fromJson(value.data);
      emit(ShopUpdateProfileSuccessState(userData));
    }).catchError((error) {
      print(error.toString());
      emit(ShopUpdateProfileErrorState());
    });
  }

  FavouritesModel favouritesModel;
  void addOrDeleteFavourite(int productId) {
    favorites[productId] = !favorites[productId];
    emit(ShopFavourite());
    DioHelper.postData(
            url: FAVORITES, data: {"product_id": productId}, token: token)
        .then((value) {
      favouritesModel = FavouritesModel.fromJson(value.data);
      if (!favouritesModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavProducts();
      }
      print(favouritesModel.message);
      emit(ShopFavouriteSuccess(favouritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];
      print(error.toString());
      emit(ShopFavouriteError());
    });
  }

  FavouritesProductModel favouritesProductModel;

  void getFavProducts() {
    emit(ShopGetFavouriteLoading());
    DioHelper.getData(url: GET_FAV, token: token).then((value) {
      favouritesProductModel = FavouritesProductModel.fromJson(value.data);
      print(favouritesProductModel.status);
      emit(ShopGetFavouriteSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetFavouriteError());
    });
  }

  void signOut(context) {
    CacheHelper.removeData("token").then((value) {
      if (value) navigateToAndFinish(context: context, page: LoginScreen());
    });
  }
}
