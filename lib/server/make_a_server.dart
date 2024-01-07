import 'package:battle_ship/functions.dart';
import 'package:flutter/material.dart';

class MakeAServer extends StatelessWidget {
  MakeAServer({super.key});
  final serverController = TextEditingController();
  final passwordController = TextEditingController();
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
      body: Column(
        children: [
          SizedBox(
            height: getHeight(context, 25),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: getHeight(context, 3),
              horizontal: getWidth(context, 6),
            ),
            child: TextField(
              controller: serverController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Server Name",
                labelText: "Server Name",
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: getHeight(context, 3),
              horizontal: getWidth(context, 6),
            ),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Password",
                labelText: "Password",
                helperText: "*leave empty for no password",
              ),
            ),
          ),
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
            onPressed: () => {},
            child: const Text("Start the Server"),
          ),
        ],
      ),
    );
  }
}
