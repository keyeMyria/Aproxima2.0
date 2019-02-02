// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Notificacao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notificacao _$NotificacaoFromJson(Map<String, dynamic> json) {
  return Notificacao(
      json['image'] as String,
      json['id_protocolo'] as String,
      json['title'] as String,
      json['message'] as String,
      json['behaivior'] as int,
      (json['firebasekeys'] as List)?.map((e) => e as String)?.toList(),
      json['topic'] as String);
}

Map<String, dynamic> _$NotificacaoToJson(Notificacao instance) =>
    <String, dynamic>{
      'image': instance.image,
      'id_protocolo': instance.id_protocolo,
      'title': instance.title,
      'message': instance.message,
      'behaivior': instance.behaivior,
      'firebasekeys': instance.firebasekeys,
      'topic': instance.topic
    };
