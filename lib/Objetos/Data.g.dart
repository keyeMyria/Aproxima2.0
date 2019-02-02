// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['protocolo'] as String,
      json['image'] as String,
      json['is_backgroud'] as bool,
      json['payload'] == null
          ? null
          : Payload.fromJson(json['payload'] as Map<String, dynamic>),
      json['title'] as String,
      json['message'] as String,
      json['timestamp'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'protocolo': instance.protocolo,
      'image': instance.image,
      'is_backgroud': instance.is_backgroud,
      'payload': instance.payload,
      'title': instance.title,
      'message': instance.message,
      'timestamp': instance.timestamp
    };
