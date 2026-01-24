import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/colors.dart';

class EcoLifeApp extends StatelessWidget {
  const EcoLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
