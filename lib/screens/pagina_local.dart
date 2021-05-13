import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visit_sps/helpers/config.helper.dart';
import 'package:visit_sps/helpers/db_helper.dart';
import 'package:visit_sps/models/local.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:visit_sps/screens/pagina_mapa_local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/helpers/location.helper.dart';

import '../widgets/swiper_local.dart';
import '../models/categoria.dart';
import '../widgets/card_texto.dart';
import '../widgets/fila_local_categoria.dart';

class PaginaLocal extends StatefulWidget {
  static const routeName = '/pagina-local';
  @override
  _PaginaLocalState createState() => _PaginaLocalState();
}

enum TtsState { playing, stopped, paused, continued }

class _PaginaLocalState extends State<PaginaLocal> {
  //Controlador do Mapa
  MapboxMapController mapController;
  //Inicializar o pacote de Texto para Voz
  FlutterTts flutterTts = FlutterTts();
  bool falar = false;
  TtsState ttsState = TtsState.stopped;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  //Snackbar a mostrar quando um Local é adicionado ou removido dos bookmarks
  snackBarSPS(String texto, BuildContext context) {
    return SnackBar(
      backgroundColor: Color.fromRGBO(0, 119, 182, 1),
      content: Text(
        texto.tr().toString(),
        style: TextStyle(
          fontFamily: 'Futura PT',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //Escolher o idioma e começar a ler

  Future _speak(String desc) async {
    context.locale == Locale('pt', '')
        ? await flutterTts.setLanguage("pt-PT")
        : await flutterTts.setLanguage("en-US");
    var result = await flutterTts.speak(desc);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  //Para de ler

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments; //Obter o id do Local
    return FutureBuilder(
      future: DBHelper().getLocal(id), //Obter dados do Local
      builder: (context, AsyncSnapshot<Local> snapshot) {
        if (snapshot.hasData) {
          Local local = snapshot.data;
          String horario = local.horario;
          String horarioEng = local.horarioEng;
          List dividir;
          List dividirEng;

          //Dividir o horário caso exista
          if (horario == null) {
          } else {
            if (horario.contains('/')) {
              dividir = horario.split('/');
            } else {}
          }
          if (horarioEng == null) {
          } else {
            if (horarioEng.contains('/')) {
              dividirEng = horarioEng.split('/');
            } else {}
          }

          return Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      //Carrosel de Imagens do Local
                      CarrosselLocal(local.imagemUrl),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.07,
                        right: MediaQuery.of(context).size.width * 0.04,
                        child: Container(
                          width: 48,
                          height: 48,
                          child: FloatingActionButton(
                            heroTag: "btn1",
                            child: Icon(
                              local.isBook == 0
                                  ? Icons.bookmark_outline_rounded
                                  : Icons.bookmark_rounded,
                              size: 36,
                            ),
                            //Marcar Local
                            onPressed: () {
                              setState(() {
                                if (local.isBook == 0) {
                                  local.isBook = 1;
                                  _scaffoldKey.currentState.showSnackBar(
                                    snackBarSPS('adicionado', context),
                                  );
                                  DBHelper().alterarBook(
                                    local.isBook,
                                    local.id,
                                  );
                                } else {
                                  local.isBook = 0;
                                  _scaffoldKey.currentState.showSnackBar(
                                    snackBarSPS('removido', context),
                                  );
                                  DBHelper().alterarBook(
                                    local.isBook,
                                    local.id,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      //Voltar
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.06,
                        left: MediaQuery.of(context).size.width * 0.02,
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_back,
                            size: 35,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _stop();
                          },
                        ),
                      ),
                      //Iniciar/Parar leitura do texto
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.17,
                        right: MediaQuery.of(context).size.width * 0.04,
                        child: Container(
                          width: 48,
                          height: 48,
                          child: FloatingActionButton(
                              heroTag: "btn2",
                              child: Icon(
                                Icons.volume_up,
                              ),
                              onPressed: () {
                                if (context.locale == Locale('pt', '')) {
                                  if (falar == false) {
                                    _speak('Nome: ' +
                                        local.nome +
                                        '. Descriação: ' +
                                        local.desc);
                                    falar = true;
                                  } else {
                                    _stop();
                                    falar = false;
                                  }
                                } else {
                                  if (falar == false) {
                                    _speak('Name: ' +
                                        local.nome +
                                        '. Description:' +
                                        local.descEng);
                                    falar = true;
                                  } else {
                                    _stop();
                                    falar = false;
                                  }
                                }
                              }),
                        ),
                      ),
                      //Botão para o site Trivago caso exista
                      local.trivago != null && local.trivago != ""
                          ? Positioned(
                              top: MediaQuery.of(context).size.height * 0.27,
                              right: MediaQuery.of(context).size.width * 0.04,
                              child: Container(
                                width: 48,
                                height: 48,
                                child: FloatingActionButton(
                                  heroTag: "btn3",
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Icon(
                                          IconData(
                                            0xe800,
                                            fontFamily: 'CustomIcons',
                                          ),
                                          size: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    String url = local.trivago;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  //Nome e Morada do Local
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                      color: Theme.of(context).primaryColor,
                    ),
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 7,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            local.nome,
                            style: TextStyle(
                              fontFamily: ('Futura PT'),
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              local.morada,
                              style: TextStyle(
                                fontFamily: ('Futura PT'),
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Descrição e verificação do idioma do dispositivo
                  context.locale == Locale('pt', '')
                      ? CardTexto(
                          Icons.description,
                          'local_desc'.tr().toString(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                local.desc,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                        )
                      : CardTexto(
                          Icons.description,
                          'local_desc'.tr().toString(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                local.descEng,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                        ),
                  //Horário e divisão do mesmo caso seja necessário
                  (dividirEng != null || dividir != null)
                      ? context.locale == Locale('pt', '')
                          ? CardTexto(
                              Icons.access_time,
                              'local_hor'.tr().toString(),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: local.horario.contains('/')
                                      ? (Text(
                                          dividir[0] + '\n' + dividir[1],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ))
                                      : (Text(
                                          local.horario,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        )),
                                ),
                              ),
                            )
                          : CardTexto(
                              Icons.access_time,
                              'local_hor'.tr().toString(),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: local.horarioEng.contains('/')
                                      ? (Text(
                                          dividirEng[0] + '\n' + dividirEng[1],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ))
                                      : (Text(
                                          local.horarioEng,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        )),
                                ),
                              ),
                            )
                      : Container(),
                  //Contacto
                  local.contacto != null && local.contacto != ""
                      ? context.locale == Locale('pt', '')
                          ? CardTexto(
                              Icons.phone_outlined,
                              'contacto'.tr().toString(),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    'Número de Telefone: ' + local.contacto,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                            )
                          : CardTexto(
                              Icons.phone_outlined,
                              'contacto'.tr().toString(),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    'Phone Number: ' + local.contacto,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ),
                            )
                      : Container(),
                  //Mapa estático com o Local e Posição atual do utilizador
                  CardTexto(
                    Icons.map,
                    'local_mapa'.tr().toString(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            PaginaMapaLocal.routeName,
                            arguments: local);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: Stack(
                              children: [
                                FutureBuilder(
                                  future: loadConfigFile(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Map<String, dynamic>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      return MapboxMap(
                                        compassViewPosition:
                                            CompassViewPosition.BottomRight,
                                        minMaxZoomPreference:
                                            MinMaxZoomPreference(10, 20),
                                        accessToken:
                                            snapshot.data['mapbox_api_token'],
                                        onMapCreated: (
                                          MapboxMapController controller,
                                        ) async {
                                          final location =
                                              await localizacaoAtual();
                                          mapController = controller;
                                          if (mounted) {
                                            setState(() {});
                                          }
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
                                              geometry: LatLng(local.latitude,
                                                  local.longitude),
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
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            local.latitude,
                                            local.longitude,
                                          ),
                                          zoom: 10.3,
                                          bearing: 270,
                                        ),
                                        scrollGesturesEnabled: false,
                                        rotateGesturesEnabled: false,
                                        tiltGesturesEnabled: false,
                                        zoomGesturesEnabled: false,
                                        compassEnabled: false,
                                        styleString:
                                            snapshot.data['mapbox_style_url'],
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                //Expandir o mapa
                                Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.04,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.fullscreen_rounded,
                                      size: 36,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          PaginaMapaLocal.routeName,
                                          arguments: local);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Obter categorias associadas a um Local e possibilidade de ver locais associadas a estas
                  FutureBuilder(
                      future: DBHelper().getLocalCat(local.id),
                      builder:
                          (context, AsyncSnapshot<List<Categoria>> snapshot) {
                        if (snapshot.hasData) {
                          List<Categoria> categorias = snapshot.data;
                          return categorias.length != 0
                              ? CardTexto(
                                  Icons.category,
                                  'local_cat'.tr().toString(),
                                  LocalCategoria(categorias),
                                )
                              : Container();
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
