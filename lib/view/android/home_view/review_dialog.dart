import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_lucid_bell/presenter/android/in_app_review.dart';

class ReviewDialog {
  static void showReviewDialog(context) {
    
    var value = Random().nextInt(10);
    if (kDebugMode) {
      print(value);
    }
    if (value == 5) {
      ReviewService.tryRequestReview();
    }
  }
}
