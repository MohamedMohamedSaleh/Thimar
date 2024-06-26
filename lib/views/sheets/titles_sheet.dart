import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:vegetable_orders_project/core/logic/helper_methods.dart';
import 'package:vegetable_orders_project/views/home/pages/my_account/screens/add_title_view.dart';
import 'package:vegetable_orders_project/views/home/pages/my_account/widgets/custom_outline_button.dart';

import '../../core/constants/my_colors.dart';
import '../../features/addresses/get_delete_addresses/get_delete_addresses_bloc.dart';
import '../home/pages/my_account/widgets/custom_title_item.dart';

class TitlesSheet extends StatefulWidget {
  const TitlesSheet({super.key});

  @override
  State<TitlesSheet> createState() => _TitlesSheetState();
}

class _TitlesSheetState extends State<TitlesSheet> {
  final bloc = KiwiContainer().resolve<GetDeleteAddressesBloc>()
    ..add(GetAddressesEvent(isLoading: true));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context);
        }
      },
      canPop: false,
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: Text(
                  'العناوين',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: BlocBuilder(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is GetAddressesLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context, bloc.list[index]);
                          },
                          child: CustomTitleItem(model: bloc.list[index])),
                      itemCount: bloc.list.length,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomOutlineButton(
                  onTap: () {
                    navigateTo(toPage: const AddTitleView());
                  },
                  title: 'إضافة عنوان جديد'),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
