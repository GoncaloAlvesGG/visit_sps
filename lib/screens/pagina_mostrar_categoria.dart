import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/categoria.dart';
import 'package:visit_sps/models/local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/widgets/item_unico_fila.dart';

class PaginaMostrarCategoria extends StatelessWidget {
  static const routeName = '/mostrar-categoria';
  @override
  Widget build(BuildContext context) {
    List<Categoria> lista = ModalRoute.of(context)
        .settings
        .arguments; //Lista com informações do local
    return FutureBuilder(
      future: DBHelper().getLocaisCat(lista[0].id),
      builder: (context, AsyncSnapshot<List<Local>> snapshot) {
        if (snapshot.hasData) {
          List<Local> locais = snapshot.data;
          int n = locais.length;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: AutoSizeText(
                    context.locale == Locale('pt', '')
                        ? lista[0].nome
                        : lista[0].nomeEng,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Futura PT',
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              leading: GestureDetector(
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            body: locais.length != 0
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        //Gerar número de locais consoante o existentes na lista
                        if (n.isEven)
                          for (var i = 0; i < locais.length; i += 2)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 9, top: 10, bottom: 5, right: 8),
                                  child: Row(
                                    children: [
                                      ItemUnicoFila(locais, i),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: ItemUnicoFila(locais, i + 1),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                        else
                          Column(
                            children: [
                              for (var i = 0; i < locais.length - 1; i += 2)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 9,
                                          top: 10,
                                          bottom: 5,
                                          right: 8),
                                      child: Row(
                                        children: [
                                          ItemUnicoFila(locais, i),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: ItemUnicoFila(locais, i + 1),
                                          )
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
                                    ItemUnicoFila(locais, locais.length - 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: AutoSizeText(
                      'associar'.tr().toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
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
