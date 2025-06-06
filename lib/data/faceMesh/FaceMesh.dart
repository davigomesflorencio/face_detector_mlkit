import 'dart:ui';

import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'FaceMeshCountourType.dart';
import 'FaceMeshPoint.dart';
import 'FaceMeshTriangle.dart';

class FaceMesh {
  final Rect boundingBox;

  final List<FaceMeshPoint> points;

  final List<FaceMeshTriangle> triangles;

  final Map<FaceMeshContourType, List<FaceMeshPoint>?> contours;

  FaceMesh({required this.boundingBox, required this.points, required this.triangles, required this.contours});

  factory FaceMesh.fromJson(Map<dynamic, dynamic> json) => FaceMesh(
        boundingBox: RectJson.fromJson(json['rect']),
        points: json['points']
            .map((element) {
              return FaceMeshPoint.fromJson(element);
            })
            .cast<FaceMeshPoint>()
            .toList(),
        triangles: json['triangles']
            .map((element) {
              return FaceMeshTriangle.fromJson(element);
            })
            .cast<FaceMeshTriangle>()
            .toList(),
        contours: Map<FaceMeshContourType, List<FaceMeshPoint>>.fromIterables(FaceMeshContourType.values,
            FaceMeshContourType.values.map((FaceMeshContourType type) {
          final List<dynamic>? arr = (json['contours'] ?? {})[type.index];
          return (arr == null)
              ? []
              : arr
                  .map((element) {
                    return FaceMeshPoint.fromJson(element);
                  })
                  .cast<FaceMeshPoint>()
                  .toList();
        })),
      );
}
