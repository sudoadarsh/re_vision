import 'package:flutter/material.dart';

extension DoubleEx on double {
  SizedBox separation(bool vertical) {
    return SizedBox(
      height: vertical? this : 0,
      width: vertical ? 0: this,
    );
  }
}