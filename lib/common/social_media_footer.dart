import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialMediaHandle extends StatelessWidget {
  const SocialMediaHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(
            'assets/icons/medium_icon.svg',
            height: 32.0,
          ),
          const SizedBox(width: 4.0),
          SvgPicture.asset(
            'assets/icons/twitter_icon.svg',
            height: 32.0,
          ),
          const SizedBox(width: 4.0),
          SvgPicture.asset(
            'assets/icons/github_icon.svg',
            height: 32.0,
          ),
          const SizedBox(width: 4.0),
          SvgPicture.asset(
            'assets/icons/youtube_icon.svg',
            height: 32.0,
          ),
          const SizedBox(width: 4.0),
          Text(
            '@mkobuolys',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF02569B),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
