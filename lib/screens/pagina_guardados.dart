import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/item_unico_fila.dart';

class PaginaGuardados extends StatefulWidget {
  static const routeName = '/guardados';
  @override
  _PaginaGuardadosState createState() => _PaginaGuardadosState();
}

class _PaginaGuardadosState extends State<PaginaGuardados> {
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper().buscarBook(1),
      builder: (context, AsyncSnapshot<List<Local>> snapshot) {
        if (snapshot.hasData) {
          List<Local> locais = snapshot.data;
          int n = locais.length;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  'titulo3'.tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            body: locais.length != 0
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        //Caso o número de locais ser par
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
                          //Caso o número de Locais seja impar, geral o último sozinho
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
                : // Não existe guardados
                Center(
                    child: AutoSizeText(
                      'adicionar'.tr().toString(),
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
