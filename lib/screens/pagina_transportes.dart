import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PaginaTransportes extends StatefulWidget {
  static const routeName = '/transporte';

  @override
  _PaginaTransportesState createState() => _PaginaTransportesState();
}

class _PaginaTransportesState extends State<PaginaTransportes> {
  //Célula da tabela
  celulaDados(String texto) {
    return DataCell(
      Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  IconData fora = Icons.open_in_new_rounded;
  double tamanhoFora = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            'bus'.tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Futura PT',
                fontSize: 26,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              //Tabela
              dataRowHeight: MediaQuery.of(context).size.height * 0.175,
              headingTextStyle: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              columns: <DataColumn>[
                DataColumn(
                  label: Text('linha'.tr().toString()),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'desc'.tr().toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2060',
                    ),
                    celulaDados(
                      '06:42 Sequeiros - S. Pedro do Sul;\n18:00 S. Pedro do Sul - Sequeiros;\n12:33 Ervilhal - S. Pedro do Sul',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2120',
                    ),
                    celulaDados(
                      '07:15 Manhouce - S. Pedro do Sul;\n18:00 S. Pedro do Sul - Manhouce;\n12:15 Vilarinho - S. Pedro do Sul',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2310',
                    ),
                    celulaDados(
                      '07:30 Rio Mel - S. Pedro do Sul;\n18:00 S. Pedro do Sul - Rio Mel;\n12:15 Rio Me l- S. Pedro do Sul',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2050',
                    ),
                    celulaDados(
                      '07:35 Castro Daire - S. Pedro do Sul;\n18:00 S. Pedro do Sul - Castro Daire;\n11:55 Figueiredo de Alva - S. Pedro do Sul;',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2190',
                    ),
                    celulaDados(
                      '07:05 Prendedores - S. Pedro do Sul;\n17:00 S. Pedro do Sul - Prendedores;',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      '2130',
                    ),
                    celulaDados(
                      '07:30 Covelas - S. Pedro do Sul;\n18:00 S. Pedro do Sul - Covelas;\n12:45 Covelas - S. Pedro do Sul;',
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    celulaDados(
                      ' ',
                    ),
                    celulaDados(
                      '07:34 S. Pedro do Sul - Vouzela - Viseu;\n11:18 Viseu - S. Pedro do Sul;\n12:50 S. Pedro do Sul - Viseu;\n16:20 Viseu - S. Pedro do Sul;\n',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
