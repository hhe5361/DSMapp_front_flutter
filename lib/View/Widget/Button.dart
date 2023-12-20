import 'package:dasom_community_app/util/mediasize.dart';
import 'package:flutter/material.dart';

ElevatedButton longButtons(String label, void Function()? callback) =>
    ElevatedButton(
        onPressed: callback,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: medw * 0.2),
            child: Text(label)));
