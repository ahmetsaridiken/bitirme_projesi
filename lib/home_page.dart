import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:masalressami/list_video.dart';
import 'package:masalressami/screens/add_screen.dart';
import 'package:masalressami/screens/ayarlar_screen.dart';
import 'package:masalressami/screens/home_screen.dart';
import 'package:masalressami/screens/favorites_screen.dart';

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    VideoListScreen(),
    AddScreen(),
    FavoritesScreen(),
    AyarlarScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xFFA5C5A8),
              ),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: '',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.red[300],
                unselectedItemColor: Colors.blueGrey,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 