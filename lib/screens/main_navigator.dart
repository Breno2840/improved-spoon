import 'package:flutter/material.dart';
import '../widgets/glass_bottom_nav_bar.dart';
import 'library_screen.dart';
import 'reader_screen.dart';
import 'settings_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LibraryScreen(),
    const ReaderScreen(isFromNav: true),
    const Center(child: Text('Marcadores - Em breve', style: TextStyle(color: Colors.white))),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1533), // Roxo bem escuro
            Color(0xFF0A0A0F), // Quase preto
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: GlassBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
