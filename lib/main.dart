import 'package:flutter/material.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injector.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
