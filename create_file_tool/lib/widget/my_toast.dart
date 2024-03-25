import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class MyToast {
  static showToastSuccess({required String message}) {
    return BotToast.showCustomText(
      toastBuilder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  static showToastError({required String message}) {
    return BotToast.showCustomText(
      toastBuilder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
