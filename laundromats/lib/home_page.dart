import 'package:flutter/material.dart';

import 'tabs/list_page.dart';
import 'tabs/main_page.dart';
import 'tabs/maps_page.dart';
import 'map_page.dart';

class NavigationBarRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry',
      home: NavigationContainer(),
    );
  }
}

class NavigationContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationContainerState();
  }
}

class NavBarDelegate {
  void selectTab(int index) {}
}

class _NavigationContainerState extends State<NavigationContainer>
    implements NavBarDelegate {
  int _currentIndex = 0;
  List<Widget> _tabs = [];

  _NavigationContainerState() {
    _tabs = [
      MainPage(),
      MapPage(),
      ListPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey[400],
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.blue[700],
              size: 25.0,
            ),
            title:
                Text('Home', style: TextStyle(fontFamily: 'Red Hat Display')),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.grey[400],
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.map,
              color: Colors.blue[700],
              size: 25.0,
            ),
            title: Text('Map', style: TextStyle(fontFamily: 'Red Hat Display')),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.grey[400],
              size: 25.0,
            ),
            activeIcon: Icon(
              Icons.list,
              color: Colors.blue[700],
              size: 25.0,
            ),
            title:
                Text('List', style: TextStyle(fontFamily: 'Red Hat Display')),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void selectTab(int index) {
    onTabTapped(index);
  }
}
