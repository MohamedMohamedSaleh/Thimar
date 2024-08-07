import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/constants/my_colors.dart';
import 'package:vegetable_orders_project/core/logic/helper_methods.dart';
import 'package:vegetable_orders_project/core/widgets/app_image.dart';
import 'package:vegetable_orders_project/core/widgets/custom_app_bar_icon.dart';
import 'package:vegetable_orders_project/core/widgets/custom_fill_button.dart';
import 'package:vegetable_orders_project/core/widgets/custom_outline_send_button.dart';
import 'package:vegetable_orders_project/features/cart/cart_bloc.dart';
import 'package:vegetable_orders_project/features/products/search_products/search_products_bloc.dart';
import 'package:vegetable_orders_project/features/products/search_products/search_products_model.dart';
import 'package:vegetable_orders_project/generated/locale_keys.g.dart';
import 'package:vegetable_orders_project/views/home/cart_and_orders/cart_view.dart';
import 'package:vegetable_orders_project/views/home/home_view.dart';

import '../../features/products/products_model.dart';

class SuccessAddToCartSheet extends StatelessWidget {
  const SuccessAddToCartSheet({super.key, this.model, this.searchModel});
  final ProductModel? model;
  final SearchResult? searchModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 215.h,
        child: Padding(
          padding: EdgeInsets.only(top: 16.h, right: 20.w, left: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    CustomAppBarIcon(
                      isBack: false,
                      height: 18.w,
                      width: 18.w,
                      child: Icon(
                        Icons.check_rounded,
                        size: 14.h,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      LocaleKeys.product_details_product_added_to_cart.tr(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                _Item(
                  model: model,
                  searchModel: searchModel,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 47.h,
                        child: CustomFillButton(
                            title: LocaleKeys.product_details_go_to_cart.tr(),
                            onPress: () {
                              KiwiContainer()
                                  .resolve<CartBloc>()
                                  .amountProduct = 1;
                              // Navigator.pop(context);
                              // KiwiContainer().resolve<GetSearchProductsBloc>()
                              //   ..textController.clear()
                              //   ..search.clear();
                              navigateTo(
                                  toPage: const HomeView(), isRemove: true);
                              KiwiContainer().resolve<GetSearchProductsBloc>()
                                ..add(GetSearchProductsEvent(text: ''))
                                ..textController.clear()
                                ..search.clear()
                                ..isNotFound = false;
                              FocusManager.instance.primaryFocus?.unfocus();
                              navigateTo(toPage: const CartView());
                              FocusScope.of(context).unfocus();
                              Navigator.canPop(context);
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          height: 47.h,
                          child: CustomOutlineButton(
                            onPress: () {
                              KiwiContainer()
                                  .resolve<CartBloc>()
                                  .amountProduct = 1;

                              navigateTo(
                                  toPage: const HomeView(), isRemove: true);
                              KiwiContainer().resolve<GetSearchProductsBloc>()
                                ..add(GetSearchProductsEvent(text: ''))
                                ..textController.clear()
                                ..search.clear()
                                ..isNotFound = false;

                              FocusManager.instance.primaryFocus?.unfocus();
                              // Navigator.pop(context);
                              // if (searchModel != null) {
                              //   Navigator.canPop(context);
                              // }
                            },
                            title:
                                LocaleKeys.product_details_browse_offers.tr(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item({this.model, this.searchModel});
  final ProductModel? model;
  final SearchResult? searchModel;

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  final bloc = KiwiContainer().resolve<CartBloc>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(11).w,
          child: AppImage(
            widget.model?.mainImage ?? widget.searchModel!.mainImage,
            height: 61.h,
            width: 66.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 11.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.model?.title ?? widget.searchModel!.title,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: mainColor),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              '${LocaleKeys.product_details_amount.tr()} : ${bloc.amountProduct}',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xff7E7E7E)),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              '${widget.model?.price ?? widget.searchModel!.price} ${LocaleKeys.r_s.tr()}',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: mainColor),
            ),
          ],
        ),
      ],
    );
  }
}
