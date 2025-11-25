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
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.flag, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Flagle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Guess the country!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: _isCurrentRoute(context, '/'),
              selectedTileColor: Colors.blue.withOpacity(0.1),
              onTap: () => _navigateToRoute(context, '/'),
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Guess Country'),
              selected: _isCurrentRoute(context, '/guess-country'),
              selectedTileColor: Colors.blue.withOpacity(0.1),
              onTap: () => _navigateToRoute(context, '/guess-country'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Navegar a pantalla de configuración
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                // TODO: Mostrar información de la app
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Flagle',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.flag, size: 48),
                  children: [
                    const Text('A fun game to guess countries by their flags!'),
                  ],
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit'),
              onTap: () {
                Navigator.pop(context);
                // Mostrar diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Exit App'),
                    content: const Text('Are you sure you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Cerrar la app (solo funciona en algunas plataformas)
                          // En web/móvil, esto puede no funcionar como se espera
                        },
                        child: const Text('Exit'),
                      ),
                    ],
                  ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Guess'),
        ],
      ),
    );
  }
}
