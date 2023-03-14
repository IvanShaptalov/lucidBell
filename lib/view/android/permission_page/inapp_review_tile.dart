import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/in_app_review.dart';

class InAppReviewTile extends StatelessWidget {
  const InAppReviewTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('rate circle bell'),
      leading: const Icon(Icons.star),
      subtitle: const Text(
          "Enjoying our app? Leave a review to help make it even better! Your feedback is valuable to us. Thank you!"),
      onTap: () async {
        await ReviewService.requestReviewOrOpen();
      },
    );
  }
}
