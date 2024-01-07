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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BattleShip"),
      ),
      body: Column(
        children: [
          Text(username),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter Username",
              labelText: "Username",
              errorText: "Username is required!",
            ),
            onSubmitted: onSubmit,
          ),
          ElevatedButton(
            onPressed: () => onSubmit(null),
            child: const Text("Submit"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MakeOrJoin(),
                )),
            child: const Text("Enter"),
          ),
        ],
      ),
    );
  }
}
