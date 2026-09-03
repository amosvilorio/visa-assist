import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../portal/portal_screen.dart';
import '../evaluation/evaluation_detail_screen.dart';

class PaymentPendingScreen extends StatelessWidget {
  final String evaluationId;

  const PaymentPendingScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('evaluations')
          .doc(evaluationId)
          .snapshots(),
      builder: (context, snapshot) {
        // ==================================================
        // CARGANDO
        // ==================================================

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ==================================================
        // ERROR
        // ==================================================

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Pago enviado",
              ),
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No se pudo consultar el estado del pago.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // ==================================================
        // DOCUMENTO NO EXISTE
        // ==================================================

        if (!snapshot.hasData ||
            !snapshot.data!.exists) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Pago enviado",
              ),
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No se encontró la evaluación.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final evaluation =
            snapshot.data!.data() ?? {};

        final status =
            evaluation['status'] ?? 'waiting_payment';

        final premiumUnlocked =
            evaluation['premiumUnlocked'] == true;

        final premiumPaid =
            evaluation['premiumPaid'] == true;

        // ==================================================
        // PAGO APROBADO
        // ==================================================

        if (premiumUnlocked && premiumPaid) {
          WidgetsBinding.instance.addPostFrameCallback(
                (_) {
              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EvaluationDetailScreen(
                        evaluationId: evaluationId,
                      ),
                ),
              );
            },
          );

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // ==================================================
        // PAGO RECHAZADO
        // ==================================================

        if (status == 'payment_rejected') {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                "Pago rechazado",
              ),
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 30),

                  const CircleAvatar(
                    radius: 55,
                    backgroundColor:
                    Color(0xffffebee),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 70,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Pago no aprobado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "El administrador no aprobó el comprobante de pago. Puedes revisar la información y realizar nuevamente el proceso.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.home,
                      ),
                      label: const Text(
                        "IR AL INICIO",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const PortalScreen(),
                          ),
                              (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ==================================================
        // PAGO PENDIENTE
        // ==================================================

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Pago enviado",
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 15),

                const CircleAvatar(
                  radius: 55,
                  backgroundColor:
                  Color(0xffE8F5E9),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 70,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "¡Comprobante recibido!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Hemos recibido correctamente tu comprobante de pago.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding:
                  const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.pending_actions,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Estado del Pago",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Pendiente de verificación",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Nuestro equipo verificará tu comprobante de pago. Una vez aprobado, podrás continuar con tu evaluación.",
                        style: TextStyle(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 3,
                  child: Padding(
                    padding:
                    const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "¿Qué sucede ahora?",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const ListTile(
                          leading: Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
                          title: Text(
                            "Verificaremos tu pago.",
                          ),
                        ),

                        const ListTile(
                          leading: Icon(
                            Icons.pause_circle_outline,
                            color:
                            AppColors.primary,
                          ),
                          title: Text(
                            "Tu evaluación permanecerá pausada mientras verificamos tu pago.",
                          ),
                        ),

                        const ListTile(
                          leading: Icon(
                            Icons.lock_open,
                            color:
                            AppColors.primary,
                          ),
                          title: Text(
                            "Cuando el pago sea aprobado, podrás continuar tu evaluación desde la pregunta 11.",
                          ),
                        ),

                        const ListTile(
                          leading: Icon(
                            Icons.notifications_active,
                            color: Colors.orange,
                          ),
                          title: Text(
                            "Recibirás una notificación cuando el pago sea aprobado.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Container(
                  padding:
                  const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Mientras el pago esté pendiente de aprobación, tu evaluación permanecerá pausada. Cuando el pago sea aprobado, recibirás una notificación y podrás continuar desde la pregunta 11.",
                          style: TextStyle(
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.home,
                    ),
                    label: const Text(
                      "IR AL INICIO",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PortalScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.fact_check,
                    ),
                    label: const Text(
                      "VER MI EVALUACIÓN",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PortalScreen(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}