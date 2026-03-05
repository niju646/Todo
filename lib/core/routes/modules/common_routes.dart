import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/core/routes/router_constants.dart';
import 'package:to_do/core/shared/bottom_nav/presentation/bottom_nav_screen.dart';
import 'package:to_do/feature/todo/data/presentation/create_todo_screen.dart';
import 'package:to_do/feature/authentication/data/presentation/login_screen.dart';
import 'package:to_do/feature/authentication/data/presentation/signup_screen.dart';
import 'package:to_do/feature/todo/data/presentation/splash_screen.dart';
import 'package:to_do/feature/todo/data/presentation/todo_detail_screen.dart';

final List<GoRoute> commonRoutes = [
  GoRoute(
    path: '/',
    name: RouteConstants.splashScreen,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),

  GoRoute(
    path: '/signup',
    name: RouteConstants.signup,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: SignUpScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
  GoRoute(
    path: '/login',
    name: RouteConstants.login,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
  GoRoute(
    path: '/bottomNav',
    name: RouteConstants.bottomNav,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: BottomNavScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
  GoRoute(
    path: '/createtodo',
    name: RouteConstants.createtodo,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: CreateTodoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
  GoRoute(
    path: '/todoDeatilscreen',
    name: RouteConstants.todoDetailScreen,
    pageBuilder: (context, state) {
      final id = state.extra as int;
      return CustomTransitionPage(
        key: state.pageKey,
        child: TodoDetailScreen(id: id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
];
