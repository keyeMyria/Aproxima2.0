// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payload _$PayloadFromJson(Map<String, dynamic> json) {
  return Payload(json['score'] as String, json['behaivior'] as String,
      json['team'] as String);
}

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'score': instance.score,
      'behaivior': instance.behaivior,
      'team': instance.team
    };
