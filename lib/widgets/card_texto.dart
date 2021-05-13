import 'package:flutter/material.dart';

class CardTexto extends StatelessWidget {
  final IconData icon;
  final String texto;
  final Widget base;

  const CardTexto(
    this.icon,
    this.texto,
    this.base,
  );

  @override
  Widget build(BuildContext context) {
    //Card para cada elemento de um local (descrição, hórario, etc)
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    icon,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  texto,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: base,
            )
          ],
        ),
      ),
    );
  }
}
