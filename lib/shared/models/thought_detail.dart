import 'package:equatable/equatable.dart';

class ThoughtDetail extends Equatable {
  const ThoughtDetail({
    required this.shapeId,
    this.cause = '',
    this.root = '',
    this.resolution = '',
  });

  final String shapeId;
  final String cause;
  final String root;
  final String resolution;

  ThoughtDetail copyWith({
    String? cause,
    String? root,
    String? resolution,
  }) {
    return ThoughtDetail(
      shapeId: shapeId,
      cause: cause ?? this.cause,
      root: root ?? this.root,
      resolution: resolution ?? this.resolution,
    );
  }

  @override
  List<Object?> get props => [shapeId, cause, root, resolution];
}
