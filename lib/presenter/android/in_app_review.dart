import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;
  // static final String _appStoreId = '';

  static Future<void> requestReviewOrOpen() async {
    await _openStoreListing();
  }

  // static Future<void> _requestReview() => _inAppReview.requestReview();

  static Future<void> _openStoreListing() => _inAppReview.openStoreListing(
      // appStoreId: _appStoreId,
      );
}
