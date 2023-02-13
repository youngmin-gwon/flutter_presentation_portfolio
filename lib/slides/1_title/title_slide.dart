import 'package:flutter/widgets.dart';

import 'package:flutter_presentation/templates/templates.dart';

class TitleSlide extends StatelessWidget {
  const TitleSlide();

  @override
  Widget build(BuildContext context) {
    return const TitleScreenTemplate(
      title: 'Who is he?',
      subtitle: 'Youngmin Gwon',
    );
  }
}
