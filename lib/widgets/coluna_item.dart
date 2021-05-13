import 'package:flutter/material.dart';

import '../models/local.dart' as lugar;
import '../widgets/item_unico_fila.dart';

class ColunaItem extends StatelessWidget {
  final List<lugar.Local> locais;
  final String texto;
  final int nLocais;

  const ColunaItem(
    this.locais,
    this.texto,
    this.nLocais,
  );

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              for (int i = 0; i < nLocais; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
                  child: ItemUnicoFila(locais, i),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
