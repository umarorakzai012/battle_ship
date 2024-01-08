import 'dart:developer';

import 'package:battle_ship/global.dart';
import 'package:battle_ship/server/in_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinAServer extends ConsumerWidget {
  JoinAServer({super.key});

  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<Object?, Object?>? serverData;
    var streamServer = ref.watch(serverStream);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BattleShip",
        ),
        backgroundColor: const Color(0xFF223A8E),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context, "Enter Code",
            "Enter server code", codeController, onCodeSubmit, serverData, ""),
        backgroundColor: const Color(0xFF223A8E),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: streamServer.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Text("Somekind of error"),
        data: (data) {
          if (data.snapshot.value == null) {
            return const Center(
              child: Text(
                "No Server available",
                style: TextStyle(fontSize: 30),
              ),
            );
          } else {
            var servers = data.snapshot.value as Map<Object?, Object?>;
            serverData = servers;
            var serverList = servers.keys.toList();
            return ListView.builder(
              itemCount: serverList.length,
              itemBuilder: (context, index) {
                String code = serverList[index] as String;
                var serverDetails = servers[code] as Map<Object?, Object?>;
                var password = serverDetails['password'] as String?;
                var name = serverDetails['name'] as String;
                if (serverDetails.length == 4) return const SizedBox();
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: getHeight(context, 2),
                    horizontal: getWidth(context, 4),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: getHeight(context, 1),
                    horizontal: getWidth(context, 2),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                  ),
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    trailing: password == null || password.isEmpty
                        ? null
                        : const Icon(Icons.lock),
                    onTap: () {
                      if (password == null || password.isEmpty) {
                        onPasswordSubmit(
                            context, serverDetails, password ?? "", code);
                      } else {
                        _displayTextInputDialog(
                          context,
                          "Enter Password",
                          "Password",
                          passwordController,
                          onPasswordSubmit,
                          serverDetails,
                          code,
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void onCodeSubmit(BuildContext context, Map<Object?, Object?>? serverData,
      String inputCode, String garbage) {
    if (serverData != null) {
      for (var code in serverData.keys) {
        var serverDetails = serverData[code]! as Map<Object?, Object?>;
        String actualCode = code as String;
        if (actualCode == inputCode) {
          var password = serverDetails['password'] as String?;
          if (password == null || password.isEmpty) {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InServer(code: code)),
            );
          } else {
            _displayTextInputDialog(
                context,
                "Enter Password",
                "Password",
                passwordController,
                onPasswordSubmit,
                serverDetails,
                actualCode);
          }
          return;
        }
      }
    }
    showSnackBar(context, "Wrong Code");
  }

  void onPasswordSubmit(BuildContext context,
      Map<Object?, Object?>? serverDetails, String inputPassword, String code) {
    if (serverDetails != null) {
      String actualPassword = serverDetails['password'] as String;
      if (actualPassword == inputPassword) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InServer(code: code)),
        );
        return;
      }
    }
    showSnackBar(context, "Wrong Password");
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Center(child: Text(message))));
  }

  Future<void> _displayTextInputDialog(
      BuildContext context,
      String title,
      String hint,
      TextEditingController controller,
      void Function(BuildContext, Map<Object?, Object?>?, String, String)
          onSubmit,
      Map<Object?, Object?>? send,
      String additional) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {},
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: const Color(0xFF223A8E),
              textColor: Colors.white,
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            MaterialButton(
              color: const Color(0xFF223A8E),
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                onSubmit(context, send, controller.text, additional);
                controller.clear();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
