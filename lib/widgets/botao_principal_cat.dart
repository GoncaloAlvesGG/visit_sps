import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/categoria.dart';
import 'package:easy_localization/easy_localization.dart';

class BotaoPrincipalCategoria extends StatelessWidget {
  final int n;
  final String nomeDestaque;

  const BotaoPrincipalCategoria({
    @required this.n,
    @required this.nomeDestaque,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper().getCats(), //Obter todas as categorias
        builder: (context, AsyncSnapshot<List<Categoria>> snapshot) {
          if (snapshot.hasData) {
            List<Categoria> categorias = snapshot.data;
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
                left: 12,
                right: 12,
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/mostrar-categoria1',
                          arguments: [categorias[n]]);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          //Texto no Botão
                          child: context.locale == Locale('pt', '')
                              ? Text(
                                  'Ver mais na categoria ' + categorias[n].nome,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 119, 182, 1),
                                  ),
                                )
                              : Text(
                                  'See more on ' +
                                      categorias[n].nome +
                                      ' category',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 119, 182, 1),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
