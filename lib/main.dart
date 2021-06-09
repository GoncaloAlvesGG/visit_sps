//Copyright © Gonçalo Alves - 2021 Todos os direitos reservados.
//sk.eyJ1IjoiZGFua2xvcmQ2OSIsImEiOiJja29raGhuOTMwNDhvMm5wZmJhMm5xcm1jIn0.6tHmv8bkL9lUVw2yalv1-w
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:visit_sps/screens/pagina_acerca.dart';
import 'package:visit_sps/screens/pagina_contactos_uteis.dart';
import 'package:visit_sps/screens/pagina_guardados.dart';
import 'package:visit_sps/screens/pagina_mais.dart';
import 'package:visit_sps/screens/pagina_mapa_percursos.dart';
import 'package:visit_sps/screens/pagina_mostrar_categoria.dart';
import 'package:visit_sps/screens/pagina_mostrar_percursos.dart';
import 'package:visit_sps/screens/pagina_transportes.dart';

import './screens/pagina_categorias.dart';
import './screens/pagina_local.dart';
import './screens/pagina_mapa.dart';
import './screens/pagina_mapa_local.dart';
import './screens/pagina_mostrar_tudo.dart';
import './screens/pagina_principal.dart';
import './screens/barras.dart';

//Linguagens Suportadas
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Phoenix(
      child: EasyLocalization(
        supportedLocales: [
          Locale('pt', ''),
          Locale('en', ''),
        ],
        path: 'assets/strings',
        child: MyApp(),
      ),
    ),
  );
}

//Splash Screen
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: AnimatedSplashScreen(
        backgroundColor: Color.fromRGBO(39, 133, 183, 1),
        splash: Container(
          child: Image.asset(
            'assets/images/logo_texto.png',
          ),
        ),
        nextScreen: AfterSplash(),
        splashIconSize: 150,
        splashTransition: SplashTransition.fadeTransition,
        duration: 2500,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Tema, rotas e transições
class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Visit São Pedro do Sul',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(39, 133, 183, 1),
        accentColor: Color.fromRGBO(0, 119, 182, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.black,
              ),
              bodyText2: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.black,
              ),
              headline6: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w900,
                fontSize: 31,
                color: Colors.white,
              ),
              subtitle1: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color.fromRGBO(0, 119, 182, 1),
              ),
              button: TextStyle(
                fontFamily: 'Futura PT',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        scaffoldBackgroundColor: Color.fromRGBO(245, 245, 245, 1),
        bottomAppBarColor: Color.fromRGBO(0, 119, 182, 1),
      ),
      home: Barras(),
      routes: {
        Barras.routeName: (context) => Barras(),
        PaginaPrincipal.routeName: (context) => PaginaPrincipal(),
        PaginaCategoria.routeName: (context) => PaginaCategoria(),
        PaginaMostrarTudo.routeName: (context) => PaginaMostrarTudo(),
        PaginaLocal.routeName: (context) => PaginaLocal(),
        PaginaMapaLocal.routeName: (context) => PaginaMapaLocal(),
        PaginaMapa.routeName: (context) => PaginaMapa(),
        PaginaGuardados.routeName: (context) => PaginaGuardados(),
        PaginaMais.routeName: (context) => PaginaMais(),
        PaginaContactosUteis.routeName: (context) => PaginaContactosUteis(),
        PaginaAcerca.routeName: (context) => PaginaAcerca(),
        PaginaMostrarCategoria.routeName: (context) => PaginaMostrarCategoria(),
        PaginaTransportes.routeName: (context) => PaginaTransportes(),
        MapaPercursos.routeName: (context) => MapaPercursos(),
        PaginaMostrarPercursos.routeName: (context) => PaginaMostrarPercursos(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/mostrar-categoria1':
            return PageTransition(
                child: PaginaMostrarCategoria(),
                type: PageTransitionType.bottomToTop,
                settings: settings);
            break;
          case '/local1':
            return PageTransition(
                child: PaginaLocal(),
                type: PageTransitionType.bottomToTop,
                settings: settings);
            break;
          case '/contactos1':
            return PageTransition(
                child: PaginaContactosUteis(),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          case '/acerca1':
            return PageTransition(
                child: PaginaAcerca(),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          case '/transporte1':
            return PageTransition(
                child: PaginaTransportes(),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          case '/percursos1':
            return PageTransition(
                child: MapaPercursos(),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          case '/mostrar-percursos1':
            return PageTransition(
                child: PaginaMostrarPercursos(),
                type: PageTransitionType.rightToLeft,
                settings: settings);
            break;
          default:
            return null;
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
