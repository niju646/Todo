import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/feature/categories/data/presentation/category_details_screen.dart';
import 'package:to_do/feature/categories/model/category_model.dart';

final List<GoRoute> categoryRoutes = [
  GoRoute(
    path: '/categoryDetails',
    name: RouteConstants.categoryDetails,
    pageBuilder: (context, state) {
      final categoryModel = state.extra as Data;
      return CustomTransitionPage(
        key: state.pageKey,
        child: CategoryDetailsScreen(category: categoryModel),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
];
