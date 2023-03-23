import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BotaoBackGround extends StatelessWidget {
  final IconData iconeBotaoBackGround;

  const BotaoBackGround({
    Key? key,
    required this.iconeBotaoBackGround,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
        gradient: const LinearGradient(colors: <Color>[
          Color.fromARGB(255, 32, 132, 214),
          Color.fromARGB(255, 138, 169, 194),
        ]),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -20,
              top: -20,
              child: FaIcon(
                iconeBotaoBackGround,
                size: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BotaoInfo extends StatelessWidget {
  final String caption;
  final IconData iconeBotaoBackGround;
  final Function onPress;
  const BotaoInfo({
    Key? key,
    required this.caption,
    required this.iconeBotaoBackGround,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Stack(
        children: <Widget>[
          BotaoBackGround(iconeBotaoBackGround: iconeBotaoBackGround),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 110,
                width: 40,
              ),
              FaIcon(
                iconeBotaoBackGround,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  caption,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
