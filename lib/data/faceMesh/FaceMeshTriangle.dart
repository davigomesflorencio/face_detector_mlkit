import 'FaceMeshPoint.dart';

class FaceMeshTriangle {
  /// Gets all points inside the [FaceMeshTriangle].
  final List<FaceMeshPoint> points;

  /// Creates a triangle with 3 generic points.
  FaceMeshTriangle({required this.points});

  /// Returns an instance of [FaceMeshTriangle] from a given [json].
  factory FaceMeshTriangle.fromJson(List<dynamic> json) => FaceMeshTriangle(
      points: json
          .map((element) {
            return FaceMeshPoint.fromJson(element);
          })
          .cast<FaceMeshPoint>()
          .toList());
}
