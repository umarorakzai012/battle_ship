import 'package:battle_ship/functions.dart';
import 'package:battle_ship/server/make_or_join.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = TextEditingController();
  String username = "";

  void onSubmit(String? text) {
    text ??= controller.text.trim();
    controller.clear();
    username = text;
    setState(() {});
  }

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
            height: getHeight(context, 20),
          ),
          Text(
            username,
            style: const TextStyle(fontSize: 25),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: getHeight(context, 3),
              horizontal: getWidth(context, 6),
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Username",
                labelText: "Username",
              ),
              onSubmitted: onSubmit,
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
            onPressed: () => onSubmit(null),
            child: const Text(
              "Submit",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: getHeight(context, 3),
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
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MakeOrJoin(),
                )),
            child: const Text(
              "Enter",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
