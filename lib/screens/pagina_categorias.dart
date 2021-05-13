import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/screens/pagina_mostrar_tudo.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/categoria.dart';
import '../widgets/botao_categoria.dart';

class PaginaCategoria extends StatefulWidget {
  static const routeName = '/categorias';

  @override
  _PaginaCategoriaState createState() => _PaginaCategoriaState();
}

class _PaginaCategoriaState extends State<PaginaCategoria> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBHelper().getCats(), //Obter todas as Categorias
      builder: (context, AsyncSnapshot<List<Categoria>> snapshot) {
        if (snapshot.hasData) {
          List<Categoria> categorias = snapshot.data;
          return Scaffold(
            backgroundColor: Color.fromRGBO(245, 245, 245, 1),
            appBar: AppBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  'titulo2'.tr().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
              ),
              backgroundColor: Theme.of(context).accentColor,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 9,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Container(
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
                            Navigator.of(context)
                                .pushNamed(PaginaMostrarTudo.routeName);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(0, 119, 182, 1),
                            ),
                          ),
                          child: Text(
                            'categoria_botao'.tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 119, 182, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13, bottom: 20),
                        child: Text(
                          'categoria_label'.tr().toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 119, 182, 1),
                          ),
                        ),
                      ),
                    ),
                    //Criar i número de botões consoante o número de Categorias existentes
                    Column(
                      children: [
                        for (var i = 0; i < categorias.length; i++)
                          BotaoCategoria(
                            categorias: categorias,
                            i: i,
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center();
        }
      },
    );
  }
}
