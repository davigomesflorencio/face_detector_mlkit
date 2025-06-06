/// Represents a 3D point in face mesh, by index and PointF3D.
class FaceMeshPoint {
  /// Gets the index of the face mesh point, ranging from 0 to 467.
  final int index;

  /// Returns the X value of the point.
  final double x;

  /// Returns the Y value of the point.
  final double y;

  /// Returns the Z value of the point.
  final double z;

  /// Creates a face mesh point.
  FaceMeshPoint({
    required this.index,
    required this.x,
    required this.y,
    required this.z,
  });

  /// Returns an instance of [FaceMeshPoint] from a given [json].
  factory FaceMeshPoint.fromJson(Map<dynamic, dynamic> json) => FaceMeshPoint(
        index: json['index'],
        x: json['x'],
        y: json['y'],
        z: json['z'],
      );
}
