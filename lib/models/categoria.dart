import 'package:flutter/foundation.dart';

class Categoria {
  final int id;
  final String nome;
  final String nomeEng;
  final int icon;

  Categoria({
    @required this.id,
    @required this.nome,
    this.nomeEng,
    @required this.icon,
  });

  factory Categoria.fromMap(Map<String, dynamic> json) => new Categoria(
        id: json["id_cat"],
        nome: json["nome"],
        nomeEng: json["nome_eng"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id_cat': id,
      'nome': nome,
      'nome_eng': nomeEng,
      'icon': icon,
    };
  }
}
