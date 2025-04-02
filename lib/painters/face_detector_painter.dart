import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Color.fromARGB(100, 3, 169, 244);
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..color = Colors.green;

    final paintFace = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final Face face in faces) {
      final left = translateV2X(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateV2Y(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateV2X(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateV2Y(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );

      void paintContour(FaceContourType type) {
        final contour = face.contours[type];
        if (contour?.points != null) {
          for (final Point point in contour!.points) {
            canvas.drawCircle(
                Offset(
                  translateV2X(
                    point.x.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                  translateV2Y(
                    point.y.toDouble(),
                    size,
                    imageSize,
                    rotation,
                    cameraLensDirection,
                  ),
                ),
                1,
                paint1);
          }

          // Conecta os pontos com linhas
          final path = Path();
          path.moveTo(
            translateV2X(
              contour!.points.first.x.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateV2Y(
              contour!.points.first.y.toDouble(),
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
          );
          for (int i = 1; i < contour!.points.length; i++) {
            path.lineTo(
              translateV2X(
                contour!.points[i].x.toDouble(),
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateV2Y(
                contour!.points[i].y.toDouble(),
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            );
          }

          // Conecta o último ao primeiro para fechar a forma
          if (contour!.points.length > 2) {
            path.lineTo(
              translateV2X(
                contour!.points.first.x.toDouble(),
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
              translateV2Y(
                contour!.points.first.y.toDouble(),
                size,
                imageSize,
                rotation,
                cameraLensDirection,
              ),
            );
            // path.lineTo(
            //   contour!.points.first.x.toDouble(),
            //   contour!.points.first.y.toDouble(),
            // );
          }

          canvas.drawPath(path, paintFace);
        }
      }

      void paintLandmark(FaceLandmarkType type) {
        final landmark = face.landmarks[type];
        if (landmark?.position != null) {
          canvas.drawCircle(
              Offset(
                translateV2X(
                  landmark!.position.x.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateV2Y(
                  landmark.position.y.toDouble(),
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
              ),
              2,
              paint2);
        }
      }

      for (final type in FaceContourType.values) {
        paintContour(type);
      }

      for (final type in FaceLandmarkType.values) {
        paintLandmark(type);
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
