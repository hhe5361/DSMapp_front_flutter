import 'package:dasom_community_app/Component/ColorDef.dart';
import 'package:flutter/material.dart';

AppBar titleAppbar(String title, BuildContext context,
        [bool isback = false, Widget? hasaction]) =>
    AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      centerTitle: true,
      leading: isback == false
          ? IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ))
          : null,
      backgroundColor: colormainpink,
      actions: hasaction == null ? null : [hasaction],
    );
