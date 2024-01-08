import 'package:battle_ship/global.dart';
import 'package:battle_ship/server/make_or_join.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  final controller = TextEditingController();
  final fKey = GlobalKey<FormState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String username = ref.watch(userNameStateProvider);
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
      body: SingleChildScrollView(
        child: Column(
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
              child: Form(
                key: fKey,
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Username",
                    labelText: "Username",
                  ),
                  onFieldSubmitted: (value) {
                    if (fKey.currentState!.validate() && value.isNotEmpty) {
                      controller.clear();
                      ref.read(userNameStateProvider.notifier).state = value;
                    }
                  },
                  validator: (value) {
                    if ((value == null || value.isEmpty) && username.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
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
              onPressed: () {
                String value = controller.text;
                if (fKey.currentState!.validate() && value.isNotEmpty) {
                  controller.clear();
                  ref.read(userNameStateProvider.notifier).state = value;
                }
              },
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
              onPressed: () {
                if (fKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MakeOrJoin(),
                    ),
                  );
                }
              },
              child: const Text(
                "Enter",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
