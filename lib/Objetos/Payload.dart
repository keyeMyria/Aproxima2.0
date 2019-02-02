import 'package:json_annotation/json_annotation.dart';

part 'Payload.g.dart';

@JsonSerializable()
class Payload {
  String score;
  String behaivior;
  String team;

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);
  Payload(this.score, this.behaivior, this.team);
}
