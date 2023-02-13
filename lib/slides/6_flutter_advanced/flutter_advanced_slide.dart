import 'package:flutter/material.dart';
import 'package:flutter_presentation/common/bullet_list.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/metaball_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/particle_counter_screen.dart';
import 'package:flutter_presentation/slides/5_flutter_interaction/personal/text_rasterization_screen.dart';
import 'package:flutter_presentation/templates/templates.dart';

class FlutterAdvancedSlide extends StatelessWidget {
  const FlutterAdvancedSlide();

  @override
  Widget build(BuildContext context) {
    return const CarouselTemplate(
      title: 'What I have done\n - Advanced',
      leftChild: BulletList(
        items: [
          'Metaball Animation',
          'Particle Counter',
          'Text Rasterization',
        ],
      ),
      carouselChildren: [
        MetaballScreen(),
        ParticleCounterScreen(),
        TextRasterizationScreen(),
      ],
    );
  }
}
