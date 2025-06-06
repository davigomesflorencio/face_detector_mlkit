import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detector_mlkit/painters/face_mesh_detector.dart';
import 'package:face_detector_mlkit/painters/face_mesh_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../data/faceMesh/FaceMeshDetectorOptions.dart';
import 'detector_view.dart';

class FaceMeshDetectorView extends StatefulWidget {
  const FaceMeshDetectorView({Key? key}) : super(key: key);

  @override
  State<FaceMeshDetectorView> createState() => _FaceMeshDetectorViewState();
}

class _FaceMeshDetectorViewState extends State<FaceMeshDetectorView> {
  final FaceMeshDetector _meshDetector = FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _meshDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: Text('Em construção')),
        body: Center(
          child: Text(
            "Ainda não implementado para iOS :(\nExperimente Android')",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return DetectorView(
      title: 'Face Detector Mesh - DF MLKIT',
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
      final meshes = await _meshDetector.processImage(inputImage);
      if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
        final painter = FaceMeshDetectorPainter(
          meshes,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        );
        _customPaint = CustomPaint(painter: painter);
      } else {
        String text = 'Face meshes found: ${meshes.length}\n\n';
        for (final mesh in meshes) {
          text += 'face: ${mesh.boundingBox}\n\n';
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
