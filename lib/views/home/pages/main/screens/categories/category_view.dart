import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/widgets/app_image.dart';
import 'package:vegetable_orders_project/core/widgets/custom_app_bar.dart';
import 'package:vegetable_orders_project/features/categori_products/category_products_bloc.dart';
import 'package:vegetable_orders_project/features/products/search_category/search_category_bloc.dart';
import 'package:vegetable_orders_project/views/home/widgets/custom_item_product.dart';
import 'package:vegetable_orders_project/views/home/widgets/shimmer_loading.dart';
import 'package:vegetable_orders_project/views/sheets/filtter_sheet.dart';

import '../../../../../../core/constants/my_colors.dart';
import '../../../../../../core/widgets/custom_app_input.dart';
import '../../../../../../features/categoris/category_model.dart';
import '../../../../../../generated/locale_keys.g.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key, required this.id, required this.model});
  final int id;
  final CategoryModel model;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final getCategoryBloc = KiwiContainer().resolve<GetCategoryProductsBloc>();
  final getSearchBloc = KiwiContainer().resolve<GetSearchCategoryBloc>();
  bool isNotFound = false;

  @override
  void initState() {
    super.initState();
    getCategoryBloc.add(GetCategoryProductEvent(id: widget.id));
  }

  @override
  void dispose() {
    super.dispose();
    getSearchBloc.close();
    getCategoryBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context);
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(title: widget.model.name),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 20, bottom: 10),
              child: Stack(
                children: [
                  CustomAppInput(
                    controller: getSearchBloc.textController,
                    onChange: (value) {
                      if (value.isNotEmpty) {
                        getSearchBloc.add(
                            GetSearchCategoryEvent(id: widget.id, text: value));
                        if (getSearchBloc.search.isEmpty) {
                          isNotFound = true;
                        }
                      } else {
                        isNotFound = false;
                        getSearchBloc.add(
                            GetSearchCategoryEvent(id: widget.id, text: value));
                        getSearchBloc.search.clear();
                      }
                    },
                    labelText: LocaleKeys.home_search_about_you_want.tr(),
                    prefixIcon: "assets/icon/svg/search.svg",
                    fillColor: const Color(0xff4C8613).withOpacity(.03),
                    paddingBottom: 0,
                  ),
                  Positioned(
                    top: 9.5,
                    left: 8,
                    child: InkWell(
                      onTap: () async {
                        showModalBottomSheet(
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          context: context,
                          builder: (context) => FiltterSheet(
                            id: widget.id,
                          ),
                        );
                      },
                      child: const AppImage(
                        'assets/icon/svg/filtter.svg',
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder(
                bloc: getSearchBloc,
                builder: (context, state) {
                  if (getSearchBloc.search.isEmpty && !isNotFound) {
                    return BlocBuilder(
                      bloc: getCategoryBloc,
                      builder: (context, state) {
                        if (state is GetCategoryProductsLoadingState) {
                          return const ShimmerLoadingProduct(
                            isMain: false,
                          );
                        } else if (state is GetCategoryProductsSuccessState) {
                          if (state.model.isNotEmpty) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: RefreshIndicator(
                                displacement: 20,
                                strokeWidth: 3,
                                backgroundColor: Colors.green[100],
                                onRefresh: () async {
                                  getCategoryBloc.add(
                                      GetCategoryProductEvent(id: widget.id));
                                },
                                child: GridView.builder(
                                  physics: state.model.length > 4
                                      ? const BouncingScrollPhysics()
                                      : const AlwaysScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 163 / 215,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  padding: const EdgeInsets.only(
                                      right: 16, left: 16, top: 10, bottom: 20),
                                  itemCount: state.model.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          ItemProduct(
                                    model: state.model[index],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const AppImage(
                                    'assets/icon/no_data_category.png',
                                    width: 200,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    LocaleKeys.home_data_not_found.tr(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Text('Failed');
                        }
                      },
                    );
                  } else if (state is GetSearchCategoryLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 163 / 215,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        padding: const EdgeInsets.only(
                            right: 16, left: 16, top: 10, bottom: 20),
                        itemCount: getSearchBloc.search.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ItemProduct(
                          isSearch: true,
                          searchModel: getSearchBloc.search[index],
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
