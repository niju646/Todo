import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/modules/common_routes.dart';
import 'package:to_do/core/routes/modules/category_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [...commonRoutes, ...categoryRoutes],
  );
});
