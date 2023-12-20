import 'package:dasom_community_app/Component/ColorDef.dart';
import 'package:flutter/material.dart';

Future<void> shortDialog(String headline, String msg, BuildContext context,
        [void Function()? callback]) =>
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(headline),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                if (callback == null) {
                  Navigator.pop(context);
                } else {
                  callback;
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

AlertDialog shortAlert(String headline, String msg, BuildContext context) =>
    AlertDialog(
      title: Text(headline),
      content: Text(msg),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('확인'),
        ),
      ],
    );

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 700),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black38),
      ),
      backgroundColor: colorlightgrey,
      //behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}
