import 'package:flutter/material.dart';

import '../models/local.dart' as lugar;
import '../widgets/item_unico_fila.dart';

class FilaItem extends StatelessWidget {
  final List<lugar.Local> locais;
  final String texto;
  final int nLocais;

  const FilaItem(
    this.locais,
    this.texto,
    this.nLocais,
  );

  //Gerar fila com 4 locais de forma aletória
  @override
  Widget build(BuildContext context) {
    List<int> rnd = [1, 2, 3, 0];
    rnd.shuffle();
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
                  child: nLocais >= 4
                      ? ItemUnicoFila(locais, rnd[i])
                      : ItemUnicoFila(locais, i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
