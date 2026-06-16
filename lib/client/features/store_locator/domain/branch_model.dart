import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

/// Branch model
/// Maps to branches table
@JsonSerializable()
class BranchModel {
  @JsonKey(name: 'branch_id')
  final String branchId;

  final String name;
  final String address;
  final double lat;
  final double lng;
  final String phone;

  @JsonKey(name: 'is_service_center')
  final bool isServiceCenter;

  @JsonKey(name: 'hours_text')
  final String hoursText;

  BranchModel({
    required this.branchId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.isServiceCenter,
    required this.hoursText,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}
