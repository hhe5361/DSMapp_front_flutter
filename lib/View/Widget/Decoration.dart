import 'package:dasom_community_app/Component/ColorDef.dart';
import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  );
}

BoxDecoration buildBoxDecoration({Color color = colorlightgrey}) =>
    BoxDecoration(borderRadius: BorderRadius.circular(10), color: color);
