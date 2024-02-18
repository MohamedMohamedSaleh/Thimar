import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegetable_orders_project/core/logic/cache_helper.dart';
import 'package:vegetable_orders_project/features/categori_products/category_products_cubit.dart';
import 'package:vegetable_orders_project/features/products/search_category/search_category_cubit.dart';
import 'package:vegetable_orders_project/features/products/search_products/search_products_cubit.dart';
import 'package:vegetable_orders_project/features/products/similar_products/similar_products_cubit.dart';
import 'package:vegetable_orders_project/views/auth/confirm_code/cubit/confirm_cubit.dart';
import 'package:vegetable_orders_project/views/auth/login/cubit/login_cubit.dart';
import 'package:vegetable_orders_project/views/auth/register/cubit/register_cubit.dart';
import 'package:vegetable_orders_project/views/auth/splash/splash_view.dart';
import 'core/logic/helper_methods.dart';
import 'features/categoris/cubit/get_category_cubit.dart';
import 'features/get_cities/cubit/get_cities_cubit.dart';
import 'features/products/get_favorite_product/get_favorite_products_cubit.dart';
import 'features/slider/cubit/get_slider_cubit.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: getMaterialColor(),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetCitiesCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ConfirmCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetSliderCubit()..getData(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetCategoryCubit()..getData(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetCategoryProductsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetSearchProductsCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetFavoriteProductCubit()..getData()..getFavoriteData(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetSimilarProductCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => GetSearchCategoryCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        builder: (context, child) =>
            Directionality(textDirection: TextDirection.rtl, child: child!),
        title: 'Orders App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            color: Colors.white,
            titleTextStyle: TextStyle(
              color: getMaterialColor(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          primarySwatch: getMaterialColor(),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: FilledButton.styleFrom(
              side: BorderSide(color: getMaterialColor()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide()),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF3F3F3),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
        home: const SplashView(),
      ),
    );
  }
}

MaterialColor getMaterialColor() {
  Color myColor = const Color(0xff4C8613);
  return MaterialColor(
    myColor.value,
    {
      50: myColor.withOpacity(.1),
      100: myColor.withOpacity(.2),
      200: myColor.withOpacity(.3),
      300: myColor.withOpacity(.4),
      400: myColor.withOpacity(.5),
      500: myColor.withOpacity(.6),
      600: myColor.withOpacity(.7),
      700: myColor.withOpacity(.8),
      800: myColor.withOpacity(.9),
      900: myColor,
    },
  );
}
