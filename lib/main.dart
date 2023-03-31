import 'package:flutter/material.dart';
import 'package:password_manager/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
    );
  }
}
