import 'package:flutter/material.dart';

Color avatarColor(String name) {
  final colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];
  return colors[name.hashCode % colors.length];
}

String avatarInitial(String name) {
  return name.isNotEmpty ? name[0].toUpperCase() : "?";
}
