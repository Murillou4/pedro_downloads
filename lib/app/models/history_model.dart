// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoryModel {
  String nome;
  String url;
  String path;
  String data;
  String tipo;
  HistoryModel({
    required this.nome,
    required this.url,
    required this.path,
    required this.data,
    required this.tipo,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'url': url,
      'path': path,
      'data': data,
      'tipo': tipo,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      nome: map['nome'] as String,
      url: map['url'] as String,
      path: map['path'] as String,
      data: map['data'] as String,
      tipo: map['tipo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) => HistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
