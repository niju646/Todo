import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/core/routes/app_router.dart';
import 'package:to_do/core/theme/theme_provider.dart';
import 'package:to_do/core/utils/responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Responsive().init(constraints, orientation);
            return MaterialApp.router(
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
