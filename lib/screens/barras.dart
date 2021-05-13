import 'package:flutter/material.dart';
import 'package:visit_sps/screens/pagina_categorias.dart';
import 'package:visit_sps/screens/pagina_guardados.dart';
import 'package:visit_sps/screens/pagina_mais.dart';
import 'package:visit_sps/screens/pagina_mapa.dart';
import 'package:easy_localization/easy_localization.dart';

import '../screens/pagina_principal.dart';

class Barras extends StatefulWidget {
  static const routeName = '/barra';
  @override
  _BarrasState createState() => _BarrasState();
}

//Barra de Navegação

class _BarrasState extends State<Barras> {
  List<Map<String, Object>> _paginas;
  int _indexPaginaSelect = 0;

  @override
  void initState() {
    _paginas = [
      {
        'pagina': PaginaPrincipal(),
      },
      {
        'pagina': PaginaCategoria(),
      },
      {
        'pagina': PaginaMapa(),
      },
      {
        'pagina': PaginaGuardados(),
      },
      {
        'pagina': PaginaMais(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _indexPaginaSelect = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: _paginas[_indexPaginaSelect]['pagina'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        unselectedItemColor: Theme.of(context).buttonColor,
        selectedFontSize: 13,
        selectedIconTheme: IconThemeData(size: 28),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Futura PT',
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Futura PT',
          fontWeight: FontWeight.w500,
        ),
        selectedItemColor: Theme.of(context).buttonColor,
        currentIndex: _indexPaginaSelect,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            label: 'barra1'.tr().toString(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'barra2'.tr().toString(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.map),
            label: 'barra3'.tr().toString(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.bookmark),
            label: 'barra4'.tr().toString(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.more_vert),
            label: 'barra5'.tr().toString(),
          ),
        ],
      ),
    );
  }
}
