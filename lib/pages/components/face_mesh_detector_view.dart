import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_detector_mlkit/painters/Face.dart';
import 'package:face_detector_mlkit/painters/face_mesh_detector.dart';
import 'package:face_detector_mlkit/painters/face_mesh_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'detector_view.dart';

class FaceMeshDetectorView extends StatefulWidget {
  @override
  State<FaceMeshDetectorView> createState() => _FaceMeshDetectorViewState();
}

class _FaceMeshDetectorViewState extends State<FaceMeshDetectorView> {
  final FaceMeshDetector _meshDetector =
      FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
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
        appBar: AppBar(title: Text('Under construction')),
        body: Center(
            child: Text(
          'Ainda não implementado para iOS :(\nExperimente Android',
          textAlign: TextAlign.center,
        )),
      );
    }
    return DetectorView(
      title: 'Face Mesh Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final meshes = await _meshDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
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
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
