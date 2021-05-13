import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/widgets/item_unico_fila.dart';

class PaginaMostrarTudo extends StatelessWidget {
  static const routeName = '/mostrar-tudo';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper().getLocais(), //Obter Locais
      builder: (context, AsyncSnapshot<List<Local>> snapshot) {
        if (snapshot.hasData) {
          List<Local> locais = snapshot.data;
          int n = locais.length;
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
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 35,
                  ),

                  //Abrir página de procura
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  //Mostrar todos os locais
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
                                  padding: const EdgeInsets.only(left: 16),
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
                                    left: 9, top: 10, bottom: 5, right: 8),
                                child: Row(
                                  children: [
                                    ItemUnicoFila(locais, i),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
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

//Pagina de Procura por nome
class CustomSearchDelegate extends SearchDelegate {
  //Caso não encontre
  semDados() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            'nExiste'.tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Futura PT',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
        ),
      ],
    );
  }

  //Tema
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Theme.of(context).accentColor,
      textTheme: (TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Futura PT',
          fontSize: 24,
          color: Colors.white,
        ),
      )),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Futura PT',
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
    );
  }

  //Icon limpar caixa de texto
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  //Icon retornar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  //Erro caso a pesquisa tenha menos de 2 caracteres
  @override
  Widget buildResults(BuildContext context) {
    if (query.length <= 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              '2carac'.tr().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Futura PT',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          )
        ],
      );
    }

    //Mostrar locais da procura
    return FutureBuilder(
        future: DBHelper().procurarLocal(query),
        builder: (context, AsyncSnapshot<List<Local>> snapshot) {
          if (snapshot.hasData) {
            List<Local> locais = snapshot.data;
            int n = locais.length;
            return locais.length != 0
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        if (n.isEven)
                          for (var i = 0; i < locais.length; i += 2)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 9,
                                    top: 10,
                                    bottom: 5,
                                    right: 8,
                                  ),
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
                : semDados();
          } else {
            return semDados();
          }
        });
  }

  //Não é necessário
  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
