import 'package:flutter/material.dart';
import 'payment_settings_screen.dart';
import '../banks/bank_accounts_screen.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        title: const Text(
          "Configuración",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: GridView.count(
        padding: const EdgeInsets.all(20),

        crossAxisCount: 2,

        crossAxisSpacing: 15,

        mainAxisSpacing: 15,

        childAspectRatio: .92,

        children: [

          settingCard(
            context,
            icon: Icons.business,
            color: Colors.blue,
            title: "General",
            subtitle: "Empresa",
            onTap: () {},
          ),

          settingCard(
            context,
            icon: Icons.payments,
            color: Colors.green,
            title: "Pagos",
            subtitle: "Precios",
            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const PaymentSettingsScreen(),

                ),

              );

            },
          ),

          settingCard(
            context,
            icon: Icons.account_balance,
            color: Colors.orange,
            title: "Bancos",
            subtitle: "Transferencias",
            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const BankAccountsScreen(),

                ),

              );

            },
          ),

          settingCard(
            context,
            icon: Icons.public,
            color: Colors.indigo,
            title: "Países",
            subtitle: "Migración",
            onTap: () {},
          ),

          settingCard(
            context,
            icon: Icons.flight_takeoff,
            color: Colors.teal,
            title: "Tipos de Visa",
            subtitle: "Categorías",
            onTap: () {},
          ),

          settingCard(
            context,
            icon: Icons.local_offer,
            color: Colors.purple,
            title: "Promociones",
            subtitle: "Descuentos",
            onTap: () {},
          ),

          settingCard(
            context,
            icon: Icons.notifications,
            color: Colors.red,
            title: "Notificaciones",
            subtitle: "Mensajes",
            onTap: () {},
          ),

          settingCard(
            context,
            icon: Icons.settings,
            color: Colors.brown,
            title: "Sistema",
            subtitle: "Aplicación",
            onTap: () {},
          ),

        ],
      ),
    );
  }

  Widget settingCard(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(.12),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}