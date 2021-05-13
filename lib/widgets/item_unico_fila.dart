import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/local.dart' as lugar;

class ItemUnicoFila extends StatelessWidget {
  final List<lugar.Local> locais;
  final id;

  const ItemUnicoFila(this.locais, this.id);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        color: Theme.of(context).primaryColor,
      ),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.23,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/local1',
            arguments: locais[id].id,
          );
        },
        splashColor: Color.fromRGBO(31, 107, 147, 1),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  locais[id].imagemUrl + '0.jpg',
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.45,
                  ),
                  child: AutoSizeText(
                    locais[id].nome,
                    style: TextStyle(
                        fontFamily: ('Futura PT'),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 15),
                    maxFontSize: 15,
                    minFontSize: 12,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
