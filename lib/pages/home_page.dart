import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          const Text('HomePage'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addParking),
            child: const Text('Add Parking'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.parkingHistory),
            child: const Text('Parking History'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.parkingDetail),
            child: const Text('Parking Detail'),
          ),
        ],
      ),
    );
  }
}
