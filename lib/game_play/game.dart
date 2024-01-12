import 'dart:developer';

import 'package:battle_ship/game_play/game_over.dart';
import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Game extends ConsumerWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double smallBlockSize = 4.7275;
    double blockSize = 9;

    var streamServer = ref.watch(dbrefStreamProvider);
    var uuid = ref.watch(uuidStateProvider);
    // var yourBoard = ref.watch(yourBoardStateProvider);
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
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Center(
            child: Text("Error in Game"),
          ),
          data: (data) {
            if (data.snapshot.value == null) return const SizedBox();

            var players = data.snapshot.value as Map<Object?, Object?>;
            bool turn = false;
            String opponentuuid = "";
            Map<Object?, Object?> you = {}, opponent = {};
            for (var player in players.keys) {
              if (player == uuid) {
                you = players[player] as Map<Object?, Object?>;
                turn = you['turn'] as bool;
              } else {
                opponentuuid = player as String;
                opponent = players[opponentuuid] as Map<Object?, Object?>;
              }
            }
            var opponentBoard = opponent['board'] as List<dynamic>;
            var yourBoard = you['board'] as List<dynamic>;
            int nbyn = yourBoard.length;
            int yourPartLeft = 0, yourTotal = 0;
            for (var numbers in yourBoard) {
              for (var num in numbers) {
                if (num == 1 || num == 2 || num == 3) yourTotal++;
                if (num == 1) yourPartLeft++;
              }
            }
            int opponentPartLeft = 0, opponentTotal = 0;
            for (var numbers in opponentBoard) {
              for (var num in numbers) {
                if (num == 1 || num == 2 || num == 3) opponentTotal++;
                if (num == 1) opponentPartLeft++;
              }
            }
            Map<int, Color> mapColor = {
              0: Colors.white,
              1: const Color(0xCA223A8E),
              2: Colors.red,
              3: Colors.yellow,
              4: Colors.purple
            };
            SchedulerBinding.instance.addPostFrameCallback((time) {
              if (yourPartLeft == 0 || opponentPartLeft == 0) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GameOver(youWon: opponentPartLeft == 0),
                  ),
                );
                List<List<int>> board = [];
                for (var i = 0; i < 7; i++) {
                  board.add([]);
                  for (var j = 0; j < 7; j++) {
                    board[i].add(0);
                  }
                }
                ref.read(yourBoardStateProvider.notifier).state = board;
                ref.read(dbrefStateProvider.notifier).state = ref
                    .read(dbrefStateProvider.notifier)
                    .state
                    .root
                    .child('server')
                    .child(data.snapshot.key!);
              }
            });
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: getWidth(context, 4),
                        ),
                        width: getWidth(context, nbyn * smallBlockSize),
                        height: getWidth(context, nbyn * smallBlockSize),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: nbyn,
                          itemBuilder: (context, i) {
                            return SizedBox(
                              width: getWidth(context, nbyn * smallBlockSize),
                              height: getWidth(context, smallBlockSize),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: yourBoard[i].length,
                                itemBuilder: (context, j) {
                                  return Container(
                                    width: getWidth(context, smallBlockSize),
                                    height: getWidth(context, smallBlockSize),
                                    decoration: BoxDecoration(
                                      color: mapColor[yourBoard[i][j]],
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: turn
                                              ? Colors.green
                                              : Colors.black,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Your",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            "Parts left: $yourPartLeft/$yourTotal",
                            style: const TextStyle(fontSize: 25),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(context, 2),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: getWidth(context, 4),
                    ),
                    width: getWidth(context, nbyn * blockSize),
                    height: getWidth(context, nbyn * blockSize),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nbyn,
                      itemBuilder: (context, i) {
                        return SizedBox(
                          width: getWidth(context, nbyn * blockSize),
                          height: getWidth(context, blockSize),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: opponentBoard[i].length,
                            itemBuilder: (context, j) {
                              return GestureDetector(
                                onTap: () {
                                  if (!turn) return;

                                  if (opponentBoard[i][j] == 2 ||
                                      opponentBoard[i][j] == 3 ||
                                      opponentBoard[i][j] == 4) {
                                    return;
                                  }

                                  if (opponentBoard[i][j] == 1) {
                                    opponentBoard[i][j] = 2;
                                    if (isShipCompletelyDestroyed(
                                        i, j, opponentBoard)) {
                                      destroyShip(i, j, opponentBoard);
                                    }
                                  } else {
                                    opponentBoard[i][j] = 4;
                                  }
                                  turn = false;
                                  data.snapshot.ref.update({
                                    '$opponentuuid/board': opponentBoard,
                                    '$opponentuuid/turn': true,
                                    '$uuid/turn': false,
                                  });
                                },
                                child: Container(
                                  width: getWidth(context, blockSize),
                                  height: getWidth(context, blockSize),
                                  decoration: BoxDecoration(
                                    color: opponentBoard[i][j] == 1
                                        ? mapColor[0]
                                        : mapColor[opponentBoard[i][j]],
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                        color:
                                            turn ? Colors.green : Colors.black,
                                      ),
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
                  SizedBox(
                    height: getHeight(context, 2),
                  ),
                  Text(
                    "${opponent['username']}'s",
                    style: const TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: getHeight(context, 2),
                  ),
                  Text(
                    "Parts left: $opponentPartLeft/$opponentTotal",
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool isShipCompletelyDestroyed(int i, int j, List<dynamic> board) {
    // out of bounds
    if (i >= board.length || i < 0 || j >= board[i].length || j < 0) {
      return true;
    }

    // not part of ship
    if (board[i][j] == 0 || board[i][j] == 4) return true;

    // already visited
    if (board[i][j] == 5) return true;

    // ship part, but not hit
    if (board[i][j] == 1) return false;

    // mark as visited
    board[i][j] = 5;

    bool surrondingHit = isShipCompletelyDestroyed(i + 1, j, board) &&
        isShipCompletelyDestroyed(i - 1, j, board) &&
        isShipCompletelyDestroyed(i, j + 1, board) &&
        isShipCompletelyDestroyed(i, j - 1, board);

    // backtract visited
    board[i][j] = 2;

    return surrondingHit;
  }

  void destroyShip(int i, int j, List<dynamic> board) {
    // out of bounds
    if (i >= board.length || i < 0 || j >= board[i].length || j < 0) return;

    // not part of ship
    if (board[i][j] == 0 || board[i][j] == 4) return;

    // already destroyed
    if (board[i][j] == 3) return;

    // mark as destroyed
    board[i][j] = 3;

    // destroy surrounding parts
    destroyShip(i + 1, j, board);
    destroyShip(i - 1, j, board);
    destroyShip(i, j + 1, board);
    destroyShip(i, j - 1, board);
  }
}
