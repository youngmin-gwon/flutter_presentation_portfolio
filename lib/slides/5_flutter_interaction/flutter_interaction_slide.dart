import 'package:flutter/material.dart';
import 'package:flutter_presentation/common/bullet_list.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/credit_card_shadow_animation_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/curtain_blind_animation_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/hover_and_blending_screen.dart';
import 'package:flutter_presentation/templates/templates.dart';

class FlutterInteractionSlide extends StatelessWidget {
  const FlutterInteractionSlide();

  @override
  Widget build(BuildContext context) {
    return const CarouselTemplate(
      title: 'What I have done\n - Interaction',
      leftChild: BulletList(
        items: [
          'Card Flipping Gradient Interaction',
          'Curtain Interaction',
          'Hovering Interaction',
        ],
      ),
      carouselChildren: [
        CreditCardShadowAnimationScreen(),
        CurtainBlindAnimationScreen(),
        HoverEffectScreen(),
      ],
    );
  }
}
