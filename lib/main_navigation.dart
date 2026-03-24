import 'package:flutter/material.dart';
import 'dart:ui';
import 'features/todo/screens/home_screen.dart';
import 'features/notes/screens/notes_screen.dart';
import 'features/store/screens/store_screen.dart';
import 'core/widgets/glass_effect.dart';
import 'core/theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    NotesScreen(),
    StoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screens[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.glassDark.withOpacity(0.8),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.accentCyan,
                unselectedItemColor: AppColors.textTertiary,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded, size: 28),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.note_rounded, size: 28),
                    label: 'Notes',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_bag_rounded, size: 28),
                    label: 'Store',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
