import 'package:flutter/material.dart';

const alphabeta = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
];

final regex = RegExp("(?:(?![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+");

const backgroundColor = Color.fromARGB(255, 237, 241, 245);

String getBelowRange(int length) {
  final s = length.toString();

  if (s.length == 1) {
    return '0';
  }

  return s.substring(0, 1) + List.generate(s.length - 1, (index) => '0').join();
}

String getTopRange(int length) {
  final s = length.toString();
  final fn = int.parse(s.substring(0, 1));

  if (s.length == 1) {
    return '10';
  }
  return (fn + 1).toString() +
      List.generate(s.length - 1, (index) => '0').join();
}
