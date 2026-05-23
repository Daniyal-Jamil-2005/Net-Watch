import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/overview_screen.dart';
import 'screens/health_screen.dart';
import 'screens/hogs_screen.dart';
import 'screens/router_screen.dart';
import 'screens/settings_screen.dart';

class AppLayout extends ConsumerStatefulWidget {
  const AppLayout({super.key});

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OverviewScreen(),
    HealthScreen(),
    SettingsScreen(),
    HogsScreen(),
    RouterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor_heart_outlined),
              activeIcon: Icon(Icons.monitor_heart),
              label: 'Health',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smartphone_outlined),
              activeIcon: Icon(Icons.smartphone),
              label: 'My Device',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt_outlined),
              activeIcon: Icon(Icons.bolt),
              label: 'Hogs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.router_outlined),
              activeIcon: Icon(Icons.router),
              label: 'Router',
            ),
          ],
        ),
      ),
    );
  }
}
