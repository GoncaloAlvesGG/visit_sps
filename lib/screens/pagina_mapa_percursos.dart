import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:visit_sps/helpers/config.helper.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/helpers/location.helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/models/percurso.dart';

class MapaPercursos extends StatefulWidget {
  static const routeName = '/percursos';
  @override
  _MapaPercursosState createState() => _MapaPercursosState();
}

class _MapaPercursosState extends State<MapaPercursos> {
  @override
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Controlador do Mapa
  MapboxMapController mapController;
  List<String> ponto = [];
  List<String> coordenadas = [];

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments; //Obter o id do percurso
    return Scaffold(
      body: FutureBuilder(
        future: DBHelper().getPercurso(),
        builder: (context, AsyncSnapshot<List<Percurso>> snapshot) {
          if (snapshot.hasData) {
            List<Percurso> percurso = snapshot.data;
            return FutureBuilder(
              future: loadConfigFile(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  ponto = percurso[id].pontos.split(' ');

                  for (var i = 0; i < ponto.length; i++) {
                    coordenadas += ponto[i].split(',');
                  }
                  return Stack(
                    children: [
                      MapboxMap(
                        compassViewPosition: CompassViewPosition.BottomRight,
                        minMaxZoomPreference: MinMaxZoomPreference(0, 20),
                        accessToken: snapshot.data['mapbox_api_token'],
                        onMapCreated: (
                          MapboxMapController controller,
                        ) async {
                          final location = await localizacaoAtual();
                          mapController = controller;
                          if (mounted) {
                            setState(() {});
                          }
                          controller.addCircle(
                            CircleOptions(
                              circleRadius: 10,
                              circleColor: "#0077b6",
                              geometry: location,
                              circleStrokeColor: "#000000",
                              circleStrokeWidth: 2,
                            ),
                          );
                          controller.addSymbol(
                            SymbolOptions(
                              geometry: location,
                              textField: 'you'.tr().toString(),
                              textSize: 6,
                              textOffset: Offset(0, 2.5),
                            ),
                          );
                          List<LatLng> listaPontos = [];
                          for (var j = 0; j < coordenadas.length; j++) {
                            listaPontos.add(
                              LatLng(
                                double.parse(coordenadas[j + 1]),
                                double.parse(coordenadas[j]),
                              ),
                            );
                            controller.addLine(
                              LineOptions(
                                geometry: listaPontos,
                                lineWidth: 5,
                                lineColor: '#FF0000',
                              ),
                            );
                            j = j + 2;
                          }

                          controller.addCircle(
                            CircleOptions(
                              circleRadius: 6,
                              circleColor: '#FF0000',
                              geometry: LatLng(
                                double.parse(coordenadas[1]),
                                double.parse(coordenadas[0]),
                              ),
                              circleStrokeColor: "#000000",
                              circleStrokeWidth: 2,
                            ),
                          );

                          controller.addSymbol(
                            SymbolOptions(
                              geometry: LatLng(
                                double.parse(coordenadas[1]),
                                double.parse(coordenadas[0]),
                              ),
                              textField: 'start'.tr().toString(),
                              textSize: 6,
                              textOffset: Offset(0, 2.5),
                            ),
                          );
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(coordenadas[1]),
                            double.parse(coordenadas[0]),
                          ),
                          zoom: 12,
                          bearing: 270,
                        ),
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        styleString: snapshot.data['mapbox_style_url'],
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.06,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            size: 36,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.125,
                        right: MediaQuery.of(context).size.width * 0.03,
                        child: Container(
                          child: Text(
                            'posicao'.tr().toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              backgroundColor: Color.fromRGBO(
                                0,
                                119,
                                182,
                                1,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                              bottom: BorderSide(width: 3),
                              top: BorderSide(width: 2),
                              left: BorderSide(width: 2),
                              right: BorderSide(width: 2),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.09,
                        right: MediaQuery.of(context).size.width * 0.03,
                        child: Container(
                          child: Text(
                            percurso[id].nome,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              backgroundColor: Colors.red,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                              bottom: BorderSide(width: 3),
                              top: BorderSide(width: 2),
                              left: BorderSide(width: 2),
                              right: BorderSide(width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
