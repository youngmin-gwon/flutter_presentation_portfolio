import 'package:flutter/widgets.dart';

import 'package:flutter_presentation/templates/templates.dart';

class ThankYouSlide extends StatelessWidget {
  const ThankYouSlide();

  @override
  Widget build(BuildContext context) {
    return const TitleScreenTemplate(
      title: 'Thank you!',
      subtitle: "It's time for your questions.",
    );
  }
}
