import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundromats/login_page.dart';
import 'package:laundromats/navBAr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: NavigationBarRoot(),
    );
  }
}
