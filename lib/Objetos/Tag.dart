import 'package:json_annotation/json_annotation.dart';

part 'Tag.g.dart';

@JsonSerializable()
class Tag {
  int id;
  String tag_nome;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  int idLocal;
  int getIdLocal() {
    return idLocal;
  }

  @override
  String toString() {
    return 'Tag{id: $id, tag_nome: $tag_nome, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, idLocal: $idLocal}';
  }

  void setIdLocal(int idLocal) {
    this.idLocal = idLocal;
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Tag(this.id, this.tag_nome, this.created_at, this.updated_at, this.deleted_at,
      this.idLocal);
}
