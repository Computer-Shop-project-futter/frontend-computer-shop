import 'package:json_annotation/json_annotation.dart';
import 'pagination_meta.dart';


/// Generic API response wrapper
/// Handles both single item and paginated list responses
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final T data;
  
  @JsonKey(name: 'meta')
  final PaginationMeta? meta;

  ApiResponse({
    required this.data,
    this.meta,
  });

  /// Check if response is paginated
  bool get isPaginated => meta != null;

  /// Utility constructor for single item responses
  factory ApiResponse.single(T data) => ApiResponse(data: data);

  /// Utility constructor for paginated responses
  factory ApiResponse.paginated(T data, PaginationMeta meta) =>
      ApiResponse(data: data, meta: meta);

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
