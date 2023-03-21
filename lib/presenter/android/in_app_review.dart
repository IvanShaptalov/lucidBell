import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;
  // static final String _appStoreId = '';

  static Future<void> openStoreListing() async {
    await _openStoreListing();
  }

  static Future<void> tryRequestReview() => _requestReview();

  static Future<void> _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      print('not awailable');
    }
  }

  static Future<void> _openStoreListing() => _inAppReview.openStoreListing(
      // appStoreId: _appStoreId,
      );
}
