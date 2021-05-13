/*import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/models/percurso.dart';
import 'package:visit_sps/widgets/item_unico_fila_percurso.dart';

class PaginaPercursos extends StatelessWidget {
  static const routeName = '/mostrar-percursos';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper().getPercurso(), //Obter Locais
      builder: (context, AsyncSnapshot<List<Percurso>> snapshot) {
        if (snapshot.hasData) {
          List<Percurso> percursos = snapshot.data;
          int n = percursos.length;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2.0, left: 13),
                child: Text(
                  'categoria_todos'.tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 35,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //Mostrar todos os locais
                  if (n.isEven)
                    for (var i = 0; i < percursos.length; i += 2)
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 9, top: 10, bottom: 5, right: 8),
                            child: Row(
                              children: [
                                ItemUnicoFilaPercurso(percursos, i),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child:
                                      ItemUnicoFilaPercurso(percursos, i + 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  else
                    Column(
                      children: [
                        for (var i = 0; i < percursos.length - 1; i += 2)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 9, top: 10, bottom: 5, right: 8),
                                child: Row(
                                  children: [
                                    ItemUnicoFilaPercurso(percursos, i),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: ItemUnicoFilaPercurso(
                                            percursos, i + i))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 9, top: 10, bottom: 5, right: 8),
                          child: Row(
                            children: [
                              ItemUnicoFilaPercurso(
                                  percursos, percursos.length - 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
*/
