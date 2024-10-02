import 'package:flutter/material.dart';
import 'package:pedro_downloads/app/pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Pedro Downloads',
      home: const HomePage(),
    );
  }
}
