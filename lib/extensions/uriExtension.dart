import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/extensions/stringExtension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

extension UriExtension on Uri {
  void tryLaunch([
    String? copyOnError,
    BuildContext? context,
  ]) {
    var errorMsg =
        "I can not launch the url, So i copied it into your clipboard";

    canLaunchUrl(this).then(
      (can) {
        if (kIsWeb && !can) {
          copyOnError?.copyToClipboard();
          if (context != null) errorMsg.showSnackBar(context);
          return;
        } 

        launchUrl(this).then(
          (successful) {
            if (successful == true) return;
            copyOnError?.copyToClipboard();
            if (context != null) errorMsg.showSnackBar(context);
          },
        ).onError(
          (error, stackTrace) {
            copyOnError?.copyToClipboard();
            if (context != null) errorMsg.showSnackBar(context);
          },
        );
      },
    ).onError(
      (error, stackTrace) {
        copyOnError?.copyToClipboard();
        if (context != null) errorMsg.showSnackBar(context);
      },
    );
  }
}

extension StringUriExtension on String {
  void tryLaunch([
    String? copyOnError,
    BuildContext? context,
  ]) {
    const errorMsg =
        "I cannot launch the link, so I've copied it into your clipboard.";

    // Helper function to handle error and display a snack bar
    FutureOr<Null> handleError([Exception? e]) {
      if (copyOnError != null) {
        copyOnError.copyToClipboard();
      }
      if (context != null) {
        errorMsg.showSnackBar(context);
      }
    }

    // Try to launch the URL
    canLaunchUrlString(this).then(
      (canLaunch) {
        if (kIsWeb && !canLaunch) {
          handleError();
          return;
        }
        
        launchUrlString(this).then(
          (success) {
            if (!success) {
              handleError();
            }
          },
        ).catchError((_) => handleError());
      },
    ).catchError((_) => handleError()); // Handle if canLaunchUrlString fails
  }
}
