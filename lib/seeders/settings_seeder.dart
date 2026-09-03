import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    final settingsRef =
    _db.collection('settings').doc('general');

    final settings = await settingsRef.get();

    if (settings.exists) return;

    await settingsRef.set({
      'appName': 'Visa Assist',
      'supportEmail': '',
      'supportPhone': '',
      'maintenance': false,
      'allowFreeEvaluation': true,
      'allowPremiumEvaluation': true,
      'defaultCurrency': 'DOP',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}