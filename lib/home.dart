import 'package:flutter/material.dart';
import 'package:mad_project/NavBar.dart';
import 'package:mad_project/assistant.dart';
import 'package:mad_project/firstPage.dart';
import 'package:mad_project/landing_page.dart';
import 'package:mad_project/surahs_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const LandingPage();
        break;
      case 1:
        body = const HadithPage();
        break;
      case 2:
        body = const ChatAssistant();
        break;
      case 3:
        body = const QuranBooks();
        break;
      default:
        body = const LandingPage();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: CustomCurvedNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}