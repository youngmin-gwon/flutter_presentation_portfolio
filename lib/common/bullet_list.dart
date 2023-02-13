import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items) _BulletListItem(text: item),
      ],
    );
  }
}

class _BulletListItem extends StatelessWidget {
  final String text;

  const _BulletListItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          height: 1.5,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('\u2022', style: textStyle),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(text, style: textStyle),
        )
      ],
    );
  }
}
