import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/colors.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();

class EcoLifeApp extends StatelessWidget {
  const EcoLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey, // 🔥 THIS IS THE FIX
      debugShowCheckedModeBanner: false,
      title: 'EcoLife',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
