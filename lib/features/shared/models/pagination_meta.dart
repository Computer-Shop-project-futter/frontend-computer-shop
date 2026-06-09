import 'package:json_annotation/json_annotation.dart';

part '../../../shared/models/pagination_meta.g.dart';

/// Pagination metadata for list responses
@JsonSerializable()
class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  /// Calculate total pages
  int get totalPages => (total / limit).ceil();

  /// Check if there's a next page
  bool get hasNextPage => page < totalPages;

  /// Get next page number
  int get nextPage => page + 1;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}
