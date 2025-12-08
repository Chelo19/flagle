import 'package:flagle/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainCountryScreen extends StatelessWidget {
  final Widget child;

  const MainCountryScreen({super.key, required this.child});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/guess-country');
        break;
    }
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location == '/') {
      return 0;
    } else if (location == '/guess-country') {
      return 1;
    }
    return 0;
  }

  bool _isCurrentRoute(BuildContext context, String route) {
    return GoRouterState.of(context).uri.path == route;
  }

  void _navigateToRoute(BuildContext context, String route) {
    context.go(route);
    Navigator.pop(context); // Cerrar el drawer después de navegar
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.flag,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Flagle',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Guess the country!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Home'),
              selected: _isCurrentRoute(context, '/'),
              selectedTileColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              onTap: () => _navigateToRoute(context, '/'),
            ),
            ListTile(
              leading: Icon(
                Icons.quiz,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Guess Country'),
              selected: _isCurrentRoute(context, '/guess-country'),
              selectedTileColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              onTap: () => _navigateToRoute(context, '/guess-country'),
            ),
            const Divider(),
            // Theme Toggle
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeNotifierProvider.of(context),
              builder: (context, themeMode, child) {
                final isDark = themeMode == ThemeMode.dark;
                return SwitchListTile(
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Dark Mode'),
                  value: isDark,
                  onChanged: (value) {
                    final themeNotifier = ThemeNotifierProvider.of(context);
                    themeNotifier.setTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('About'),
              onTap: () {
                // TODO: Mostrar información de la app
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Flagle',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(
                    Icons.flag,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  children: [
                    Text(
                      'A fun game to guess countries by their flags!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Guess'),
        ],
      ),
    );
  }
}
