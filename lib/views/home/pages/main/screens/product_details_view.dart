import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/constants/my_colors.dart';
import 'package:vegetable_orders_project/core/widgets/app_image.dart';
import 'package:vegetable_orders_project/core/widgets/custom_app_bar_icon.dart';
import 'package:vegetable_orders_project/features/cart/cart_bloc.dart';
import 'package:vegetable_orders_project/features/products/search_products/search_products_model.dart';
import 'package:vegetable_orders_project/generated/locale_keys.g.dart';
import '../../../../../features/products/products/products_bloc.dart';
import '../../../../../features/products/products_model.dart';
import '../../../widgets/custom_plus_minus_product.dart';
import '../widgets/custom_list_comment.dart';
import '../widgets/custom_list_similar_products.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView(
      {super.key,
      required this.model,
      this.isMainView = true,
       this.searchModel});
  final ProductModel? model;
  final SearchResult? searchModel;
  final bool isMainView;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final bloc = KiwiContainer().resolve<CartBloc>();
  final addRemoveBloc = KiwiContainer().resolve<ProductsBloc>();

  @override
  Widget build(BuildContext context) {
    bool isFavorit = widget.model?.isFavorite ?? widget.searchModel!.isFavorite;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        KiwiContainer().resolve<CartBloc>().amountProduct = 1;
      },
      child: ColoredBox(
        color: Colors.white,
        child: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 22, right: 22, top: 16, bottom: 8),
                    child: Row(
                      children: [
                        const CustomAppBarIcon(),
                        const Spacer(),
                        BlocConsumer(
                          bloc: addRemoveBloc,
                          listener: (context, state) {
                            if (state is StartAddSuccessState) {
                              isFavorit = true;
                            } else if (state is StartRemoveSuccessState) {
                              isFavorit = false;
                            }
                          },
                          builder: (context, state) {
                            return CustomAppBarIcon(
                              onTap: () {
                                if (widget.model != null) {
                                  if (isFavorit) {
                                    addRemoveBloc.add(
                                        RemoveProductsFromFavsEvent(
                                            id: widget.model!.id));
                                  } else {
                                    addRemoveBloc.add(AddProductsToFavsEvent(
                                        id: widget.model!.id));
                                  }
                                }else{
                                      if (isFavorit) {
                                    addRemoveBloc.add(
                                        RemoveProductsFromFavsEvent(
                                            id: widget.searchModel!.id));
                                  } else {
                                    addRemoveBloc.add(AddProductsToFavsEvent(
                                        id: widget.searchModel!.id));
                                  }
                                }
                              },
                              isBack: false,
                              child: !isFavorit
                                  ? const AppImage(
                                      'assets/icon/svg/heart.svg',
                                    )
                                  : const Icon(
                                      Icons.favorite,
                                      color: mainColor,
                                      size: 20,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            child: AppImage(
                              widget.model?.mainImage ??
                                  widget.searchModel!.mainImage,
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 5, bottom: 2),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.model?.title ?? widget.searchModel!.title,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${widget.model?.discount ?? widget.searchModel!.discount}%',
                                    style: TextStyle(
                                        color: const Color(0xffFF0000),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '${widget.model?.price ?? widget.searchModel!.price}${LocaleKeys.r_s.tr()}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${widget.model?.priceBeforeDiscount ??widget.searchModel!.priceBeforeDiscount}${LocaleKeys.r_s.tr()}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.price.tr()} / 1  ${widget.model?.unit.name ?? widget.searchModel!.unit.name}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                      color: const Color(0xff808080),
                                    ),
                                  ),
                                  const Spacer(),
                                  CustomPlusOrMinusProduct(
                                    id: widget.model?.id ?? widget.searchModel!.id,
                                    index: 1,
                                    // amount: widget.model.amount,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 7),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${LocaleKeys.product_details_product_code.tr()} ",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "${widget.model?.id.toString() ?? widget.searchModel!.id.toString()} #",
                                  style: TextStyle(
                                    color: const Color(0xff808080),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16, bottom: 5, top: 4, left: 16),
                          child: Text(
                            LocaleKeys.product_details_product_details.tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            widget.model?.description?? widget.searchModel!.description,
                            style: const TextStyle(
                              color: Color(0xff808080),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: Text(
                            LocaleKeys.product_details_ratings.tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const CustomListComments(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16, top: 10, bottom: 5, left: 16),
                          child: Text(
                            LocaleKeys.product_details_similar_products.tr(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomListSimilarPrduct(
                          id: widget.model?.categoryId ??widget.searchModel!.categoryId,
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                bloc.add(
                  StorProductCartEvent(
                    searchModel: widget.searchModel,
                    id: widget.model?.id??widget.searchModel!.id,
                    model: widget.model,
                    isProduct: true,
                    amount: bloc.amountProduct,
                  ),
                );
              },
              child: Container(
                color: mainColor,
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state is AddToCartLoadingState) {
                        return const Center(
                          child: SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                color: Color(0xff61B80C),
                              )),
                        );
                      }
                      return Row(
                        children: [
                          SizedBox(
                            height: 32,
                            width: 32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: const Color(0xff6AA431),
                              ),
                              child: const AppImage(
                                  'assets/icon/svg/Shopping.svg'),
                            ),
                          ),
                          const SizedBox(
                            width: 9,
                          ),
                          Text(
                            LocaleKeys.product_details_add_to_cart.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          BlocBuilder(
                              bloc: bloc,
                              builder: (context, state) {
                                if (state is AddCounterSuccessState) {
                                  return Text(
                                    '${((widget.model?.price ?? widget.searchModel!.price!) * bloc.amountProduct).toDouble().toStringAsFixed(2)} ${LocaleKeys.r_s.tr()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '${((widget.model?.price?? widget.searchModel!.price!)* bloc.amountProduct).toDouble().toStringAsFixed(2)} ${LocaleKeys.r_s.tr()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
