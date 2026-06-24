// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
  branchId: json['branch_id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  phone: json['phone'] as String,
  isServiceCenter: json['is_service_center'] as bool,
  hoursText: json['hours_text'] as String,
);

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'name': instance.name,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': instance.phone,
      'is_service_center': instance.isServiceCenter,
      'hours_text': instance.hoursText,
    };
