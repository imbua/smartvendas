import 'package:flutter/material.dart';
import 'package:smartvendas/shared/variaveis.dart';

class HeaderBackground extends StatelessWidget {
  final double heightHeader;
  const HeaderBackground({
    Key? key,
    this.heightHeader = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightHeader,
      decoration: const BoxDecoration(
          // color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(95),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(255, 32, 132, 214),
                corRodape,
              ])),
    );
  }
}

class HeaderInputBackground extends StatelessWidget {
  final double heightHeader;
  const HeaderInputBackground({
    Key? key,
    this.heightHeader = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightHeader,
      decoration: const BoxDecoration(
          // color: Colors.blueAccent,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(95),
          ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(255, 32, 132, 214),
                Color.fromARGB(255, 138, 169, 194),
              ])),
    );
  }
}
