import 'country_seeder.dart';
import 'settings_seeder.dart';

class AppSeeder {
  static Future<void> initialize() async {
    await SettingsSeeder.seed();
    await CountrySeeder.seed();
  }
}