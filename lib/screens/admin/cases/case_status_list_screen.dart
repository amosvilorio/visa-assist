import 'package:flutter/material.dart';

import 'expediente_admin_detail_screen.dart';
import '../../../models/expediente.dart';
import '../../../services/expediente_service.dart';

class CaseStatusListScreen extends StatefulWidget {
  final String status;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const CaseStatusListScreen({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  State<CaseStatusListScreen> createState() =>
      _CaseStatusListScreenState();
}

class _CaseStatusListScreenState
    extends State<CaseStatusListScreen> {

  final ExpedienteService _expedienteService =
  ExpedienteService();

  String search = "";

  //==================================================
  // FILTRAR
  //==================================================

  List<Expediente> _filtrarExpedientes(
      List<Expediente> expedientes,
      ) {
    return expedientes.where((expediente) {

      final id =
      expediente.id.toLowerCase();

      final visa =
      expediente.visaType.toLowerCase();

      final name =
          expediente.applicant?.firstName
              .toLowerCase() ??
              "";

      final lastName =
          expediente.applicant?.lastName
              .toLowerCase() ??
              "";

      return id.contains(search) ||
          visa.contains(search) ||
          name.contains(search) ||
          lastName.contains(search);

    }).toList();
  }

  //==================================================
  // ABRIR EXPEDIENTE
  //==================================================

  void _abrirExpediente(
      BuildContext context,
      Expediente expediente,
      ) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExpedienteAdminDetailScreen(
              expediente: expediente,
            ),
      ),
    );
  }

  //==================================================
  // MOVER A EN PROCESO
  //==================================================

  Future<void> _moverAEnProceso(
      BuildContext context,
      Expediente expediente,
      ) async {

    final confirmar =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text(
            "Mover expediente",
          ),

          content: const Text(
            "Este expediente está completamente preparado.\n\n"
                "¿Deseas moverlo a \"En proceso\"?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                "Mover",
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {

      await _expedienteService
          .moveExpedienteToInProcess(
        expedienteId:
        expediente.id,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Expediente movido a En proceso.",
          ),
        ),
      );

    } catch (e) {

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo mover el expediente: $e",
          ),
        ),
      );
    }
  }

  //==================================================
  // MOVER A TERMINADO
  //==================================================

  Future<void> _moverATerminado(
      BuildContext context,
      Expediente expediente,
      ) async {

    final confirmar =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text(
            "Marcar como terminado",
          ),

          content: const Text(
            "¿Estás seguro de que deseas marcar "
                "este expediente como terminado?\n\n"
                "Esta acción indica que el proceso de visa "
                "ha finalizado.",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                "Cancelar",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                "Terminar",
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {

      await _expedienteService
          .moveExpedienteToCompleted(
        expedienteId:
        expediente.id,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Expediente marcado como terminado.",
          ),
        ),
      );

    } catch (e) {

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo marcar como terminado: $e",
          ),
        ),
      );
    }
  }

  //==================================================
  // TARJETA
  //==================================================

  Widget _buildExpedienteCard(
      BuildContext context,
      Expediente expediente,
      ) {

    final clientName =
    "${expediente.applicant?.firstName ?? ""} "
        "${expediente.applicant?.lastName ?? ""}"
        .trim();

    final nombreCliente =
    clientName.isEmpty
        ? "Sin información"
        : clientName;

    final status =
        expediente.adminProcessStatus;

    return Card(

      margin:
      const EdgeInsets.only(
        bottom: 15,
      ),

      elevation: 4,

      shape:
      RoundedRectangleBorder(
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

            //==================================================
            // ENCABEZADO
            //==================================================

            Row(

              children: [

                CircleAvatar(

                  backgroundColor:
                  widget.color
                      .withOpacity(.12),

                  child: Icon(
                    widget.icon,
                    color: widget.color,
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        expediente.id,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        widget.title,
                        style:
                        TextStyle(
                          color:
                          widget.color,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            //==================================================
            // INFORMACIÓN
            //==================================================

            Text(
              "Cliente: $nombreCliente",
            ),

            Text(
              "Visa: ${expediente.visaType}",
            ),

            Text(
              "Estado: ${expediente.processStatus}",
            ),

            Text(
              "Pago: ${expediente.paymentStatus}",
            ),

            const SizedBox(
              height: 15,
            ),

            //==================================================
            // ESTADOS
            //==================================================

            Wrap(

              spacing: 8,

              runSpacing: 8,

              children: [

                _buildMiniStatus(
                  "DS-160",
                  expediente
                      .visaProcessInformation
                      ?.ds160PdfUrl
                      ?.isNotEmpty ??
                      false,
                ),

                _buildMiniStatus(
                  "Perfil CAS",
                  expediente
                      .casUsername
                      .isNotEmpty &&
                      expediente
                          .casPassword
                          .isNotEmpty,
                ),

                _buildMiniStatus(
                  "Cita CAS",
                  expediente
                      .casAppointmentDate
                      .isNotEmpty &&
                      expediente
                          .casAppointmentTime
                          .isNotEmpty &&
                      expediente
                          .casLocation
                          .isNotEmpty,
                ),

                _buildMiniStatus(
                  "Cita Consular",
                  expediente
                      .interviewDate
                      .isNotEmpty &&
                      expediente
                          .interviewTime
                          .isNotEmpty &&
                      expediente
                          .interviewLocation
                          .isNotEmpty,
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            //==================================================
            // BOTONES
            //==================================================

            Row(

              children: [

                if (status == "en_proceso")
                  Expanded(

                    child:
                    ElevatedButton.icon(

                      onPressed: () {
                        _moverATerminado(
                          context,
                          expediente,
                        );
                      },

                      icon: const Icon(
                        Icons.check_circle_outline,
                      ),

                      label: const Text(
                        "Marcar como terminado",
                      ),

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.green,
                        foregroundColor:
                        Colors.white,
                      ),
                    ),
                  ),

                if (status == "en_proceso")
                  const SizedBox(
                    width: 10,
                  ),

                if (status == "por_completar")
                  Expanded(

                    child:
                    ElevatedButton.icon(

                      onPressed: () {
                        _moverAEnProceso(
                          context,
                          expediente,
                        );
                      },

                      icon: const Icon(
                        Icons.arrow_forward,
                      ),

                      label: const Text(
                        "Mover a En proceso",
                      ),
                    ),
                  ),

                if (status == "por_completar")
                  const SizedBox(
                    width: 10,
                  ),

                OutlinedButton.icon(

                  onPressed: () {
                    _abrirExpediente(
                      context,
                      expediente,
                    );
                  },

                  icon: const Icon(
                    Icons.folder_open,
                  ),

                  label: const Text(
                    "Abrir",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //==================================================
  // MINI ESTADO
  //==================================================

  Widget _buildMiniStatus(
      String title,
      bool completed,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration:
      BoxDecoration(

        color:
        completed
            ? Colors.green
            .withOpacity(.10)
            : Colors.orange
            .withOpacity(.10),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(

        mainAxisSize:
        MainAxisSize.min,

        children: [

          Icon(

            completed
                ? Icons.check_circle
                : Icons.pending,

            size: 16,

            color:
            completed
                ? Colors.green
                : Colors.orange,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(

            title,

            style:
            TextStyle(

              fontSize: 12,

              fontWeight:
              FontWeight.w600,

              color:
              completed
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        Text(widget.title),

        centerTitle: true,
      ),

      body: Column(

        children: [

          //==================================================
          // DESCRIPCIÓN
          //==================================================

          Padding(

            padding:
            const EdgeInsets.fromLTRB(
              20,
              15,
              20,
              5,
            ),

            child: Align(

              alignment:
              Alignment.centerLeft,

              child: Text(

                widget.subtitle,

                style:
                const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          //==================================================
          // BUSCADOR
          //==================================================

          Padding(

            padding:
            const EdgeInsets.all(15),

            child: TextField(

              onChanged: (value) {

                setState(() {

                  search =
                      value
                          .toLowerCase()
                          .trim();

                });
              },

              decoration:
              InputDecoration(

                hintText:
                "Buscar expediente...",

                prefixIcon:
                const Icon(
                  Icons.search,
                ),

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),
            ),
          ),

          //==================================================
          // LISTA
          //==================================================

          Expanded(

            child:
            StreamBuilder<
                List<Expediente>>(
              stream:
              _expedienteService
                  .getAllExpedientes(),

              builder:
                  (context, snapshot) {

                if (snapshot
                    .connectionState ==
                    ConnectionState.waiting) {

                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {

                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                if (!snapshot.hasData) {

                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                final expedientes =
                snapshot.data!
                    .where(
                      (e) =>
                  e.adminProcessStatus ==
                      widget.status,
                )
                    .toList();

                final filtrados =
                _filtrarExpedientes(
                  expedientes,
                );

                if (filtrados.isEmpty) {

                  return Center(

                    child: Column(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        Icon(
                          widget.icon,
                          size: 55,
                          color:
                          widget.color
                              .withOpacity(.35),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          "No hay expedientes aquí.",
                          style:
                          const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(

                  padding:
                  const EdgeInsets.fromLTRB(
                    15,
                    5,
                    15,
                    30,
                  ),

                  itemCount:
                  filtrados.length,

                  itemBuilder:
                      (context, index) {

                    return _buildExpedienteCard(
                      context,
                      filtrados[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}