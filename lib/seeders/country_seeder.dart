import 'package:cloud_firestore/cloud_firestore.dart';

class CountrySeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    final countryRef = _db.collection('countries').doc('usa');

    final country = await countryRef.get();

    if (country.exists) {
      return;
    }

    await countryRef.set({
      'nombre': 'Estados Unidos',
      'codigo': 'usa',
      'bandera': '🇺🇸',
      'descripcion':
      'Solicitudes de visa para turismo, negocios, estudios y otras categorías.',
      'activo': true,
      'orden': 1,
      'precioSolicitud': 2500.0,
      'precioEvaluacionPremium': 1000.0,
      'moneda': 'DOP',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final visaTypes = countryRef.collection('visaTypes');

    await visaTypes.doc('b1b2').set({
      'nombre': 'Visa de Turismo / Negocios (B1/B2)',
      'codigo': 'b1b2',
      'activo': true,
      'orden': 1,
    });

    await visaTypes.doc('f1').set({
      'nombre': 'Visa de Estudiante (F1)',
      'codigo': 'f1',
      'activo': true,
      'orden': 2,
    });

    await visaTypes.doc('k1').set({
      'nombre': 'Visa de Prometido(a) (K1)',
      'codigo': 'k1',
      'activo': true,
      'orden': 3,
    });

    await visaTypes.doc('h1b').set({
      'nombre': 'Visa de Trabajo (H1B)',
      'codigo': 'h1b',
      'activo': true,
      'orden': 4,
    });
  }
}