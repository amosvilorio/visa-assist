import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'mrv_requests_screen.dart';
import '../../../services/payment_service.dart';
import '../../../models/payment.dart';


class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() =>
      _PaymentsScreenState();
}

class _PaymentsScreenState
    extends State<PaymentsScreen> {

  final PaymentService _paymentService =
  PaymentService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Pagos Pendientes",
        ),

        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              icon: const Icon(
                Icons.request_quote,
                size: 25,
              ),
              label: const Text(
                "MRV",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const MrvRequestsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: StreamBuilder<List<Payment>>(

        stream: _paymentService.pendingPayments(),

            builder: (context, snapshot) {

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData ||
                  snapshot.data!.isEmpty) {

                return const Center(

                  child: Text(
                    "No existen pagos pendientes.",
                  ),
                );
              }

              final payments =
              snapshot.data!;

              return ListView.builder(

                  padding: const EdgeInsets.all(15),

                  itemCount: payments.length,

                  itemBuilder: (context, index) {

                    final payment = payments[index];



                    return Card(

                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        elevation: 4,

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(18),
                        ),

                        child: Padding(

                          padding:
                          const EdgeInsets.all(18),

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                          Text(

                            "${payment.paymentType}: ${payment.expedienteId}",

                            style: const TextStyle(

                              fontWeight:
                              FontWeight.bold,

                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Usuario: ${payment.userId}",
                          ),

                          Text(
                            "Monto: ${payment.currency} ${payment.amount}",
                          ),

                          Text(
                            "Método: ${payment.paymentMethod}",
                          ),

                          Text(
                            "Estado: ${payment.status}",
                          ),

                          const SizedBox(height: 20),

                              Row(

                                children: [

                                  Expanded(

                                    child: OutlinedButton.icon(

                                      icon: const Icon(
                                        Icons.image,
                                      ),

                                      label: const Text(
                                        "Comprobante",
                                      ),

                                      onPressed: () {

                                        showDialog(

                                          context: context,

                                          builder: (_) {

                                            return Dialog(

                                              child: InteractiveViewer(

                                                child: Image.network(
                                                  payment.receiptUrl,

                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(

                                    child: ElevatedButton.icon(

                                      icon: const Icon(
                                        Icons.check,
                                      ),

                                      label: const Text(
                                        "Aprobar",
                                      ),

                                      style: ElevatedButton.styleFrom(

                                        backgroundColor:
                                        Colors.green,

                                        foregroundColor:
                                        Colors.white,
                                      ),

                                      onPressed: () async {

                                        await _paymentService.approvePayment(
                                          paymentId: payment.id,
                                        );

                                      },
                                    ),
                                  ),
                                ],
                              ),


                              const SizedBox(height: 10),

                              SizedBox(

                                width: double.infinity,

                                child: ElevatedButton.icon(

                                  icon: const Icon(
                                    Icons.close,
                                  ),

                                  label: const Text(
                                    "Rechazar",
                                  ),

                                  style: ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.red,

                                    foregroundColor:
                                    Colors.white,
                                  ),

                                  onPressed: () async {

                                    await _paymentService.rejectPayment(
                                      paymentId: payment.id,
                                      comment: "Comprobante rechazado.",
                                    );

                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    );
                  },
              );
            },
        ),
    );
  }
}