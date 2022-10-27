import 'package:flutter/material.dart';
import 'package:posts/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey.shade100,
            filled: true,
          )),
      home: const HomeScreen(),
    );
  }
}
