import 'package:battle_ship/global.dart';
import 'package:battle_ship/server/make_or_join.dart';
import 'package:battle_ship/update/update_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  final controller = TextEditingController();
  final fKey = GlobalKey<FormState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String username = ref.watch(userNameStateProvider);
    CheckUpdate(fromNavigation: false, context: context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: getAppBar(context),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                    ],
                    onFieldSubmitted: (value) {
                      if (fKey.currentState!.validate() && value.isNotEmpty) {
                        controller.clear();
                        ref.read(userNameStateProvider.notifier).state = value;
                      }
                    },
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          username.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                style: getButtonStyle(context),
                onPressed: () {
                  String value = controller.text;
                  if (fKey.currentState!.validate() && value.isNotEmpty) {
                    FocusManager.instance.primaryFocus?.unfocus();
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
                style: getButtonStyle(context),
                onPressed: () {
                  if (fKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
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
      ),
    );
  }
}
