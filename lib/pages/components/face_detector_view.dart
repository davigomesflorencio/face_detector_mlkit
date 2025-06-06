import 'dart:async';

import 'package:camera/camera.dart';
import 'package:face_detector_mlkit/painters/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'detector_view.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({Key? key}) : super(key: key);

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    try {
      if (!_canProcess || _isBusy) return;

      _isBusy = true;
      setState(() {
        _text = '';
      });
      final faces = await _faceDetector.processImage(inputImage);
      if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
        final painter = FaceDetectorPainter(
          faces,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        );
        _customPaint = CustomPaint(painter: painter);
      } else {
        String text = 'Faces found: ${faces.length}\n\n';
        for (final face in faces) {
          text += 'face: ${face.boundingBox}\n\n';
        }
        _text = text;
        _customPaint = null;
      }
      _isBusy = false;
      if (mounted) setState(() {});
    } on PlatformException catch (e) {
      _handleError('Erro na plataforma: ${e.message}');
    } on TimeoutException catch (e) {
      _handleError(e.message ?? 'Tempo limite excedido');
    } on Exception catch (e) {
      _handleError('Erro no processamento: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    if (!mounted) return;

    setState(() {
      _text = 'Falha ao processar imagem';
      _customPaint = null;
    });

    debugPrint('Erro no processamento de imagem: $message');
  }
}
