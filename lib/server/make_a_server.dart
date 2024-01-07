import 'package:flutter/material.dart';

class MakeAServer extends StatelessWidget {
  MakeAServer({super.key});
  final serverController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: serverController,
          decoration: const InputDecoration(
            hintText: "Enter Server Name",
            labelText: "Server Name",
            errorText: "Name for the server is required!",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            hintText: "Enter Password",
            labelText: "Password",
            suffixText: "*leave empty for no password",
          ),
        ),
        ElevatedButton(
          onPressed: () => {},
          child: const Text("Start the Server"),
        ),
      ],
    );
  }
}
