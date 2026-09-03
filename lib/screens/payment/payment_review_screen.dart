import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../portal/portal_screen.dart';

class PaymentReviewScreen extends StatelessWidget {
  const PaymentReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pago en Revisión"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(height: 10),

              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top,
                  size: 70,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "¡Comprobante enviado!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Hemos recibido correctamente tu comprobante de pago.\n\nNuestro equipo revisará la transferencia antes de iniciar la preparación de tu expediente.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      const Icon(
                        Icons.pending_actions,
                        color: Colors.orange,
                        size: 45,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Estado del Pago",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "🟡 EN REVISIÓN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      "⏳ Tiempo estimado",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "La validación del pago puede tardar entre 1 hora y 24 horas, dependiendo del horario en que se haya realizado la transferencia.",
                      style: TextStyle(
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Podrás seguir utilizando la aplicación mientras nuestro equipo verifica tu pago.\n\nRecibirás una notificación cuando el pago sea aprobado o si es necesario realizar alguna corrección.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(

                  icon: const Icon(Icons.home),

                  label: const Text(
                    "VOLVER AL PORTAL",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  onPressed: () {

                    Navigator.pushAndRemoveUntil(

                      context,

                      MaterialPageRoute(
                        builder: (_) => const PortalScreen(),
                      ),

                          (route) => false,
                    );

                  },
                ),
              ),

              const SizedBox(height: 25),

            ],
          ),
        ),
      ),
    );
  }
}