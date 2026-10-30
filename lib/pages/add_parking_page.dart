import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AddParkingPage extends StatelessWidget {
  const AddParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Parking')),
      body: Column(
        children: [
          const Text('AddParkingPage'),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.capturePhoto),
            child: const Text('Capture Photo'),
          ),
        ],
      ),
    );
  }
}