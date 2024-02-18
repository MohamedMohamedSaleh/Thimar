import '../products/products_model.dart';

class GetCategoryProductsStates {}

class GetCategoryProductsSuccessState extends GetCategoryProductsStates {
  final List<ProductModel> model;

  GetCategoryProductsSuccessState({required this.model});
}

class GetCategoryProductsLoadingState extends GetCategoryProductsStates {}

class GetCategoryProductsFailedState extends GetCategoryProductsStates {
  final String msg;

  GetCategoryProductsFailedState({required this.msg});
}
