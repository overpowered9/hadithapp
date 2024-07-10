import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomCurvedNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomCurvedNavigationBar({Key? key, required this.selectedIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: Colors.transparent,
      color: Colors.teal,
      buttonBackgroundColor: Colors.teal,
      height: 50,
      items: const <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.book, size: 30),
        Icon(Icons.person, size: 30),
        Icon(Icons.menu_book, size: 30),
      ],
      onTap: (index) => onTap(index),
    );
  }
}