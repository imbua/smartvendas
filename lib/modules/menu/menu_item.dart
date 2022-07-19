import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
      {Key? key,
      required this.img,
      required this.header,
      required this.botton,
      required this.onPress})
      : super(key: key);

  final String img;
  final String header;
  final String botton;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 15, left: 8),
        child: Container(
          color: Colors.white54,
          width: 145,
          child: InkWell(
            splashColor: Colors.blue,
            onTap: () {
              onPress();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                  height: 30,
                  width: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        header,
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        botton,
                        style: TextStyle(
                          color: Colors.blueGrey[400],
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
