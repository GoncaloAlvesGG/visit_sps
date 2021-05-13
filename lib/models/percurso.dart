import 'package:flutter/foundation.dart';

class Percurso {
  final int id;
  final String nome;
  final String pontos;
  final String imagem;

  Percurso({
    @required this.id,
    @required this.nome,
    @required this.pontos,
    @required this.imagem,
  });

  factory Percurso.fromMap(Map<String, dynamic> json) => new Percurso(
        id: json["id"],
        nome: json["nome"],
        pontos: json["pontos"],
        imagem: json["imagem"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'pontos': pontos,
      'imagem': imagem,
    };
  }
}
