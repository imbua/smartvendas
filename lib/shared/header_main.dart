import 'package:flutter/material.dart';

import 'header_background.dart';

class HeaderMain extends StatelessWidget {
  final IconData iconeMain;
  final String titulo;
  final double altura;

  const HeaderMain({
    Key? key,
    required this.iconeMain,
    required this.titulo,
    required this.altura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HeaderBackground(heightHeader: altura),
        Positioned(
            top: altura > 200 ? 80 : 20,
            left: 20,
            child: Icon(iconeMain,
                size: 80, color: Colors.white.withOpacity(0.2))),
        Positioned(
          top: altura > 200 ? 100 : 20,
          left: 150,
          child: Text(
            titulo,
            style: TextStyle(
                fontSize: altura > 200 ? 28 : 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class HeaderInput extends StatelessWidget {
  final IconData iconeMain;
  final String titulo;

  final double altura;

  const HeaderInput({
    Key? key,
    required this.iconeMain,
    required this.titulo,
    required this.altura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HeaderInputBackground(heightHeader: altura),
        Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width - 80,
            child: Icon(iconeMain,
                size: 80, color: Colors.white.withOpacity(0.2))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              height: 5,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                titulo,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
