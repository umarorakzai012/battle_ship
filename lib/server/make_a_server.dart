import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MakeAServer extends ConsumerWidget {
  MakeAServer({super.key});
  final fKey = GlobalKey<FormState>();
  final serverController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BattleShip",
        ),
        backgroundColor: const Color(0xFF223A8E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: getHeight(context, 100),
          child: Column(
            children: [
              SizedBox(
                height: getHeight(context, 20),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: getHeight(context, 3),
                  horizontal: getWidth(context, 6),
                ),
                child: Form(
                  key: fKey,
                  child: TextFormField(
                    clipBehavior: Clip.antiAlias,
                    controller: serverController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Server Name",
                      labelText: "Server Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "*Required";
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      if (fKey.currentState!.validate()) {
                        ref.read(serverNameStateProvider.notifier).state =
                            value;
                      }
                    },
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
                  onSubmitted: (value) {
                    ref.read(passwordStateProvider.notifier).state = value;
                  },
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
                  if (fKey.currentState!.validate()) {
                    ref.read(serverNameStateProvider.notifier).state =
                        serverController.text;
                    ref.read(passwordStateProvider.notifier).state =
                        passwordController.text;
                  }
                },
                child: const Text("Start the Server"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
