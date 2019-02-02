// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Tagss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tagss _$TagssFromJson(Map<String, dynamic> json) {
  return Tagss(
      int.parse(json['idtag']),
      int.parse(json['idprotocolo']),
      json['tag'] == null
          ? null
          : Tag.fromJson(json['tag'] as Map<String, dynamic>),
      json['inserted'] as int);
}

Map<String, dynamic> _$TagssToJson(Tagss instance) => <String, dynamic>{
      'idtag': instance.idtag,
      'idprotocolo': instance.idprotocolo,
      'tag': instance.tag,
      'inserted': instance.inserted
    };
