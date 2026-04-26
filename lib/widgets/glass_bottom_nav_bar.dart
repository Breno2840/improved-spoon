import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D12).withOpacity(0.8),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.white54,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Biblioteca'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Leitura'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: 'Marcadores'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Configurações'),
            ],
          ),
        ),
      ),
    );
  }
}
