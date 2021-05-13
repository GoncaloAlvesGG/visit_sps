import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PaginaAcerca extends StatelessWidget {
  static const routeName = '/acerca';
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
            'acerca'.tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Futura PT',
                fontSize: 30,
                fontWeight: FontWeight.w900),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                'projeto'.tr().toString(),
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
              Text(
                'autor'.tr().toString(),
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      './assets/images/acerca/pt.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Image.asset(
                      './assets/images/acerca/aesps.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                    )
                  ],
                ),
              ),
              Image.asset('./assets/images/acerca/poch.png'),
            ],
          ),
        ),
      ),
    );
  }
}
