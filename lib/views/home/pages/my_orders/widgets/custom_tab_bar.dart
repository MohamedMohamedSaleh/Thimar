
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
    return TabBar(
      indicatorPadding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      padding: const EdgeInsetsDirectional.only(top: 18),
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
      tabs: const [
        Tab(
          height: 40,
          child: Text('الحاليه'),
        ),
        Tab(
          height: 40,
          child: Text('المنتهية'),
        ),
      ],
    );
  }


}
