import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'map_screen.dart';
import 'explore_screen.dart';
import 'saved_screen.dart';
import 'publications_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _screens = const [
    MapScreen(),
    ExploreScreen(),
    SavedScreen(),
    PublicationsScreen(),
    ProfileScreen(),
  ];

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determinar dirección: derecha si vamos a un tab mayor, izquierda si menor
    final goingRight = _currentIndex > _previousIndex;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          // Detectar si es el widget que entra o el que sale
          final isEntering = child.key == ValueKey(_currentIndex);

          final offsetBegin = isEntering
              ? Offset(goingRight ? 1.0 : -1.0, 0.0)
              : Offset(goingRight ? -1.0 : 1.0, 0.0);

          return SlideTransition(
            position: Tween<Offset>(
              begin: offsetBegin,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}