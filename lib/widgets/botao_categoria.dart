import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/categoria.dart';

class BotaoCategoria extends StatelessWidget {
  final List<Categoria> categorias;
  final int i;

  const BotaoCategoria({
    @required this.categorias,
    @required this.i,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
              Navigator.of(context)
                  .pushNamed('/mostrar-categoria1', arguments: [categorias[i]]);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    //Icon da Categoria
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.005,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          IconData(
                            categorias[i].icon,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: Color.fromRGBO(0, 119, 182, 1),
                          size: 35,
                        ),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.16,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        //Nome da categoria consoante o idioma
                        child: context.locale == Locale('pt', '')
                            ? Text(
                                categorias[i].nome,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 119, 182, 1),
                                ),
                              )
                            : Text(
                                categorias[i].nomeEng,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 119, 182, 1),
                                ),
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Color.fromRGBO(0, 119, 182, 1),
                        size: 45,
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
