import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbarController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavbarProvider = NotifierProvider<BottomNavbarController, int>(
  BottomNavbarController.new,
);
