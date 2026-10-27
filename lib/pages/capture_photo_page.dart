import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class CapturePhotoPage extends StatelessWidget {
  const CapturePhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Photo')),
      body: Column(
        children: [
          const Text('CapturePhotoPage'),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.confirmLocation),
            child: const Text('Confirm Location'),
          ),
        ],
      ),
    );
  }
}
