import 'package:flutter/foundation.dart';

class Local {
  final int id;
  final String nome;
  final String desc;
  final String descEng;
  final String imagemUrl;
  final String horario;
  final String horarioEng;
  final String contacto;
  final String morada;
  final double latitude;
  final double longitude;
  int isBook;
  final String trivago;

  Local(
      {@required this.id,
      @required this.nome,
      @required this.desc,
      @required this.descEng,
      @required this.imagemUrl,
      this.contacto,
      this.horario,
      this.horarioEng,
      @required this.morada,
      @required this.latitude,
      @required this.longitude,
      @required this.isBook,
      this.trivago});

  factory Local.fromMap(Map<String, dynamic> json) => new Local(
        id: json["id_local"],
        nome: json["nome"],
        desc: json["desc"],
        imagemUrl: json["imageUrl"],
        horario: json["horario"],
        contacto: json["contacto"],
        morada: json["morada"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isBook: json["isBook"],
        descEng: json["desc_eng"],
        horarioEng: json["horario_eng"],
        trivago: json["trivago"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id_local': id,
      'nome': nome,
      'desc': desc,
      'imagemUrl': imagemUrl,
      'horario': horario,
      'contacto': contacto,
      'morada': morada,
      'latitude': latitude,
      'longitude': longitude,
      'isBook': isBook,
      'desc_eng': descEng,
      'horario_eng': horarioEng,
      'trivago': trivago,
    };
  }
}
