import 'package:flutter/material.dart';

double getWidth(BuildContext context, double percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeight(BuildContext context, double percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}
