import 'dart:developer';

import 'package:battle_ship/game_play/make_ship.dart';
import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InServer extends ConsumerWidget {
  const InServer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streamServer = ref.watch(dbrefStreamProvider);
    String serverName = ref.watch(serverNameStateProvider);
    String code = ref.watch(codeStateProvider);
    String username = ref.watch(userNameStateProvider);
    String uuid = ref.watch(uuidStateProvider);

    // String password = ref.watch(passwordStateProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) return;
        ref.read(dbrefStateProvider.notifier).state.child(uuid).remove();
        ref.read(dbrefStateProvider.notifier).state =
            ref.read(dbrefStateProvider.notifier).state.parent!;
      },
      child: Scaffold(
        appBar: getAppBar(context),
        body: streamServer.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Text("Somekind of error in InServer"),
          data: (data) {
            if (data.snapshot.key! == "server") return const SizedBox();
            // Updating username and password to database
            // data.snapshot.ref.child(uuid).once().then((value) {
            //   if (value.snapshot.value == null) {
            //     data.snapshot.ref.child(uuid).set({
            //       'username': username,
            //       'ready': false,
            //     });
            //     data.snapshot.ref.child(uuid).onDisconnect().remove();
            //   }
            // });
            Map<Object?, Object?> values = {};
            int numberOfReady = 0;
            if (data.snapshot.value != null) {
              values = data.snapshot.value as Map<Object?, Object?>;
              for (var value in values.keys) {
                var temp = values[value] as Map<Object?, Object?>;
                var ready = temp['ready'] as bool;
                if (ready) ++numberOfReady;
              }
              if (numberOfReady == 2) {
                SchedulerBinding.instance.addPostFrameCallback((time) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MakeShip(),
                    ),
                  );
                  ref.read(dbrefStateProvider.notifier).state = ref
                      .read(dbrefStateProvider.notifier)
                      .state
                      .root
                      .child('making_ship')
                      .child(data.snapshot.key!);
                  ref.read(dbrefStateProvider.notifier).state.child(uuid).set({
                    'username': username,
                    'ready': false,
                    'board': ref.read(yourBoardStateProvider.notifier).state
                  });
                  ref
                      .read(dbrefStateProvider.notifier)
                      .state
                      .child(uuid)
                      .onDisconnect()
                      .remove();
                });
              }
            }
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
                          serverName,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: getHeight(context, 2),
                      ),
                      if (values.isEmpty) ...[
                        const Center(
                            child: Text(
                          "No Player in Server",
                          style: TextStyle(fontSize: 15),
                        )),
                      ] else
                        ...players(context, values),
                    ],
                  ),
                ),
                Positioned(
                  bottom: getWidth(context, 0),
                  width: getWidth(context, 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            style: getButtonStyle(context),
                            onPressed: () {
                              Map<Object?, Object?> temp =
                                  values[uuid] as Map<Object?, Object?>;
                              bool ready = temp['ready'] as bool;
                              data.snapshot.ref.child(uuid).update(
                                {'ready': !ready},
                              );
                            },
                            child: Text(
                              "Start(${numberOfReady.toString()}/2)",
                              style: const TextStyle(fontSize: 18),
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
