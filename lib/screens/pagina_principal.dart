import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:visit_sps/widgets/botao_principal_cat.dart';
import 'package:visit_sps/widgets/fila_item_reverso.dart';
import 'package:after_layout/after_layout.dart';

import '../widgets/fila_item.dart';
import '../widgets/swiper_menu_principal.dart';

class PaginaPrincipal extends StatefulWidget {
  static const routeName = '/principal';

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal>
    with AfterLayoutMixin<PaginaPrincipal> {
  DBHelper dbHelper = new DBHelper();

  //Verificar se é a primeira vez a iniciar app, para eliminar a base de dados antiga e/ou copiar uma nova.
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      DBHelper().startDB();
    } else {
      await prefs.setBool('seen', true);
      DBHelper().deleteDB();
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper().getLocais(), //Obter todos os Locais
      builder: (context, AsyncSnapshot<List<Local>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Local> locais = snapshot.data;
          return Scaffold(
            backgroundColor: Color.fromRGBO(245, 245, 245, 1),
            body: CustomScrollView(slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.16),
                backgroundColor: Theme.of(context).accentColor,
                elevation: 6,
                floating: true,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4.0),
                    child: Image.asset(
                      './assets/images/appbar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                          CarosselMenuPrincipal(locais), //Carrossel de imagems
                          SizedBox(
                            height: 8,
                          ),
                          FilaItem(
                            //Fila de itens
                            locais,
                            'destaque1'.tr().toString(),
                            4,
                          ),
                          FutureBuilder(
                              future: DBHelper()
                                  .getLocaisCatNatureza(), //Obter Locais marcados com categoria Natureza
                              builder: (context,
                                  AsyncSnapshot<List<Local>> snapshot) {
                                if (snapshot.hasData) {
                                  List<Local> locais1 = snapshot.data;
                                  return Column(
                                    children: [
                                      FilaItem(
                                        //Fila de itens
                                        locais1,
                                        'destaque3'.tr().toString(),
                                        3,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                          BotaoPrincipalCategoria(
                            //Ver mais marcados com a categoria selecionada
                            nomeDestaque: 'destaque3_texto',
                            n: 4,
                          ),
                          FilaItemReverso(
                            //Obter locais recentementes adicionados
                            locais,
                            'destaque2'.tr().toString(),
                            4,
                          ),
                          Container(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ]),
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
