import 'package:flagle/features/country/presentation/screens/guess_country_screen.dart';
import 'package:flagle/features/country/presentation/screens/home_screen.dart';
import 'package:flagle/features/country/presentation/screens/main_country_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return MainCountryScreen(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => HomeScreen()),
          GoRoute(
            path: '/guess-country',
            builder: (context, state) => const GuessCountryScreen(),
          ),
        ],
      ),
    ],
  );
}
