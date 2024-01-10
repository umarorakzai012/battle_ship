import 'package:battle_ship/global.dart';
import 'package:battle_ship/server/in_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:randomstring_dart/randomstring_dart.dart';

class MakeAServer extends ConsumerWidget {
  MakeAServer({super.key});
  final fKey = GlobalKey<FormState>();
  final serverController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: getAppBar(context),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                    ],
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                  ],
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
                    var serverName = serverController.text;
                    var password = passwordController.text;
                    ref.read(serverNameStateProvider.notifier).state =
                        serverName;
                    ref.read(passwordStateProvider.notifier).state = password;
                    var rs = RandomString();
                    String code = rs.getRandomString(
                      lowersCount: 5,
                      uppersCount: 0,
                      canSpecialRepeat: false,
                      numbersCount: 0,
                      specials: '',
                      specialsCount: 0,
                    );
                    ref.read(codeStateProvider.notifier).state = code;

                    String servernameCodePassword =
                        "$serverName$splitString$code";
                    if (password.isNotEmpty) {
                      servernameCodePassword =
                          "$servernameCodePassword$splitString$password";
                    }

                    ref.read(dbrefStateProvider.notifier).state = ref
                        .read(dbrefStateProvider.notifier)
                        .state
                        .child(servernameCodePassword);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InServer(),
                      ),
                    );
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
