class Apoio {
  int id;
  DateTime createdData;
  String chave;

  Apoio(this.id, this.createdData);

  @override
  String toString() {
    return 'Apoio{id: $id, createdData: $createdData, chave: $chave}';
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'data': createdData.millisecondsSinceEpoch};
  }
}
