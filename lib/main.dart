import 'package:flutter/material.dart';

import 'package:flutter_presentation/slides/slides_page.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Let me introduce Dev. Youngmin',
      debugShowCheckedModeBanner: false,
      home: SlidesPage(),
    );
  }
}
