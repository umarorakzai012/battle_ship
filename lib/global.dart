import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

double getWidth(BuildContext context, double percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeight(BuildContext context, double percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}

final userNameStateProvider = StateProvider<String>((ref) => "");

final serverNameStateProvider = StateProvider<String>((ref) => "");

final passwordStateProvider = StateProvider<String>((ref) => "");

final serverStream = StreamProvider<DatabaseEvent>((ref) {
  var firebaseApp = Firebase.app();
  var fbInstance = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL:
        "https://fir-app-11707-default-rtdb.asia-southeast1.firebasedatabase.app/",
  );

  var ref = fbInstance.ref("server");

  return ref.onValue;
});
