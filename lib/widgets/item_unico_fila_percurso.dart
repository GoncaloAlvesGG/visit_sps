import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/percurso.dart';

class ItemUnicoFilaPercurso extends StatelessWidget {
  final List<Percurso> percursos;
  final id;

  const ItemUnicoFilaPercurso(this.percursos, this.id);

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
            '/percursos1',
            arguments: id,
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
                child: FutureBuilder(
                  future: DBHelper().getPercurso(), //Obter Pontos
                  builder: (context, AsyncSnapshot<List<Percurso>> snapshot) {
                    if (snapshot.hasData) {
                      List<Percurso> percursos = snapshot.data;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          percursos[id].imagem + '.jpg',
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.45,
                  ),
                  child: AutoSizeText(
                    percursos[id].nome,
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
