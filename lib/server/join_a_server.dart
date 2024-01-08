import 'package:battle_ship/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinAServer extends ConsumerWidget {
  const JoinAServer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var serverS = ref.watch(serverStream);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BattleShip",
        ),
        backgroundColor: const Color(0xFF223A8E),
        foregroundColor: Colors.white,
      ),
      body: serverS.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => const Text("Somekind of error"),
        data: (data) {
          if (data.snapshot.value == null) {
            return const Text("No Server available");
          } else {
            var servers = data.snapshot.value as Map<Object?, Object?>;
            var serverList = servers.keys.toList();
            return ListView.builder(
              itemCount: serverList.length,
              itemBuilder: (context, index) {
                var pass = servers[serverList[index]] as Map<Object?, Object?>;
                var password = pass['password'] as String?;
                return ListTile(
                  title: Text(serverList[index] as String),
                  trailing: password == null || password.isEmpty
                      ? null
                      : const Icon(Icons.lock),
                );
              },
            );
          }
        },
      ),
    );
  }
}
