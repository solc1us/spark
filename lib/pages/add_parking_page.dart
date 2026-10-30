import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/parking_draft.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';

class AddParkingPage extends StatelessWidget {
  const AddParkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final draft = appState.parkingDraft;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Parking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: draft?.cityId,
              decoration: const InputDecoration(labelText: 'Kota'),
              items: [
                for (final city in appState.cities)
                  DropdownMenuItem(
                    value: city.id,
                    child: Text(city.name),
                  ),
              ],
              onChanged: (cityId) {
                final updatedDraft = draft ?? ParkingDraft();
                if (updatedDraft.cityId != cityId) {
                  updatedDraft.cityId = cityId;
                  updatedDraft.mallId = null;
                  appState.updateParkingDraft(updatedDraft);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: draft?.mode,
              decoration: const InputDecoration(
                labelText: 'Metode pencatatan',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'structured',
                  child: Text('Terstruktur'),
                ),
                DropdownMenuItem(
                  value: 'free',
                  child: Text('Bebas'),
                ),
              ],
              onChanged: (mode) {
                final updatedDraft = draft ?? ParkingDraft();
                if (updatedDraft.mode != mode) {
                  updatedDraft.mode = mode;
                  updatedDraft.category = null;
                  updatedDraft.mallId = null;
                  updatedDraft.placeName = null;
                  appState.updateParkingDraft(updatedDraft);
                }
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                final currentDraft = appState.parkingDraft;
                if (currentDraft?.cityId == null ||
                    currentDraft?.mode == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilih kota dan metode pencatatan.'),
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, AppRoutes.capturePhoto);
              },
              child: const Text('Capture Photo'),
            ),
          ],
        ),
      ),
    );
  }
}