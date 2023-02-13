import 'package:flutter/material.dart';

class MagnifyingTransitionScreen extends StatefulWidget {
  const MagnifyingTransitionScreen({Key? key}) : super(key: key);

  @override
  State<MagnifyingTransitionScreen> createState() =>
      _MagnifyingTransitionScreenState();
}

class _MagnifyingTransitionScreenState extends State<MagnifyingTransitionScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  static final _slideTween =
      Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).chain(
    CurveTween(
      curve: const Interval(0, 0.3, curve: Curves.easeInOutCirc),
    ),
  );

  late Size _originalSize = Size.zero;
  late Size _zoomedSize = Size.zero;

  late Animatable<Offset> _topLeftOffsetTween;
  late Animatable<Offset> _topRightOffsetTween;
  late Animatable<Offset> _bottomLeftOffsetTween;
  late Animatable<Offset> _bottomRightOffsetTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    _setTweens();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _setCardSize(context);
        _setTweens();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setCardSize(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final originalHeight = size.height / 3;
    final originalWidth = originalHeight / 1.2;

    _originalSize = Size(originalWidth, originalHeight);
    _zoomedSize = Size(originalWidth * 1.5, originalHeight * 1.5);
  }

  void _setTweens() {
    _topLeftOffsetTween = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        (_originalSize.width - _zoomedSize.width) / 2,
        (_originalSize.height - _zoomedSize.height) / 2,
      ),
    ).chain(
      CurveTween(
        curve: const Interval(
          0.3,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    _topRightOffsetTween = Tween<Offset>(
      begin: Offset(_originalSize.width, 0),
      end: Offset(
        _zoomedSize.width + (_zoomedSize.width - _originalSize.width) / 2,
        (_originalSize.height - _zoomedSize.height) / 2,
      ),
    ).chain(
      CurveTween(
        curve: const Interval(
          0.45,
          0.85,
          curve: Curves.ease,
        ),
      ),
    );
    _bottomLeftOffsetTween = Tween<Offset>(
      begin: Offset(0, _originalSize.height),
      end: Offset(
        (_originalSize.width - _zoomedSize.width) / 2,
        _zoomedSize.height,
      ),
    ).chain(
      CurveTween(
        curve: const Interval(
          0.4,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );
    _bottomRightOffsetTween = Tween<Offset>(
      begin: Offset(_originalSize.width, _originalSize.height),
      end: Offset(
        _zoomedSize.width + (_zoomedSize.width - _originalSize.width) / 2,
        _zoomedSize.height,
      ),
    ).chain(
      CurveTween(
        curve: const Interval(
          0.55,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _setCardSize(context);
        _setTweens();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(
                opacity:
                    _controller.drive(CurveTween(curve: Curves.elasticOut)),
                child: SlideTransition(
                  position: _controller.drive(_slideTween),
                  child: Container(
                    color: Colors.green,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () async {
                    if (_controller.status == AnimationStatus.dismissed) {
                      await _controller.forward(from: 0);
                    } else if (_controller.status ==
                        AnimationStatus.completed) {
                      await _controller.reverse(from: 1);
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        children: [
                          Center(
                            child: CustomPaint(
                              painter: StretchPainter(
                                topLeft: _controller
                                    .drive(_topLeftOffsetTween)
                                    .value,
                                topRight: _controller
                                    .drive(_topRightOffsetTween)
                                    .value,
                                bottomLeft: _controller
                                    .drive(_bottomLeftOffsetTween)
                                    .value,
                                bottomRight: _controller
                                    .drive(_bottomRightOffsetTween)
                                    .value,
                              ),
                              size: SizeTween(
                                      begin: _originalSize, end: _zoomedSize)
                                  .animate(
                                    CurvedAnimation(
                                      parent: _controller,
                                      curve: const Interval(
                                        0.5,
                                        1.0,
                                        curve: Curves.ease,
                                      ),
                                    ),
                                  )
                                  .value!,
                            ),
                          ),
                          Center(
                            child: Text('Click me!'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StretchPainter extends CustomPainter {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomLeft;
  final Offset bottomRight;

  const StretchPainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  static final _paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.amber;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(topLeft.dx, topLeft.dy);
    path.lineTo(topRight.dx, topRight.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant StretchPainter oldDelegate) {
    return topLeft != oldDelegate.topLeft ||
        topRight != oldDelegate.topRight ||
        bottomLeft != oldDelegate.bottomLeft ||
        bottomRight != oldDelegate.bottomRight;
  }
}
