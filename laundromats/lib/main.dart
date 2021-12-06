/**
 * CSCI 4100u Final Project
 * 
 * Authors: Joshua Verhoeff, Alper Tuna Unsal, Nakil Jung, 
 *  Nandu Pokhrel, Sailesh Sharma
 * 
 * Laundromat app to facilitate finding the closest laundromat to your
 * location and listing all of the prices and addresses. Able to 
 * register for a date to book your place.
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
