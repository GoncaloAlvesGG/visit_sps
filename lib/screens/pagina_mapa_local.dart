import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:visit_sps/helpers/config.helper.dart';
import 'package:visit_sps/helpers/location.helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:easy_localization/easy_localization.dart';

class PaginaMapaLocal extends StatefulWidget {
  static const routeName = '/mapa-local';

  @override
  _PaginaMapaLocalState createState() => _PaginaMapaLocalState();
}

class _PaginaMapaLocalState extends State<PaginaMapaLocal> {
  //Controlador do Mapa
  MapboxMapController mapController;
  MapBoxNavigation _directions;

  initState() {
    _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
  }

  var wayPoints = List<WayPoint>();

  double _distanceRemaining, _durationRemaining;
  bool _arrived;
  String _instruction;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _isMultipleStop = false;
  MapBoxNavigationViewController _controller;

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    if (mounted) {
      setState(() {});
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final Local local = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          //Carregar API do Mapa e outras definições
          FutureBuilder(
            future: loadConfigFile(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.hasData) {
                return Stack(children: [
                  MapboxMap(
                    compassViewPosition: CompassViewPosition.BottomRight,
                    minMaxZoomPreference: MinMaxZoomPreference(8.25, 20),
                    accessToken: snapshot.data['mapbox_api_token'],
                    onMapCreated: (
                      MapboxMapController controller,
                    ) async {
                      final location = await localizacaoAtual();
                      mapController = controller;
                      mapController.addListener(_onMapChanged);
                      setState(
                        () {},
                      );
                      controller.addCircle(
                        CircleOptions(
                          circleColor: '#0077b6',
                          circleRadius: 7.5,
                          geometry: location,
                          circleStrokeColor: "#FFFFFF",
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
                      controller.addCircle(
                        CircleOptions(
                          circleRadius: 8,
                          circleColor: "#FF0000",
                          geometry: LatLng(local.latitude, local.longitude),
                          circleStrokeColor: "#000000",
                          circleStrokeWidth: 2,
                        ),
                      );
                      controller.addSymbol(
                        SymbolOptions(
                          geometry: LatLng(
                            local.latitude,
                            local.longitude,
                          ),
                          textField: local.nome,
                          textSize: 6,
                          textOffset: Offset(0, 2.5),
                        ),
                      );
                      final inicio = WayPoint(
                          name: 'you'.tr().toString(),
                          latitude: location.latitude,
                          longitude: location.longitude);
                      final fim = WayPoint(
                          name: local.nome,
                          latitude: local.latitude,
                          longitude: local.longitude);

                      wayPoints = List<WayPoint>();
                      wayPoints.add(inicio);
                      wayPoints.add(fim);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        local.latitude,
                        local.longitude,
                      ),
                      zoom: 10.3,
                      bearing: 270,
                    ),
                    styleString: snapshot.data['mapbox_style_url'],
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.175,
                    right: MediaQuery.of(context).size.width * 0.04,
                    child: Container(
                      height: 48,
                      width: 48,
                      child: FloatingActionButton(
                          child: Icon(Icons.near_me_outlined),
                          onPressed: () async {
                            _directions.startNavigation(
                              wayPoints: wayPoints,
                              options: MapBoxOptions(
                                initialLatitude: 40.82056203869097,
                                initialLongitude: -8.100609935278421,
                                zoom: 10.3,
                                tilt: 30,
                                bearing: 0,
                                enableRefresh: false,
                                alternatives: false,
                                voiceInstructionsEnabled: true,
                                bannerInstructionsEnabled: true,
                                allowsUTurnAtWayPoints: false,
                                mode: MapBoxNavigationMode.drivingWithTraffic,
                                units: VoiceUnits.metric,
                                simulateRoute: false,
                                language: "pt-PT",
                              ),
                            );
                          }),
                    ),
                  )
                ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
                  color: Colors.white,
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
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.09,
            right: MediaQuery.of(context).size.width * 0.03,
            child: Container(
              child: Text(
                local.nome,
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
      ),
    );
  }
}
