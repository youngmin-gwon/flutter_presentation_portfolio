import 'package:flutter/widgets.dart';

import 'package:flutter_presentation/templates/split_screen_template.dart';

class AppInAppTemplate extends StatelessWidget {
  final String title;
  final Widget leftChild;
  final Widget app;

  const AppInAppTemplate({
    required this.title,
    required this.leftChild,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return SplitScreenTemplate(
      title: title,
      leftChild: leftChild,
      rightChild: Center(
        child: ClipRect(
          child: app,
        ),
      ),
      leftFlex: 2,
      rightFlex: 3,
    );
  }
}
