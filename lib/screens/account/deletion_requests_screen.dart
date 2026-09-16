import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeletionRequestsScreen extends StatelessWidget {
  const DeletionRequestsScreen({super.key});

  static const Color azulOscuro = Color(0xff082D6B);
  static const Color azulBoton = Color(0xff0A3B91);
  static const Color rojo = Color(0xffE30613);

  String _formatearFecha(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Fecha no disponible";
    }

    final fecha = timestamp.toDate();

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return "$dia/$mes/$anio $hora:$minuto";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Solicitudes de eliminación",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where(
          "accountDeletionRequested",
          isEqualTo: true,
        )
            .snapshots(),

        builder: (context, snapshot) {
          // ==================================================
          // CARGANDO
          // ==================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: azulBoton,
              ),
            );
          }

          // ==================================================
          // ERROR
          // ==================================================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: rojo,
                      size: 60,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "No se pudieron cargar las solicitudes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          // ==================================================
          // SIN SOLICITUDES
          // ==================================================

          if (docs.isEmpty) {
            return RefreshIndicator(
              color: azulBoton,
              onRefresh: () async {
                await Future.delayed(
                  const Duration(milliseconds: 500),
                );
              },
              child: ListView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height *
                        0.30,
                  ),

                  const Icon(
                    Icons.verified_user_outlined,
                    color: Colors.grey,
                    size: 70,
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "No hay solicitudes pendientes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Las solicitudes de eliminación "
                        "aparecerán aquí.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          // ==================================================
          // ORDENAR POR FECHA
          // ==================================================

          docs.sort((a, b) {
            final fechaA =
            a.data()["accountDeletionRequestedAt"];

            final fechaB =
            b.data()["accountDeletionRequestedAt"];

            if (fechaA is Timestamp &&
                fechaB is Timestamp) {
              return fechaB.compareTo(fechaA);
            }

            return 0;
          });

          // ==================================================
          // LISTA
          // ==================================================

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,

            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final nombre =
              data["name"]?.toString().trim();

              final email =
              data["email"]?.toString().trim();

              final phone =
              data["phone"]?.toString().trim();

              final requestedAt =
              data["accountDeletionRequestedAt"];

              final timestamp =
              requestedAt is Timestamp
                  ? requestedAt
                  : null;

              final nombreMostrar =
              (nombre != null &&
                  nombre.isNotEmpty)
                  ? nombre
                  : "Usuario";

              final emailMostrar =
              (email != null &&
                  email.isNotEmpty)
                  ? email
                  : "Correo no disponible";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(
                  bottom: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // ======================================
                      // ENCABEZADO
                      // ======================================

                      Row(
                        children: [

                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                            rojo.withOpacity(0.10),

                            child: const Icon(
                              Icons.person,
                              color: rojo,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  nombreMostrar,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  emailMostrar,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.orange
                                  .withOpacity(0.12),

                              borderRadius:
                              BorderRadius.circular(20),
                            ),

                            child: const Text(
                              "PENDIENTE",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Divider(),

                      const SizedBox(height: 12),

                      // ======================================
                      // FECHA
                      // ======================================

                      Row(
                        children: [

                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: azulBoton,
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            "Solicitada:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Expanded(
                            child: Text(
                              _formatearFecha(
                                timestamp,
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ======================================
                      // TELÉFONO
                      // ======================================

                      if (phone != null &&
                          phone.isNotEmpty) ...[
                        const SizedBox(height: 10),

                        Row(
                          children: [

                            const Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: azulBoton,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              "Teléfono:",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Expanded(
                              child: Text(
                                phone,
                                style:
                                const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 18),

                      // ======================================
                      // BOTÓN
                      // ======================================

                      SizedBox(
                        width: double.infinity,
                        height: 48,

                        child: ElevatedButton.icon(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            azulBoton,
                            foregroundColor:
                            Colors.white,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),

                          icon: const Icon(
                            Icons.visibility_outlined,
                          ),

                          label: const Text(
                            "VER SOLICITUD",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          onPressed: () {
                            _mostrarDetalles(
                              context,
                              doc.id,
                              data,
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

  // ==========================================================
  // DETALLES
  // ==========================================================

  void _mostrarDetalles(
      BuildContext context,
      String userId,
      Map<String, dynamic> data,
      ) {
    final nombre =
    data["name"]?.toString().trim();

    final email =
    data["email"]?.toString().trim();

    final phone =
    data["phone"]?.toString().trim();

    final timestamp =
    data["accountDeletionRequestedAt"]
    is Timestamp
        ? data["accountDeletionRequestedAt"]
    as Timestamp
        : null;

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Solicitud de eliminación",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                _detalle(
                  "Nombre",
                  (nombre != null &&
                      nombre.isNotEmpty)
                      ? nombre
                      : "No disponible",
                ),

                _detalle(
                  "Correo",
                  (email != null &&
                      email.isNotEmpty)
                      ? email
                      : "No disponible",
                ),

                if (phone != null &&
                    phone.isNotEmpty)
                  _detalle(
                    "Teléfono",
                    phone,
                  ),

                _detalle(
                  "Fecha de solicitud",
                  _formatearFecha(timestamp),
                ),

                _detalle(
                  "UID",
                  userId,
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color:
                    Colors.orange.withOpacity(
                      0.08,
                    ),

                    borderRadius:
                    BorderRadius.circular(12),

                    border: Border.all(
                      color:
                      Colors.orange.withOpacity(
                        0.25,
                      ),
                    ),
                  ),

                  child: const Text(
                    "La solicitud está pendiente "
                        "de procesamiento.",
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  Widget _detalle(
      String titulo,
      String valor,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            titulo,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}