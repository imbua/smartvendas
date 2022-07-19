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
            top: -10,
            left: 20,
            child: Icon(iconeMain,
                size: 80, color: Colors.white.withOpacity(0.2))),
        Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
              width: double.infinity,
            ),
            Text(
              titulo,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
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
            top: -10,
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
