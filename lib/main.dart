import 'package:flagle/core/routes/app_router.dart';
import 'package:flagle/core/theme/app_theme.dart';
import 'package:flagle/core/theme/theme_notifier.dart';
import 'package:flagle/dependency_injection.dart';
import 'package:flagle/features/country/presentation/bloc/country_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance.get<CountryBloc>(),
      child: ThemeNotifierProvider(
        themeNotifier: _themeNotifier,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              routerConfig: AppRouter.router,
              title: 'Flagle',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
            );
          },
        ),
      ),
    );
  }
}

class ThemeNotifierProvider extends InheritedWidget {
  final ThemeNotifier themeNotifier;

  const ThemeNotifierProvider({
    super.key,
    required this.themeNotifier,
    required super.child,
  });

  static ThemeNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ThemeNotifierProvider>();
    if (provider == null) {
      throw Exception('ThemeNotifierProvider not found in widget tree');
    }
    return provider.themeNotifier;
  }

  @override
  bool updateShouldNotify(ThemeNotifierProvider oldWidget) {
    return themeNotifier != oldWidget.themeNotifier;
  }
}
