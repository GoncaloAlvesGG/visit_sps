import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ListTileMais extends StatefulWidget {
  final IconData icon;
  final String texto;
  final Function funcao;
  final IconData dentroFora;
  final double tamanho;

  ListTileMais(
    this.icon,
    this.texto,
    this.funcao,
    this.dentroFora,
    this.tamanho,
  );

  @override
  _ListTileMaisState createState() => _ListTileMaisState();
}

//Cada Item da lista da pagina Mais
class _ListTileMaisState extends State<ListTileMais> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
          title: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 300,
              maxWidth: 300,
              minHeight: 30,
              maxHeight: 50,
            ),
            child: AutoSizeText(
              widget.texto.tr().toString(),
              style: TextStyle(fontSize: 20),
            ),
          ),
          trailing: Icon(
            widget.dentroFora,
            color: Theme.of(context).accentColor,
            size: widget.tamanho,
          ),
          onTap: widget.funcao,
        ),
      ),
    );
  }
}
