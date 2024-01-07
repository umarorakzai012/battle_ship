import 'package:battle_ship/functions.dart';
import 'package:battle_ship/server/make_a_server.dart';
import 'package:flutter/material.dart';

class MakeOrJoin extends StatelessWidget {
  const MakeOrJoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: getWidth(context, 2)),
          child: const Text(
            "BattleShip",
          ),
        ),
        backgroundColor: const Color(0xFF223A8E),
        foregroundColor: Colors.white,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: getWidth(context, 7),
                    vertical: getHeight(context, 2),
                  )),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF223A8E),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    const Color(0xFFFFFFFF),
                  ),
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakeAServer(),
                    )),
                child: const Text("Make a Server"),
              ),
              SizedBox(
                height: getHeight(context, 3),
              ),
              ElevatedButton(
                // onPressed: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => MakeAServer(),
                //     )),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: getWidth(context, 7),
                    vertical: getHeight(context, 2),
                  )),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF223A8E),
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    const Color(0xFFFFFFFF),
                  ),
                ),
                onPressed: () => {},
                child: const Text("Join a Server"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
