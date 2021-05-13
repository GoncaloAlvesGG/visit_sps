import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:visit_sps/screens/pagina_local.dart';
import '../models/local.dart' as lugar;

class CarosselMenuPrincipal extends StatefulWidget {
  final List<lugar.Local> locais;

  const CarosselMenuPrincipal(
    this.locais,
  );

  @override
  _CarosselMenuPrincipalState createState() => _CarosselMenuPrincipalState();
}

//Carrossel/Swiper de um Local no menu principal gerado de forma aleatória
class _CarosselMenuPrincipalState extends State<CarosselMenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    Random rnd = new Random();
    int min = 1;
    int max = 4;
    int r = min + rnd.nextInt(max - min);
    return Container(
      height: MediaQuery.of(context).size.height * 0.475, //340
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 6, right: 6, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Swiper(
                    autoplay: true,
                    autoplayDelay: 7500,
                    duration: 500,
                    onTap: (_) {
                      Navigator.of(context).pushNamed(PaginaLocal.routeName,
                          arguments: widget.locais[r].id);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        widget.locais[r].imagemUrl + index.toString() + '.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: 3,
                    viewportFraction: 1,
                    scale: 1,
                    pagination: SwiperPagination(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: AutoSizeText(
                widget.locais[r].nome,
                maxLines: 1,
                style: TextStyle(
                    fontFamily: ('Futura PT'),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
