import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do/core/shared/bottom_nav/controller/bottom_navbar_controller.dart';
import 'package:to_do/core/utils/responsive.dart';
import 'package:to_do/feature/analytics/data/presentation/analytics_screen.dart';
import 'package:to_do/feature/categories/data/presentation/category_listing_screen.dart';
import 'package:to_do/feature/todo/data/presentation/home_screen.dart';
import 'package:to_do/feature/todo/data/presentation/profile_screen.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  List<Widget> _getPages() {
    return const [
      HomeScreen(),
      CategoryListingScreen(),
      AnalyticsScreen(),
      ProfileScreen(),
      // Center(child: Text("Classes")),
      // Center(child: Text("Profile")),
    ];
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 24),
        activeIcon: Icon(Icons.home, size: 26),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category, size: 24),
        activeIcon: Icon(Icons.category, size: 26),
        label: 'Category',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.analytics, size: 24),
        activeIcon: Icon(Icons.analytics, size: 26),
        label: 'Analytics',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person, size: 24),
        activeIcon: Icon(Icons.person, size: 26),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavbarProvider);
    final pages = _getPages();
    final navItems = _getBottomNavItems();

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: SizedBox(
        height: Responsive.height * 8.5,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).cardColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: Theme.of(context).textTheme.bodyLarge?.color,
          unselectedItemColor: const Color(0xFF848484),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) {
            ref.read(bottomNavbarProvider.notifier).setIndex(index);
          },
          items: navItems,
        ),
      ),
    );
  }
}
