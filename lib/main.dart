import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'presentation/pages/homepage.dart';
import 'presentation/pages/tablepage.dart';

void main() {
  runApp(
    GetMaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/country_view': (context) => const CountryScreen(),
      },
    ),
  );
}
