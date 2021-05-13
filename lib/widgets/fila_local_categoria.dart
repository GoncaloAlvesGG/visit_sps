import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/categoria.dart';

class LocalCategoria extends StatelessWidget {
  const LocalCategoria(
    this.categorias,
  );

  final List<Categoria> categorias;

  //Lista de Categorias associadas a um Local
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < categorias.length; i++)
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.14,
                    child: Container(
                      child: Column(
                        children: [
                          Icon(
                            IconData(
                              categorias[i].icon,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Color.fromRGBO(0, 119, 182, 1),
                            size: 52.5,
                          ),
                          Expanded(
                            child: Text(
                              context.locale == Locale('pt', '')
                                  ? categorias[i].nome
                                  : categorias[i].nomeEng,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 119, 182, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/mostrar-categoria1',
                      arguments: [
                        categorias[i],
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
