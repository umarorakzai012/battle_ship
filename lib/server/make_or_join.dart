import 'package:battle_ship/global.dart';
import 'package:battle_ship/server/join_a_server.dart';
import 'package:battle_ship/server/make_a_server.dart';
import 'package:flutter/material.dart';

class MakeOrJoin extends StatelessWidget {
  const MakeOrJoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: getButtonStyle(context),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MakeAServer(),
                ),
              ),
              child: const Text("Make a Server"),
            ),
            SizedBox(
              height: getHeight(context, 3),
            ),
            ElevatedButton(
              style: getButtonStyle(context),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinAServer(),
                ),
              ),
              child: const Text(
                "Join a Server",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
