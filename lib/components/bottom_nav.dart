import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  BottomNavigation({required this.selectedIndex, required this.onItemTapped});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile', // Add ProfilePage if needed
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: AppColors.ultramarineBlue,
      unselectedItemColor: AppColors.grey,
      onTap: widget.onItemTapped,
    );
  }
}
