import 'package:flutter/material.dart';
import 'auth_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeBuilder = authRoutes[settings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute(builder: routeBuilder);
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}
