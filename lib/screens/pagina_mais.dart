import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/list_tile_mais.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/helpers/db_helper.dart';

class PaginaMais extends StatefulWidget {
  static const routeName = '/mais';
  @override
  _PaginaMaisState createState() => _PaginaMaisState();
}

class _PaginaMaisState extends State<PaginaMais> {
  //Idiomas
  final List<String> linguas = ['Português', 'English'];

  //Valor selecionado na seleção de idiomas
  int selectedRadio = 0;

  //Icon mostrar pagina dentro da app
  IconData dentro = Icons.keyboard_arrow_right_rounded;

  //Icon mostrar pagina fora da app
  IconData fora = Icons.open_in_new_rounded;

  double tamanhoFora = 24;
  double tamanhoDentro = 28;

  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (context.locale == Locale('en', '')) {
          selectedRadio = 1;
        } else {
          selectedRadio = 0;
        }
      });
    });

    super.initState();
  }

  DBHelper dbHelper = new DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            'titulo4'.tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Futura PT',
                fontSize: 30,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: ListView(
        children: [
          //Alterar idioma e verificar qual deles está selecionado atualmente e reiniciar a aplicação
          ListTileMais(
            Icons.language_rounded,
            'mudar_lang',
            () {
              showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(2, (int index) {
                              return Row(
                                children: [
                                  Text(
                                    linguas[index],
                                  ),
                                  Radio<int>(
                                    value: index,
                                    groupValue: selectedRadio,
                                    onChanged: (int value) {
                                      print(value);
                                      if (value == 1) {
                                        context.locale = Locale('en', '');
                                        Phoenix.rebirth(context);
                                      } else {
                                        context.locale = Locale('pt', '');
                                        Phoenix.rebirth(context);
                                      }
                                    },
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    );
                  });
            },
            dentro,
            tamanhoDentro,
          ),
          //Mostrar trilhos
          ListTileMais(Icons.directions_walk_rounded, 'percursos', () {
            Navigator.of(context).pushNamed('/mostrar-percursos1');
          }, dentro, tamanhoDentro),
          //Mostrar Contactos
          ListTileMais(
            Icons.call_outlined,
            'cont-essencial',
            () {
              Navigator.of(context).pushNamed(
                '/contactos1',
              );
            },
            dentro,
            tamanhoDentro,
          ),

          //Mostrar Horários
          ListTileMais(
            Icons.directions_bus_outlined,
            'bus',
            () {
              Navigator.of(context).pushNamed(
                '/transporte1',
              );
            },
            dentro,
            tamanhoDentro,
          ),

          //Mostrar Meterologia
          ListTileMais(
            Icons.thermostat_rounded,
            'tempo',
            () async {
              const url =
                  'https://www.ipma.pt/pt/otempo/prev.localidade.hora/#Viseu&S%C3%A3o%20Pedro%20do%20Sul';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Mostrar Instagram
          ListTileMais(
            IconData(0xf31e, fontFamily: 'CustomIcons'),
            'instagram',
            () async {
              const url = 'https://www.instagram.com/cmspsul/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Mostrar Facebook
          ListTileMais(
            IconData(0xf300, fontFamily: 'CustomIcons'),
            'facebook',
            () async {
              const url = 'https://www.facebook.com/cmspsul';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Enviar Email
          ListTileMais(
            Icons.email_outlined,
            'contactar',
            () async {
              const uri =
                  'mailto:goncalo.alves13431@aesps.pt?subject=Visit SPS - &body=';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Mostrar página acerca
          ListTileMais(
            Icons.info_outline_rounded,
            'acerca',
            () {
              Navigator.of(context).pushNamed(
                '/acerca1',
              );
            },
            dentro,
            tamanhoDentro,
          ),

          //Reset à aplicação (Dev)
          ListTileMais(
            Icons.restore_rounded,
            'reset',
            () {
              //DBHelper().reset(); <-Forma Final
              DBHelper().deleteDB();
              Future.delayed(
                const Duration(milliseconds: 2000),
                () {
                  Phoenix.rebirth(context);
                  context.deleteSaveLocale();
                },
              );
            },
            dentro,
            tamanhoDentro,
          ),
        ],
      ),
    );
  }
}
