import 'dart:developer';

import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InServer extends ConsumerWidget {
  final String servernameCodePassword;
  const InServer({super.key, required this.servernameCodePassword});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streamServer = ref.watch(serverStream);
    return Scaffold(
      appBar: getAppBar(context),
      body: streamServer.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Text("Somekind of error in InServer"),
        data: (data) {
          var values = data.snapshot.child(servernameCodePassword).value
              as Map<Object?, Object?>;
          var split = servernameCodePassword.split(splitString);
          String name = split[0];
          String code = split[1];
          return Stack(
            children: [
              Positioned(
                width: getWidth(context, 100),
                height: getHeight(context, 100),
                child: Column(
                  children: [
                    SizedBox(
                      height: getHeight(context, 5),
                    ),
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(context, 2),
                    ),
                    if (values.length == 2) ...[
                      const Center(
                          child: Text(
                        "No Player in Server",
                        style: TextStyle(fontSize: 15),
                      )),
                    ] else ...[
                      ...players(context, values)
                    ],
                  ],
                ),
              ),
              Positioned(
                bottom: getWidth(context, 0),
                // left: getWidth(context, 45),
                width: getWidth(context, 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.symmetric(
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
                            log("Pressed!");
                          },
                          child: const Text(
                            "Start(1/2)",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context, 3),
                        ),
                        const Text(
                          "Server Code",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          code,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: getHeight(context, 5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> players(BuildContext context, Map<Object?, Object?> data) {
    List<Widget> widgets = [];
    for (var key in data.keys) {
      String sKey = key as String;
      if (sKey == 'password' || sKey == 'name') continue;
      Map<Object?, Object?> playerData = data[key] as Map<Object?, Object?>;
      String username = playerData['username'] as String;
      bool status = playerData['ready'] as bool;
      widgets.add(Container(
        margin: EdgeInsets.symmetric(
          vertical: getHeight(context, 2),
          horizontal: getWidth(context, 4),
        ),
        padding: EdgeInsets.symmetric(
          vertical: getHeight(context, 3),
          horizontal: getWidth(context, 5),
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              username,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              status ? "Ready" : "Not Ready",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ));
    }
    return widgets;
  }
}
