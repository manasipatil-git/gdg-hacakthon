import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/colors.dart';

class EcoLifeApp extends StatelessWidget {
  const EcoLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoLife',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/', // ✅ CORRECT
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
