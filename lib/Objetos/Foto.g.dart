// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Foto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Foto _$FotoFromJson(Map<String, dynamic> json) {
  return Foto(
      int.parse(json['id_foto']),
      json['link'] as String,
      int.parse(json['id_user']),
      int.parse(json['id_protocolo']),
      json['texto'] as String,
      json['hora_publicacao'] == null
          ? null
          : DateTime.parse(json['hora_publicacao'] as String));
}

Map<String, dynamic> _$FotoToJson(Foto instance) => <String, dynamic>{
      'id_foto': instance.id_foto,
      'link': instance.link,
      'id_user': instance.id_user,
      'id_protocolo': instance.id_protocolo,
      'texto': instance.texto,
      'hora_publicacao': instance.hora_publicacao?.toIso8601String()
    };
