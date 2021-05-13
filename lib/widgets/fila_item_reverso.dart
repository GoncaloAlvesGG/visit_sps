import 'package:flutter/material.dart';

import '../models/local.dart' as lugar;
import 'item_unico_fila.dart';

class FilaItemReverso extends StatelessWidget {
  final List<lugar.Local> locais;
  final String texto;
  final int nLocais;

  const FilaItemReverso(
    this.locais,
    this.texto,
    this.nLocais,
  );

  //Obter a lista de Locais ao contrario
  @override
  Widget build(BuildContext context) {
    int n = locais.length - 1;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 12),
            child: Text(
              texto,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < nLocais; i++)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 9, top: 10, bottom: 10, right: 8),
                  child: ItemUnicoFila(locais, n--),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
