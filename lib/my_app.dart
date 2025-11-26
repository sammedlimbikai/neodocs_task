import 'package:flutter/material.dart';

import 'modules/range_bar/views/test_case_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TestCasesScreen(),
    );
  }
}
