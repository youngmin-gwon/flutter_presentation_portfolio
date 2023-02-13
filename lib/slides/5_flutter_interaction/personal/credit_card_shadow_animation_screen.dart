import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CreditCardShadowAnimationScreen extends StatefulWidget {
  const CreditCardShadowAnimationScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardShadowAnimationScreen> createState() =>
      _CreditCardShadowAnimationScreenState();
}

class _CreditCardShadowAnimationScreenState
    extends State<CreditCardShadowAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final GlobalKey _widgetSizeKey = GlobalKey();
  late Size _size;

  /// angleTween : angles to show dynamic gradient effect
  ///  range = [-pi/10, pi/10]
  static final _angleTween =
      Tween<double>(begin: math.pi / 8, end: -math.pi / 8).chain(
    CurveTween(
      curve: Curves.easeIn,
    ),
  );
  static final _alignmentTween = AlignmentTween(
    begin: const Alignment(0.5, 0.4),
    end: const Alignment(-0.5, -0.0),
  );

  static final _radiusTween = TweenSequence([
    TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 0.7), weight: 1),
    TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 0.7), weight: 1),
    TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 0.8), weight: 1),
  ]);

  bool isLeftSide(double x) {
    return x < _size.width / 2;
  }

  void _onLongPressDown(LongPressDownDetails details) {
    if (isLeftSide(details.localPosition.dx)) {
      _animationController.animateBack(0);
    } else {
      _animationController.animateTo(1);
    }
  }

  void _onPressEnd() {
    _animationController.animateTo(0.5);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.value = 0.5;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _size = _getSize();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Size _getSize() {
    final RenderBox renderBox =
        _widgetSizeKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _widgetSizeKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-math.pi / 12)
                ..rotateY(_angleTween.animate(_animationController).value)
                ..rotateZ(-math.pi / 12),
              alignment: FractionalOffset.center,
              child: GestureDetector(
                onLongPressDown: _onLongPressDown,
                onLongPressEnd: (_) {
                  _onPressEnd();
                },
                onTapUp: (_) {
                  _onPressEnd();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                    gradient: RadialGradient(
                      colors: const [
                        Colors.white,
                        Colors.red,
                      ],
                      center:
                          _alignmentTween.animate(_animationController).value,
                      radius: _radiusTween.animate(_animationController).value,
                    ),
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Usim(width: 60, height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Icon(
                    Icons.workspaces_rounded,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Usim extends StatelessWidget {
  const Usim({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFE0A91F),
      ),
      width: width,
      height: height,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Container(
            color: Colors.black,
            width: 1,
          ),
          const Expanded(child: SizedBox()),
          Container(
            color: Colors.black,
            width: 1,
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
