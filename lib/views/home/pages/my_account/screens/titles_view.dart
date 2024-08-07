import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/logic/cache_helper.dart';
import 'package:vegetable_orders_project/core/logic/helper_methods.dart';
import 'package:vegetable_orders_project/core/widgets/custom_app_bar.dart';
import 'package:vegetable_orders_project/generated/locale_keys.g.dart';
import 'package:vegetable_orders_project/views/home/pages/my_account/screens/add_title_view.dart';
import 'package:vegetable_orders_project/views/home/pages/my_account/widgets/custom_outline_button.dart';

import '../../../../../core/constants/my_colors.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../features/addresses/get_delete_addresses/get_delete_addresses_bloc.dart';
import '../widgets/custom_title_item.dart';

class TitlesView extends StatefulWidget {
  const TitlesView({super.key});

  @override
  State<TitlesView> createState() => _TitlesViewState();
}

class _TitlesViewState extends State<TitlesView> {
  final bloc = KiwiContainer().resolve<GetDeleteAddressesBloc>();
  @override
  void initState() {
    super.initState();
    bloc.add(GetAddressesEvent(isLoading: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.home_addresses.tr(),
      ),
      body: BlocBuilder(
        bloc: bloc,
        builder: (context, state) {
          if (state is GetAddressesLoadingState ) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (bloc.list.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  child: AppImage(
                    'assets/images/no_addresses.png',
                    // width: 200,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  LocaleKeys.home_data_not_found.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.only(top: 26, right: 16, left: 16),
                    itemBuilder: (context, index) => CustomTitleItem(
                      model: bloc.list[index],
                    ),
                    itemCount: bloc.list.length,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 10),
        child: SafeArea(
          child: CustomOutlineButton(
              onTap: () {
                CacheHelper.removeLocation();
                navigateTo(toPage: const AddTitleView());
              },
              title: LocaleKeys.addresses_add_address.tr()),
        ),
      ),
    );
  }
}
