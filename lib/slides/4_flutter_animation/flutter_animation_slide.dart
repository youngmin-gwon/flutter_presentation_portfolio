import 'package:flutter/material.dart';
import 'package:flutter_presentation/common/bullet_list.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/bouncing_ball_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/google_logo_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/instagram_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/magnifying_transition_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/parallax_scroll_screen.dart';
import 'package:flutter_presentation/templates/templates.dart';

class FlutterAnimationSlide extends StatelessWidget {
  const FlutterAnimationSlide();

  @override
  Widget build(BuildContext context) {
    return const CarouselTemplate(
      title: 'What I have done\n - Animation',
      leftChild: BulletList(
        items: [
          'Instagram Animation',
          'Google Logo Animation',
          'Bouncing Ball Animation',
          'Custom Transition Animation',
          'Parrallax Transition',
        ],
      ),
      carouselChildren: [
        InstagramScreen(),
        GoogleLogoScreen(),
        BouncingBallScreen(),
        MagnifyingTransitionScreen(),
        ParallaxScrollScreen(),
      ],
    );
  }
}
