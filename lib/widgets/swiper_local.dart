import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class CarrosselLocal extends StatefulWidget {
  final String imagemUrl;

  const CarrosselLocal(
    this.imagemUrl,
  );

  @override
  _CarrosselLocalState createState() => _CarrosselLocalState();
}

//Carrossel/Swiper de um Local
class _CarrosselLocalState extends State<CarrosselLocal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.45, //340
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  )
                ],
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Swiper(
                  onTap: (_) {},
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      widget.imagemUrl + index.toString() + '.jpg',
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
          ],
        ),
      ],
    );
  }
}
