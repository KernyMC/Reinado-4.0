import 'package:flutter/material.dart';
import 'voting_screen.dart';
import 'carousel_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
    VotingScreen(),
    CarouselScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Votación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_carousel),
            label: 'Carrusel',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0D4F02),
        onTap: _onItemTapped,
      ),
    );
  }
} 