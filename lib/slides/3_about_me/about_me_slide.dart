import 'package:flutter/material.dart';

import 'package:flutter_presentation/common/bullet_list.dart';
import 'package:flutter_presentation/templates/templates.dart';

class AboutMeSlide extends StatelessWidget {
  const AboutMeSlide();

  @override
  Widget build(BuildContext context) {
    return SplitScreenTemplate(
      title: 'About me',
      leftChild: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BulletList(
            items: [
              'Software Engineer from Busan, South Korea',
              'Using Flutter since v2.0.0',
              'Challenge Enthusiast',
            ],
          ),
          Text(
            '* Finished Spartan Race in 2015',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      rightChild: FractionallySizedBox(
        widthFactor: 0.5,
        child: Image.asset('assets/images/about_me.jpg'),
      ),
      leftFlex: 2,
      rightFlex: 3,
    );
  }
}
