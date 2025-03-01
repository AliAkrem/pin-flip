import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_flip/data/pin_flip_options.dart';

double _textScaleFactor(BuildContext context) {
  return PinFlipOptions.of(context).textScaleFactor(context);
}

double reducedTextScale(BuildContext context) {
  final textScaleFactor = _textScaleFactor(context);
  return textScaleFactor >= 1 ? (1 + textScaleFactor) / 2 : 1;
}

double cappedTextScale(BuildContext context) {
  final textScaleFactor = _textScaleFactor(context);
  return max(textScaleFactor, 1);
}
