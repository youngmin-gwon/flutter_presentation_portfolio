import 'package:flutter/widgets.dart';

import 'package:flutter_presentation/common/bullet_list.dart';
import 'package:flutter_presentation/templates/templates.dart';

class AgendaSlide extends StatelessWidget {
  const AgendaSlide();

  @override
  Widget build(BuildContext context) {
    return const SplitScreenTemplate(
      title: 'Agenda',
      leftChild: BulletList(
        items: [
          'About me',
          'About what I have done',
        ],
      ),
      rightChild: SizedBox(),
      leftFlex: 2,
      rightFlex: 3,
    );
  }
}
