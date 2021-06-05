import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopHomeLoadingState extends ShopStates {}

class ShopHomeSuccessState extends ShopStates {}

class ShopHomeErrorState extends ShopStates {}

class ShopCategoriesSuccessState extends ShopStates {}

class ShopCategoriesErrorState extends ShopStates {}

class ShopUserProfileLoadingState extends ShopStates {}

class ShopUserProfileSuccessState extends ShopStates {
  final LoginModel loginModel;

  ShopUserProfileSuccessState(this.loginModel);
}

class ShopUserProfileErrorState extends ShopStates {}

class ShopUpdateProfileLoadingState extends ShopStates {}

class ShopUpdateProfileSuccessState extends ShopStates {
  final LoginModel loginModel;

  ShopUpdateProfileSuccessState(this.loginModel);
}

class ShopUpdateProfileErrorState extends ShopStates {}

class ShopFavouriteSuccess extends ShopStates {
  final FavouritesModel model;
  ShopFavouriteSuccess(this.model);
}

class ShopFavourite extends ShopStates {}

class ShopFavouriteError extends ShopStates {}

class ShopGetFavouriteSuccess extends ShopStates {}

class ShopGetFavouriteError extends ShopStates {}

class ShopGetFavouriteLoading extends ShopStates {}
