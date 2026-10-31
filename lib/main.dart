import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/add_parking_page.dart';
import 'pages/capture_photo_page.dart';
import 'pages/confirm_location_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/parking_detail_page.dart';
import 'pages/parking_history_page.dart';
import 'pages/register_page.dart';
import 'routes/app_routes.dart';
import 'state/app_state.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const SparkApp()),
  );
}

class SparkApp extends StatelessWidget {
  const SparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark – Spot My Park',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.addParking: (_) => const AddParkingPage(),
        AppRoutes.capturePhoto: (_) => const CapturePhotoPage(),
        AppRoutes.confirmLocation: (_) => const ConfirmLocationPage(),
        AppRoutes.parkingHistory: (_) => const ParkingHistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != AppRoutes.parkingDetail) return null;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ParkingDetailPage(
            parkingSessionId: settings.arguments is String
                ? settings.arguments as String
                : null,
          ),
        );
      },
    );
  }
}
