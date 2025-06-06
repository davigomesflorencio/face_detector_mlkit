import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../data/faceMesh/FaceMesh.dart';
import '../data/faceMesh/FaceMeshTriangle.dart';
import 'coordinates_translator.dart';

class FaceMeshDetectorPainter extends CustomPainter {
  FaceMeshDetectorPainter(
    this.meshes,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<FaceMesh> meshes;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color.fromARGB(100, 53, 141, 150);
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..color = Colors.green;

    final paintFace = Paint()
      ..color = Color.fromARGB(100, 53, 141, 250)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final FaceMesh mesh in meshes) {
      final left = translateV2X(
        mesh.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateV2Y(
        mesh.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateV2X(
        mesh.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateV2Y(
        mesh.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );

      void paintTriangle(FaceMeshTriangle triangle) {
        final List<Offset> cornerPoints = <Offset>[];
        for (final point in triangle.points) {
          final double x = translateV2X(
            point.x.toDouble(),
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          );
          final double y = translateV2Y(
            point.y.toDouble(),
            size,
            imageSize,
            rotation,
            cameraLensDirection,
          );

          cornerPoints.add(Offset(x, y));
        }
        // Add the first point to close the polygon
        cornerPoints.add(cornerPoints.first);
        canvas.drawPoints(PointMode.polygon, cornerPoints, paintFace);
      }

      for (final triangle in mesh.triangles) {
        paintTriangle(triangle);
      }
    }
  }

  @override
  bool shouldRepaint(FaceMeshDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.meshes != meshes;
  }
}
