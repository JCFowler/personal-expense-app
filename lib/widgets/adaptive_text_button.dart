import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  final VoidCallback onPressedHandler;

  AdaptiveTextButton(this.onPressedHandler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              'Choose date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressedHandler,
          )
        : TextButton(
            onPressed: onPressedHandler,
            child: Text(
              'Choose date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
