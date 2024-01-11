import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

double getWidth(BuildContext context, double percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeight(BuildContext context, double percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}

final userNameStateProvider = StateProvider<String>((ref) => "");

final serverNameStateProvider = StateProvider<String>((ref) => "");

final passwordStateProvider = StateProvider<String>((ref) => "");

final codeStateProvider = StateProvider<String>((ref) => "");

final uuidStateProvider = StateProvider<String>((ref) => const Uuid().v4());

final dbrefStateProvider = StateProvider<DatabaseReference>((ref) {
  var firebaseApp = Firebase.app();
  var fbInstance = FirebaseDatabase.instance;
  // var fbInstance = FirebaseDatabase.instanceFor(
  //   app: firebaseApp,
  //   databaseURL:
  //       "https://fir-app-11707-default-rtdb.asia-southeast1.firebasedatabase.app/",
  // );
  fbInstance.useDatabaseEmulator("127.0.0.1", 9000);

  return fbInstance.ref("server");
});

final dbrefStreamProvider = StreamProvider<DatabaseEvent>(
  (ref) => ref.watch(dbrefStateProvider).onValue,
);

String splitString = "<^_^>";

AppBar getAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: getHeight(context, 10),
    title: const Text(
      "BattleShip",
    ),
    backgroundColor: const Color(0xFF223A8E),
    foregroundColor: Colors.white,
  );
}

// // ., $, #, [, ], /, or ASCII control characters 0-31 or 127

// bool validateString(String text) {
//   List<String> vali = ['.', r'$', '#', '[', ']', '/'];
//   for (var i = 0; i < 32; i++) {
//     vali.add(String.fromCharCode(i));
//   }
//   vali.add(String.fromCharCode(127));
//   for (var i = 0; i < vali.length; i++) {
//     if (text.contains(vali[i])) return false;
//   }
//   return true;
// }
