import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class TextRasterizationScreen extends StatefulWidget {
  const TextRasterizationScreen({Key? key}) : super(key: key);

  @override
  State<TextRasterizationScreen> createState() =>
      _TextRasterizationScreenState();
}

class _TextRasterizationScreenState extends State<TextRasterizationScreen> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Text Rasterization',
                  style: TextStyle(fontSize: 30),
                ),
                DisplaySimulator(
                  text: text,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Type text for rasterization',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                _getTextField(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTextField() {
    const borderSide = BorderSide(color: Colors.blue, width: 4);
    const inputDecoration = InputDecoration(
      border: UnderlineInputBorder(borderSide: borderSide),
      disabledBorder: UnderlineInputBorder(borderSide: borderSide),
      enabledBorder: UnderlineInputBorder(borderSide: borderSide),
      focusedBorder: UnderlineInputBorder(borderSide: borderSide),
    );

    return SizedBox(
      width: 200,
      child: TextField(
        maxLines: null,
        enableSuggestions: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, fontFamily: "Monospace"),
        decoration: inputDecoration,
        onChanged: (val) {
          setState(() {
            text = val;
          });
        },
      ),
    );
  }
}

class DisplaySimulator extends StatefulWidget {
  const DisplaySimulator({
    Key? key,
    required this.text,
    this.debug = false,
    this.border = false,
  }) : super(key: key);

  final String text;
  final bool debug;
  final bool border;

  @override
  State<DisplaySimulator> createState() => _DisplaySimulatorState();
}

class _DisplaySimulatorState extends State<DisplaySimulator> {
  ByteData? imageBytes;
  List<List<Color>> pixels = [];

  Future<void> _obtainPixelsFromText(String text) async {
    final result = await ToPixelsConverter.fromString(
      string: text,
      canvasSize: 100,
      border: widget.border,
    ).convert();

    setState(() {
      imageBytes = result.imageBytes;
      pixels = result.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    _obtainPixelsFromText(widget.text);
  }

  @override
  void didUpdateWidget(covariant DisplaySimulator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _obtainPixelsFromText(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _getDisplay(),
      ],
    );
  }

  Widget _getDisplay() {
    if (pixels.isEmpty) {
      return Container();
    }

    return CustomPaint(
      size: Size.square(MediaQuery.of(context).size.width / 3),
      painter: DisplayPainter(
        pixels: pixels,
        canvasSize: 100,
      ),
    );
  }
}

class DisplayPainter extends CustomPainter {
  const DisplayPainter({
    required this.pixels,
    required this.canvasSize,
  });

  final List<List<Color>> pixels;
  final double canvasSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (pixels.isEmpty) {
      return;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    final widthFactor = canvasSize / size.width;

    final rectPaint = Paint()..color = Colors.black;
    final circlePaint = Paint()..color = Colors.yellow;

    for (var i = 0; i < pixels.length; i++) {
      for (var j = 0; j < pixels[i].length; j++) {
        final rectSize = 1.0 / widthFactor;
        final circleSize = 0.3 / widthFactor;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(
              i.toDouble() * rectSize + rectSize / 2,
              j.toDouble() * rectSize + rectSize / 2,
            ),
            width: rectSize,
            height: rectSize,
          ),
          rectPaint,
        );

        if (pixels[i][j].opacity < 0.3) {
          continue;
        }

        canvas.drawCircle(
          Offset(
            i.toDouble() * rectSize + rectSize / 2 - circleSize / 2,
            j.toDouble() * rectSize + rectSize / 2 - circleSize / 2,
          ),
          circleSize,
          circlePaint..color = pixels[i][j],
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TextToPictureConverter {
  static ui.Picture convert({
    required String text,
    required double canvasSize,
    required bool border,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      Rect.fromPoints(Offset.zero, Offset(canvasSize, canvasSize)),
    );

    const Color color = Colors.white;

    if (border) {
      final stroke = ui.Paint()
        ..color = color
        ..style = ui.PaintingStyle.stroke;

      canvas.drawRect(
        ui.Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize),
        stroke,
      );
    }

    final span = TextSpan(
      style:
          const TextStyle(fontFamily: "Monospace", color: color, fontSize: 24),
      text: text,
    );

    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    tp.layout();

    final offset = ui.Offset(
      (canvasSize - tp.width) * 0.5,
      (canvasSize - tp.height) * 0.5,
    );
    tp.paint(canvas, offset);

    return recorder.endRecording();
  }
}

/// conversion result
class ToPixelsConversionResult {
  const ToPixelsConversionResult({
    required this.imageBytes,
    required this.pixels,
  });

  final ByteData imageBytes;
  final List<List<ui.Color>> pixels;
}

/// converter from string to pixels
class ToPixelsConverter {
  final String string;
  final double canvasSize;
  final bool border;

  ToPixelsConverter.fromString({
    required this.string,
    required this.canvasSize,
    this.border = false,
  });

  Future<ToPixelsConversionResult> convert() async {
    final ui.Picture picture = TextToPictureConverter.convert(
      text: string,
      canvasSize: canvasSize,
      border: border,
    );

    final ByteData imageBytes = await _pictureToBytes(picture);
    final List<List<ui.Color>> pixels = _bytesToPixelArray(imageBytes);

    return ToPixelsConversionResult(
      imageBytes: imageBytes,
      pixels: pixels,
    );
  }

  Future<ByteData> _pictureToBytes(ui.Picture picture) async {
    final ui.Image img =
        await picture.toImage(canvasSize.toInt(), canvasSize.toInt());
    return (await img.toByteData(format: ui.ImageByteFormat.png))!;
  }

  List<List<ui.Color>> _bytesToPixelArray(ByteData imageBytes) {
    final values = imageBytes.buffer.asUint8List();
    final decodedImage = image.decodeImage(values)!;
    final pixelArray = List.generate(
      canvasSize.toInt(),
      (_) => List.generate(canvasSize.toInt(), (_) => Colors.black),
    );

    for (int i = 0; i < canvasSize.toInt(); i++) {
      for (int j = 0; j < canvasSize.toInt(); j++) {
        final pixel = decodedImage.getPixelSafe(i, j);
        final hex = _convertColorSpace(pixel);
        pixelArray[i][j] = Color(hex);
      }
    }

    return pixelArray;
  }

  int _convertColorSpace(int argbColor) {
    // ARGB
    final r = (argbColor >> 16) & 0xFF;
    final b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
