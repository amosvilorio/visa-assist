import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/login_screen.dart';
import 'package:visa_app/screens/admin/questions/questions_screen.dart';
import '../settings/settings_home_screen.dart';
import '../payments/payments_screen.dart';
import '../banks/bank_accounts_screen.dart';
import '../cases/cases_screen.dart';
import '../../support/admin_support_chats_screen.dart';
import 'package:visa_app/screens/admin/evaluations/evaluations_screen.dart';
import '../../notifications/notifications_screen.dart';
import '../../../services/notification_service.dart';


class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Visa Assist Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          //==================================================
          // NOTIFICACIONES
          //==================================================

          StreamBuilder<int>(
            stream: NotificationService()
                .watchUnreadCount(),

            builder: (context, snapshot) {

              final count =
                  snapshot.data ?? 0;

              return Stack(
                alignment: Alignment.center,
                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                    ),
                    tooltip: "Notificaciones",

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const NotificationsScreen(),
                        ),
                      );

                    },
                  ),

                  if (count > 0)
                    Positioned(
                      right: 7,
                      top: 7,
                      child: Container(
                        padding:
                        const EdgeInsets.all(4),

                        constraints:
                        const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),

                        decoration:
                        const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          count > 99
                              ? "99+"
                              : count.toString(),

                          textAlign:
                          TextAlign.center,

                          style:
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          //==================================================
          // CERRAR SESIÓN
          //==================================================

          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            tooltip: "Cerrar sesión",

            onPressed: () async {

              await FirebaseAuth.instance
                  .signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                  const LoginScreen(),
                ),

                    (route) => false,
              );

            },
          ),

        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

          Row(
          children: [

          Expanded(
          child: dashboardCard(
            icon: Icons.people,
            color: Colors.blue,
            title: "Usuarios",
            value: "0",
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: dashboardCard(
            icon: Icons.fact_check,
            color: Colors.green,
            title: "Evaluaciones",
            value: "0",
          ),
        ),

        ],
      ),

      const SizedBox(height: 15),

      Row(
        children: [

          Expanded(
            child: dashboardCard(
              icon: Icons.folder_copy,
              color: Colors.orange,
              title: "Expedientes",
              value: "0",
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: dashboardCard(
              icon: Icons.attach_money,
              color: Colors.purple,
              title: "Ingresos",
              value: "RD\$0",
            ),
          ),

        ],
      ),

      const SizedBox(height: 30),

      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Centro de Operaciones",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      const SizedBox(height: 20),

      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.90,
        children: [

          moduleCard(
            context,
            icon: Icons.people_alt,
            color: Colors.blue,
            title: "Usuarios",
            subtitle: "Clientes registrados",
            onTap: () {},
          ),

          moduleCard(
            context,
            icon: Icons.assignment,
            color: Colors.green,
            title: "Evaluaciones",
            subtitle: "Perfiles migratorios",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EvaluationsScreen(),
                ),
              );
            },
          ),

          moduleCard(
            context,
            icon: Icons.folder_shared,
            color: Colors.orange,
            title: "Expedientes",
            subtitle: "Solicitudes de visa",
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CasesScreen(),
                ),
              );

            },
          ),

          moduleCard(
            context,
            icon: Icons.support_agent,
            color: Colors.indigo,
            title: "Agentes",
            subtitle: "Equipo migratorio",
            onTap: () {},
          ),

          moduleCard(
            context,
            icon: Icons.chat,
            color: Colors.teal,
            title: "Chats",
            subtitle: "Conversaciones",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const AdminSupportChatsScreen(),
                ),
              );
            },
          ),

          moduleCard(
            context,
            icon: Icons.account_balance,
            color: Colors.blueGrey,
            title: "Bancos",
            subtitle: "Cuentas Bancarias",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BankAccountsScreen(),
                ),
              );
            },
          ),

          moduleCard(
            context,
            icon: Icons.payments,
            color: Colors.purple,
            title: "Pagos",
            subtitle: "Ingresos",
            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) => const PaymentsScreen(),

                ),

              );

            },
          ),

          moduleCard(
            context,
            icon: Icons.settings,
            color: Colors.red,
            title: "Configuración",
            subtitle: "Sistema",
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsHomeScreen(),
                ),
              );

            },
          ),

          moduleCard(
            context,
            icon: Icons.bar_chart,
            color: Colors.brown,
            title: "Reportes",
            subtitle: "Estadísticas",
            onTap: () {},
          ),

          moduleCard(
            context,
            icon: Icons.help,
            color: Colors.deepOrange,
            title: "Preguntas",
            subtitle: "Banco de preguntas",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuestionsScreen(),
                ),
              );
            },
          ),

        ],
      ),

      const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget moduleCard(
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
                  size: 26,
                ),
              ),

              const SizedBox(height: 15),

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