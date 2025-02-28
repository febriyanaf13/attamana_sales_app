import 'package:flutter/material.dart';

import 'custom_lottie.dart';

class CustomLottieNotFound extends StatelessWidget {
  const CustomLottieNotFound({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customLottie('not_found'),
          const Text('Data Tidak Ditemukan'),
        ],
      ),
    );
  }
}
