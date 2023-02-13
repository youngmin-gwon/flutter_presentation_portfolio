import 'dart:math' as math;
import 'package:flutter/material.dart';

class CurtainBlindAnimationScreen extends StatefulWidget {
  const CurtainBlindAnimationScreen({Key? key}) : super(key: key);

  @override
  State<CurtainBlindAnimationScreen> createState() =>
      _CurtainBlindAnimationScreenState();
}

class _CurtainBlindAnimationScreenState
    extends State<CurtainBlindAnimationScreen>
    with SingleTickerProviderStateMixin {
  Color iconTheme = Colors.black;

  final blindAngle = ValueNotifier<double>(0);
  final blindPosition = ValueNotifier<double>(0);

  final _blindCount = 13;
  final _blindHeight = 22.0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: iconTheme,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const _WindowBackgroundWidget(),
                      ...[
                        for (var i = 0; i < 15; i++)
                          ValueListenableBuilder<double>(
                            valueListenable: blindPosition,
                            builder: (context, position, child) {
                              return Positioned(
                                top: 10 +
                                    (_blindHeight + 5) *
                                        _blindCount *
                                        position.clamp(0, 0.1 / 15 * 10 * i),
                                left: 0,
                                right: 0,
                                child: child!,
                              );
                            },
                            child: _WindowBlindWidget(
                              height: _blindHeight,
                              blindAngle: blindAngle,
                            ),
                          ),
                      ],
                      const _WindowBlindHeaderWidget(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<double>(
                valueListenable: blindAngle,
                builder: (context, value, child) {
                  return Slider(
                    value: blindAngle.value,
                    onChanged: (double newValue) {
                      blindAngle.value = newValue;
                    },
                  );
                },
              ),
              ValueListenableBuilder<double>(
                valueListenable: blindPosition,
                builder: (context, value, child) {
                  return Slider(
                    value: blindPosition.value,
                    onChanged: (double newValue) {
                      blindPosition.value = newValue;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WindowBackgroundWidget extends StatelessWidget {
  const _WindowBackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const RadialGradient(
          center: Alignment.topCenter,
          radius: 3.0,
          colors: [
            Color(0xFF98B9F2),
            Color(0xFF6895E2),
          ],
          stops: [
            0.1,
            0.4,
          ],
        ),
      ),
    );
  }
}

class _WindowBlindHeaderWidget extends StatelessWidget {
  const _WindowBlindHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        left: 8,
        right: 8,
      ),
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFFFCFBFB),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(3.0, 2.0),
            blurRadius: 2,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            offset: const Offset(-3.0, 2.0),
            blurRadius: 2,
            spreadRadius: 1.0,
          ),
        ],
      ),
    );
  }
}

class _WindowBlindWidget extends StatelessWidget {
  const _WindowBlindWidget({
    Key? key,
    required this.blindAngle,
    this.height = 22,
  }) : super(key: key);

  final ValueNotifier<double> blindAngle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: blindAngle,
      builder: (context, angle, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-angle * (math.pi * (90 - 10) / 180)),
          alignment: FractionalOffset.center,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 13,
          right: 13,
        ),
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[300]!,
              Colors.grey[200]!,
              Colors.grey[100]!,
              Colors.white,
            ],
            stops: const [
              0.1,
              0.2,
              0.3,
              0.5,
            ],
          ),
        ),
      ),
    );
  }
}
