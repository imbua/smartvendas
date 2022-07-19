import 'package:flutter/material.dart';

class AppRodape extends StatelessWidget {
  const AppRodape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white10, Colors.white],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 1),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
            width: 100,
            height: 2,
          ),
          const Text(
            ' ioMetrics ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white10, Colors.white],
                begin: FractionalOffset(1, 1),
                end: FractionalOffset(0, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
            width: 100,
            height: 2,
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
