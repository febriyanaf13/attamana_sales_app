import 'package:flutter/material.dart';

import 'custom_lottie.dart';

class CustomLottieLoading extends StatelessWidget {
  const CustomLottieLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customLottie('not_found'),
          const Text('Loading...'),
        ],
      ),
    );
  }
}
