import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:visit_sps/helpers/config.helper.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/helpers/location.helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/screens/pagina_local.dart';

class PaginaMapa extends StatefulWidget {
  static const routeName = '/mapa';
  @override
  _PaginaMapaState createState() => _PaginaMapaState();
}

class _PaginaMapaState extends State<PaginaMapa> {
  //Lista de todos locais
  List<Local> listaLocais;

  //Local selecionado
  Circle selectedCircle;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Gerar cor aleatória para cada local
  Random random = new Random();
  String generateRandomHexColor() {
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = '#';
    while (length-- > 0) hex += chars[(random.nextInt(16)) | 0];
    return hex;
  }

  //Controlador do Mapa
  MapboxMapController mapController;

  //Posição da "Camera" no mapa
  CameraPosition _position;

  //Estas se a mover ?
  bool _isMoving = false;

  //Obter posicao e movimento do utilizador
  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  //Caso um circulo seja tocado
  void onCircleTapped(Circle circle) {
    setState(() {
      selectedCircle = circle;
    });
    updateSelectedCircle();
  }

  //Abrir pagina do respetivo Local
  void updateSelectedCircle() {
    CircleOptions changes = CircleOptions();
    mapController.updateCircle(
      selectedCircle,
      changes,
    );
    Navigator.of(context).pushNamed(
      PaginaLocal.routeName,
      arguments: listaLocais[int.parse(selectedCircle.id) - 1].id,
    );
  }

  //Eliminar Pagina do Local aberto
  void dispose() {
    mapController?.onCircleTapped?.remove(onCircleTapped);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DBHelper().getLocais(), //Obter Locais
        builder: (context, AsyncSnapshot<List<Local>> snapshot) {
          if (snapshot.hasData) {
            List<Local> locais = snapshot.data;
            listaLocais = locais;
            return FutureBuilder(
              future: loadConfigFile(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      MapboxMap(
                        compassViewPosition: CompassViewPosition.BottomRight,
                        minMaxZoomPreference: MinMaxZoomPreference(8.25, 20),
                        accessToken: snapshot.data['mapbox_api_token'],
                        onMapCreated: (
                          MapboxMapController controller,
                        ) async {
                          final location = await localizacaoAtual();
                          mapController = controller;
                          controller.onCircleTapped.add(onCircleTapped);
                          mapController.addListener(_onMapChanged);
                          _extractMapInfo();
                          setState(
                            () {},
                          );
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
                          //Gerar Circulos consoante o número de locais
                          for (var i = 0; i < locais.length; i++) {
                            controller.addSymbol(
                              SymbolOptions(
                                geometry: LatLng(
                                  locais[i].latitude,
                                  locais[i].longitude,
                                ),
                                textField: locais[i].nome,
                                textSize: 6,
                                textOffset: Offset(0, 2.5),
                              ),
                            );
                            controller.addCircle(
                              CircleOptions(
                                circleRadius: 9,
                                circleColor: generateRandomHexColor(),
                                geometry: LatLng(
                                  locais[i].latitude,
                                  locais[i].longitude,
                                ),
                              ),
                            );
                          }
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            40.82056203869097,
                            -8.100609935278421,
                          ),
                          zoom: 10,
                          bearing: 270,
                        ),
                        styleString: snapshot.data['mapbox_style_url'],
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.1,
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
