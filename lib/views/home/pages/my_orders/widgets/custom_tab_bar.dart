import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 15),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffF3F3F3),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: TabBar(
          padding: const EdgeInsets.all(6),
          indicatorPadding: const EdgeInsets.fromLTRB(-45, 0, -45, 0),
          unselectedLabelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          unselectedLabelColor: const Color(0xffA2A1A4),
          // indicatorPadding: EdgeInsets.,
          labelStyle: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          labelColor: Colors.white,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor),
          tabs: [
            Tab(
              height: 40,
              child: Text(
                context.locale.languageCode == "en" ? "Active" : "الحاليه",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Tab(
              height: 40,
              child: Text(
                context.locale.languageCode == "en" ? "Expired" : 'المنتهية',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
