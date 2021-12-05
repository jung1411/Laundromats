import 'package:flutter/material.dart';
import 'package:laundromats/widgets/homepage.dart';



class NavigationBarRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vogro',
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
  List<Widget> _tabs;

  _NavigationContainerState() {
    _tabs = [
      HomeTab(this),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: appThemeColor,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/login.png", width: 24, height: 24),
            activeIcon: Image.asset("assets/images/accent.png",
                width: 24, height: 24),
            title: Text('Home', style: TextStyle(fontFamily: 'Quicksand')),
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/logo_splash.png", width: 24, height: 24),
            activeIcon: Image.asset("assets/images/login.png",
                width: 24, height: 24),
            title: Text('Explore', style: TextStyle(fontFamily: 'Quicksand')),
          ),
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/accent.png",
                  width: 24, height: 24),
              activeIcon: Image.asset("assets/images/logo_splash.png",
                  width: 24, height: 24),
              title: Text('Profile', style: TextStyle(fontFamily: 'Quicksand')))
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