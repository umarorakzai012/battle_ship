import 'dart:developer';

import 'package:battle_ship/game_play/game.dart';
import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MakeShip extends ConsumerWidget {
  const MakeShip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double blockSize = 11.6;

    var streamServer = ref.watch(dbrefStreamProvider);
    String uuid = ref.watch(uuidStateProvider);
    var board = ref.watch(yourBoardStateProvider);
    int parts = 18;
    int used = 0;
    for (var numbers in board) {
      for (var number in numbers) {
        used += number;
      }
    }
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) return;
        ref.read(dbrefStateProvider.notifier).state.child(uuid).remove();

        ref.read(dbrefStateProvider.notifier).state =
            ref.read(dbrefStateProvider.notifier).state.root;
      },
      child: Scaffold(
        appBar: getAppBar(context),
        body: streamServer.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text("MakeShip Error")),
          data: (data) {
            int ready = 0;
            bool status = false;
            if (data.snapshot.value != null) {
              if (data.snapshot.ref.parent?.key! != "making_ship") {
                return const SizedBox();
              }
              var players = data.snapshot.value as Map<Object?, Object?>;
              for (var key in players.keys) {
                var player = players[key] as Map<Object?, Object?>;
                if (key == uuid) status = player['ready'] as bool;
                ready += player['ready'] as bool ? 1 : 0;
              }
              SchedulerBinding.instance.addPostFrameCallback((time) {
                if (ready == 2) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Game(),
                    ),
                  );
                  ref.read(dbrefStateProvider.notifier).state = ref
                      .read(dbrefStateProvider.notifier)
                      .state
                      .root
                      .child('ongoing')
                      .child(data.snapshot.key!);
                  ref.read(dbrefStateProvider.notifier).state.child(uuid).set({
                    'username': ref.read(userNameStateProvider.notifier).state,
                    'board': ref.read(yourBoardStateProvider.notifier).state,
                    'turn': ref.read(turnStateProvider.notifier).state
                  });
                  ref
                      .read(dbrefStateProvider.notifier)
                      .state
                      .child(uuid)
                      .onDisconnect()
                      .remove();
                }
              });
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: getWidth(context, 8),
                      right: getWidth(context, 8),
                      top: getWidth(context, 4),
                    ),
                    width: getWidth(context, 7 * blockSize),
                    height: getWidth(context, (7 * blockSize) + 5),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: board.length,
                      itemBuilder: (context, i) {
                        return SizedBox(
                          width: getWidth(context, 7 * blockSize),
                          height: getWidth(context, blockSize),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: board[i].length,
                            itemBuilder: (context, j) {
                              return GestureDetector(
                                onTap: () {
                                  if (status) return;
                                  if (board[i][j] == 0) {
                                    if (used == parts) return;

                                    board[i][j] = 1;
                                  } else {
                                    board[i][j] = 0;
                                  }
                                  ref
                                      .read(yourBoardStateProvider.notifier)
                                      .state = board;
                                  data.snapshot.ref.child(uuid).update({
                                    'board': board,
                                  });
                                },
                                child: Container(
                                  width: getWidth(context, blockSize),
                                  height: getWidth(context, blockSize),
                                  decoration: BoxDecoration(
                                    color: board[i][j] == 1
                                        ? const Color(0xCA223A8E)
                                        : null,
                                    border: const Border.fromBorderSide(
                                      BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    "You are ${status ? "Ready" : "Not Ready"}",
                    style: TextStyle(
                      fontSize: 23,
                      color: status
                          ? const Color.fromARGB(255, 7, 85, 10)
                          : Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: getHeight(context, 3),
                  ),
                  Text(
                    "Parts Used: $used/$parts",
                    style: const TextStyle(
                      fontSize: 23,
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
                    child: Text(
                      "Start($ready/2)",
                      style: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      data.snapshot.ref.child(uuid).update({'ready': !status});
                    },
                  ),
                  SizedBox(
                    height: getHeight(context, 5),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
