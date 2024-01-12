import 'package:battle_ship/global.dart';
import 'package:battle_ship/home_screen.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final bool youWon;
  const GameOver({super.key, required this.youWon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You",
              style: TextStyle(fontSize: 23),
            ),
            Text(
              "${youWon ? "Won" : "Lost"}!",
              style: const TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: getHeight(context, 7),
            ),
            ElevatedButton(
              style: getButtonStyle(context),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: const Text("Main Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
