import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/list_tile_mais.dart';
import 'package:easy_localization/easy_localization.dart';

class PaginaContactosUteis extends StatefulWidget {
  static const routeName = '/contactos';

  @override
  _PaginaContactosUteisState createState() => _PaginaContactosUteisState();
}

class _PaginaContactosUteisState extends State<PaginaContactosUteis> {
  IconData fora = Icons.open_in_new_rounded;
  double tamanhoFora = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            'cont-essencial'.tr().toString(),
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
          //GNR
          ListTileMais(
            Icons.local_police_outlined,
            'gnr',
            () async {
              const uri = 'tel:+351 232 720 060';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Bombeiros de Cima
          ListTileMais(
            Icons.local_fire_department_outlined,
            'bombeiros-cima',
            () async {
              const uri = 'tel:+351 232 720 110';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Bombeiros de Baixo
          ListTileMais(
            Icons.local_fire_department_outlined,
            'bombeiros-baixo',
            () async {
              const uri = 'tel:+351 232 711 115';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Bombeiros S. Cruz
          ListTileMais(
            Icons.local_fire_department_outlined,
            'bombeiros-cruz',
            () async {
              const uri = 'tel:+351 232 798 115';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Bombeiros de Cima
          ListTileMais(
            Icons.public_rounded,
            'prot-civil',
            () async {
              const uri = 'tel:+351 232 723 003';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //Centro de Saúde
          ListTileMais(
            Icons.local_hospital_outlined,
            'saude',
            () async {
              const uri = 'tel:+351 232 720 180';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),

          //INEM
          ListTileMais(
            Icons.medical_services_outlined,
            'inem',
            () async {
              const uri = 'tel:112';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                throw 'Could not launch $uri';
              }
            },
            fora,
            tamanhoFora,
          ),
        ],
      ),
    );
  }
}
