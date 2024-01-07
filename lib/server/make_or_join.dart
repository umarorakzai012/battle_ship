import 'package:battle_ship/server/make_a_server.dart';
import 'package:flutter/material.dart';

class MakeOrJoin extends StatelessWidget {
  const MakeOrJoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BattleShip"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MakeAServer(),
                )),
            child: const Text("Make a Server"),
          ),
          ElevatedButton(
            // onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MakeAServer(),
            //     )),
            onPressed: () => {},
            child: const Text("Join a Server"),
          ),
        ],
      ),
    );
  }
}
