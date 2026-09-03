import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../utils/app_colors.dart';
import '../../../models/visa_process_information.dart';
import '../../../models/expediente.dart';
import '../../../services/expediente_service.dart';
import '../../expedientes/expediente_tracking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpedienteAdminDetailScreen extends StatefulWidget {
  final Expediente expediente;

  const ExpedienteAdminDetailScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<ExpedienteAdminDetailScreen> createState() =>
      _ExpedienteAdminDetailScreenState();
}

class _ExpedienteAdminDetailScreenState
    extends State<ExpedienteAdminDetailScreen> {
  final ExpedienteService _service = ExpedienteService();

  bool loading = false;
  bool subiendoDs160 = false;

  static const String _casLugarFijo =
      "Sambil Santo Domingo";

  static const String _casDireccionFija =
      "Av. John F. Kennedy, esquina Paseo Los Aviadores, "
      "Santo Domingo, D.N., República Dominicana";

  static const String _entrevistaLugarFijo =
      "Embajada de los Estados Unidos en Santo Domingo";

  static const String _entrevistaDireccionFija =
      "Av. República de Colombia #57, "
      "Altos de Arroyo Hondo, "
      "Santo Domingo, República Dominicana";

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    final expediente = widget.expediente;

    _casUsernameController.text = expediente.casUsername;

    _casPasswordController.text = expediente.casPassword;

    _casDateController.text =
        expediente.casAppointmentDate;

    _casTimeController.text =
        expediente.casAppointmentTime;

    _casLocationController.text =
        _casDireccionFija;

    _interviewDateController.text =
        expediente.interviewDate;

    _interviewTimeController.text =
        expediente.interviewTime;

    _interviewLocationController.text =
        expediente.interviewLocation;
  }

  final TextEditingController _casUsernameController =
  TextEditingController();

  final TextEditingController _casPasswordController =
  TextEditingController();

  final TextEditingController _casDateController =
  TextEditingController();

  final TextEditingController _casTimeController =
  TextEditingController();

  final TextEditingController _casLocationController =
  TextEditingController();

  final TextEditingController _interviewDateController =
  TextEditingController();

  final TextEditingController _interviewTimeController =
  TextEditingController();

  final TextEditingController _interviewLocationController =
  TextEditingController();

  //==================================================
  // GUARDAR INFORMACIÓN GENERAL
  //==================================================

  Future<void> _guardarVisaProcessInformation() async {
    final information = VisaProcessInformation(
      // CONSERVAR DS-160
      ds160PdfUrl:
      widget.expediente
          .visaProcessInformation
          ?.ds160PdfUrl,

      ds160FileName:
      widget.expediente
          .visaProcessInformation
          ?.ds160FileName,

      // PERFIL CAS
      casUsername:
      _casUsernameController.text,

      casPassword:
      _casPasswordController.text,

      casDate:
      _casDateController.text,

      casTime:
      _casTimeController.text,

      // ENTREVISTA
      interviewDate:
      _interviewDateController.text,

      interviewTime:
      _interviewTimeController.text,

      interviewLocation:
      _interviewLocationController.text,
    );

    await _service.saveVisaProcessInformation(
      expedienteId: widget.expediente.id,
      information: information,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Información guardada correctamente.",
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  //==================================================
  // EDITAR PERFIL CAS
  //==================================================

  Future<void> _editarPerfilCas(
      BuildContext context) async {
    final usuarioController =
    TextEditingController(
      text: _casUsernameController.text,
    );

    final passwordController =
    TextEditingController(
      text: _casPasswordController.text,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        bool guardando = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Editar Perfil CAS",
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usuarioController,
                      decoration:
                      const InputDecoration(
                        labelText: "Usuario CAS",
                        prefixIcon:
                        Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration:
                      const InputDecoration(
                        labelText: "Contraseña CAS",
                        prefixIcon:
                        Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: guardando
                      ? null
                      : () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    "CANCELAR",
                  ),
                ),

                ElevatedButton.icon(
                  icon: guardando
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save),

                  label: Text(
                    guardando
                        ? "GUARDANDO..."
                        : "GUARDAR",
                  ),

                  onPressed: guardando
                      ? null
                      : () async {
                    setDialogState(() {
                      guardando = true;
                    });

                    try {
                      final usuario =
                      usuarioController
                          .text
                          .trim();

                      final password =
                      passwordController
                          .text
                          .trim();

                      await _service
                          .saveVisaProcessInformation(
                        expedienteId:
                        widget.expediente.id,

                        information:
                        VisaProcessInformation(

                          // CONSERVAR DS-160
                          ds160PdfUrl:
                          widget
                              .expediente
                              .visaProcessInformation
                              ?.ds160PdfUrl,

                          ds160FileName:
                          widget
                              .expediente
                              .visaProcessInformation
                              ?.ds160FileName,

                          // PERFIL CAS
                          casUsername:
                          usuario,

                          casPassword:
                          password,

                          casDate:
                          _casDateController
                              .text,

                          casTime:
                          _casTimeController
                              .text,

                          // CONSERVAR ENTREVISTA
                          interviewDate:
                          _interviewDateController
                              .text,

                          interviewTime:
                          _interviewTimeController
                              .text,

                          interviewLocation:
                          _interviewLocationController
                              .text,
                        ),
                      );

                      // ACTUALIZAR ESTADO DEL PERFIL CAS
                      await _service.updateCasStatus(
                        expedienteId:
                        widget.expediente.id,
                        status:
                        "Configurado",
                      );

                      _casUsernameController
                          .text =
                          usuario;

                      _casPasswordController
                          .text =
                          password;

                      if (!mounted) return;

                      Navigator.pop(
                        dialogContext,
                      );

                      await Future.delayed(
                        const Duration(
                          milliseconds: 100,
                        ),
                      );

                      if (!mounted) return;

                      setState(() {});

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Perfil CAS actualizado correctamente.",
                          ),
                          backgroundColor:
                          Colors.green,
                        ),
                      );
                    } catch (e) {
                      setDialogState(() {
                        guardando = false;
                      });

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error al guardar: $e",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      usuarioController.dispose();
      passwordController.dispose();
    });
  }

  //==================================================
  // INICIAR DS-160
  //==================================================

  Future<void> _iniciarDs160() async {
    setState(() {
      loading = true;
    });

    await _service.updateDs160Status(
      expedienteId: widget.expediente.id,
      status: "En proceso",
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  //==================================================
  // SUBIR DS-160
  //==================================================

  Future<void> _subirDs160() async {
    try {
      final resultado =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (resultado == null) {
        return;
      }

      final archivo = resultado.files.single;

      if (archivo.bytes == null) {
        throw Exception(
          "No se pudo leer el archivo seleccionado.",
        );
      }

      setState(() {
        subiendoDs160 = true;
      });

      final nombreArchivo = archivo.name;

      final referencia = FirebaseStorage.instance
          .ref()
          .child("ds160")
          .child(widget.expediente.id)
          .child(nombreArchivo);

      final uploadTask =
      await referencia.putData(
        archivo.bytes!,
        SettableMetadata(
          contentType: "application/pdf",
        ),
      );

      final url =
      await uploadTask.ref.getDownloadURL();

      await _service.saveVisaProcessInformation(
        expedienteId: widget.expediente.id,

        information:
        VisaProcessInformation(

          // NUEVO DS-160
          ds160PdfUrl: url,

          ds160FileName:
          nombreArchivo,

          // CONSERVAR PERFIL CAS
          casUsername:
          _casUsernameController.text,

          casPassword:
          _casPasswordController.text,

          casDate:
          _casDateController.text,

          casTime:
          _casTimeController.text,

          // CONSERVAR ENTREVISTA
          interviewDate:
          _interviewDateController.text,

          interviewTime:
          _interviewTimeController.text,

          interviewLocation:
          _entrevistaDireccionFija,
        ),
      );

      // ACTUALIZAR ESTADO DEL DS-160
      await _service.updateDs160Status(
        expedienteId: widget.expediente.id,
        status: "Disponible",
      );

      if (!mounted) return;

      setState(() {
        subiendoDs160 = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "PDF del DS-160 subido correctamente.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        subiendoDs160 = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al subir el DS-160: $e",
          ),
        ),
      );
    }
  }

  //==================================================
  // EDITAR CITA CAS
  //==================================================

  Future<void> _editarCitaCas(
      BuildContext context) async {
    final fechaController =
    TextEditingController(
      text: _casDateController.text,
    );

    final horaController =
    TextEditingController(
      text: _casTimeController.text,
    );

    bool guardando = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Editar Cita CAS",
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: fechaController,
                      decoration:
                      const InputDecoration(
                        labelText: "Fecha",
                        hintText:
                        "Ejemplo: 15/09/2026",
                        prefixIcon:
                        Icon(Icons.calendar_today),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: horaController,
                      decoration:
                      const InputDecoration(
                        labelText: "Hora",
                        hintText:
                        "Ejemplo: 10:30 AM",
                        prefixIcon:
                        Icon(Icons.access_time),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                        Colors.grey.shade100,
                        borderRadius:
                        BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lugar fijo",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            _casLugarFijo,
                            style: TextStyle(
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            _casDireccionFija,
                            style: TextStyle(
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          OutlinedButton.icon(
                            icon: const Icon(
                              Icons.location_on,
                            ),
                            label: const Text(
                              "VER UBICACIÓN",
                            ),
                            onPressed: () async {
                              final url =
                              Uri.parse(
                                "https://www.google.com/maps/search/?api=1"
                                    "&query=Embajada+de+los+Estados+Unidos"
                                    "+Av+Republica+de+Colombia+57+Santo+Domingo",
                              );

                              if (await canLaunchUrl(
                                url,
                              )) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode
                                      .externalApplication,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: guardando
                      ? null
                      : () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                  const Text("CANCELAR"),
                ),

                ElevatedButton.icon(
                  icon: guardando
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save),

                  label: Text(
                    guardando
                        ? "GUARDANDO..."
                        : "GUARDAR",
                  ),

                  onPressed: guardando
                      ? null
                      : () async {
                    setDialogState(() {
                      guardando = true;
                    });

                    try {
                      final fecha =
                      fechaController
                          .text
                          .trim();

                      final hora =
                      horaController
                          .text
                          .trim();

                      if (fecha.isEmpty ||
                          hora.isEmpty) {
                        setDialogState(() {
                          guardando = false;
                        });

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Ingrese la fecha y la hora de la cita.",
                            ),
                          ),
                        );

                        return;
                      }

                      await _service
                          .updateCasAppointment(
                        expedienteId:
                        widget.expediente.id,
                        date: fecha,
                        time: hora,
                        location:
                        _casDireccionFija,
                      );

                      _casDateController
                          .text = fecha;

                      _casTimeController
                          .text = hora;

                      _casLocationController
                          .text =
                          _casDireccionFija;

                      if (!mounted) return;

                      Navigator.pop(
                        dialogContext,
                        true,
                      );

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Cita CAS actualizada correctamente.",
                          ),
                          backgroundColor:
                          Colors.green,
                        ),
                      );
                    } catch (e) {
                      setDialogState(() {
                        guardando = false;
                      });

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error al guardar: $e",
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      fechaController.dispose();
      horaController.dispose();
    });
  }

  //==================================================
  // EDITAR ENTREVISTA CONSULAR
  //==================================================

  Future<void> _editarEntrevistaConsular(
      BuildContext context) async {
    final fechaController =
    TextEditingController(
      text: _interviewDateController.text,
    );

    final horaController =
    TextEditingController(
      text: _interviewTimeController.text,
    );

    String fechaGuardada =
        _interviewDateController.text;

    String horaGuardada =
        _interviewTimeController.text;

    final resultado =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Editar Entrevista Consular",
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fechaController,
                  decoration:
                  const InputDecoration(
                    labelText: "Fecha",
                    hintText:
                    "Ejemplo: 20/09/2026",
                    prefixIcon:
                    Icon(Icons.calendar_today),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: horaController,
                  decoration:
                  const InputDecoration(
                    labelText: "Hora",
                    hintText:
                    "Ejemplo: 9:00 AM",
                    prefixIcon:
                    Icon(Icons.access_time),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lugar fijo",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        _entrevistaLugarFijo,
                        style: TextStyle(
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        _entrevistaDireccionFija,
                        style: TextStyle(
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 12),

                      OutlinedButton.icon(
                        icon: const Icon(
                          Icons.location_on,
                        ),
                        label: const Text(
                          "VER UBICACIÓN",
                        ),
                        onPressed: () async {
                          final url =
                          Uri.parse(
                            "https://www.google.com/maps/search/?api=1"
                                "&query=Embajada+de+los+Estados+Unidos"
                                "+Av+Republica+de+Colombia+57"
                                "+Altos+de+Arroyo+Hondo"
                                "+Santo+Domingo",
                          );

                          await launchUrl(
                            url,
                            mode: LaunchMode
                                .externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child:
              const Text("CANCELAR"),
            ),

            ElevatedButton.icon(
              icon: const Icon(
                Icons.save,
              ),

              label: const Text(
                "GUARDAR",
              ),

              onPressed: () async {
                final fecha =
                fechaController.text.trim();

                final hora =
                horaController.text.trim();

                if (fecha.isEmpty ||
                    hora.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Ingrese la fecha y la hora de la cita.",
                      ),
                    ),
                  );

                  return;
                }

                try {
                  // CONSERVAR TODO LO EXISTENTE
                  await _service
                      .saveVisaProcessInformation(
                    expedienteId:
                    widget.expediente.id,

                    information:
                    VisaProcessInformation(

                      // CONSERVAR DS-160
                      ds160PdfUrl:
                      widget
                          .expediente
                          .visaProcessInformation
                          ?.ds160PdfUrl,

                      ds160FileName:
                      widget
                          .expediente
                          .visaProcessInformation
                          ?.ds160FileName,

                      // CONSERVAR PERFIL CAS
                      casUsername:
                      _casUsernameController
                          .text,

                      casPassword:
                      _casPasswordController
                          .text,

                      casDate:
                      _casDateController.text,

                      casTime:
                      _casTimeController.text,

                      // ACTUALIZAR ENTREVISTA
                      interviewDate:
                      fecha,

                      interviewTime:
                      hora,

                      interviewLocation:
                      _entrevistaDireccionFija,
                    ),
                  );

                  fechaGuardada = fecha;
                  horaGuardada = hora;

                  if (!dialogContext.mounted) {
                    return;
                  }

                  Navigator.of(
                    dialogContext,
                  ).pop(true);
                } catch (e) {
                  if (!dialogContext.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Error al guardar: $e",
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      fechaController.dispose();
      horaController.dispose();
    });

    if (resultado == true && mounted) {
      setState(() {
        _interviewDateController.text =
            fechaGuardada;

        _interviewTimeController.text =
            horaGuardada;

        _interviewLocationController.text =
            _entrevistaDireccionFija;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Entrevista Consular actualizada correctamente.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {
    final expediente = widget.expediente;
    final applicant = expediente.applicant;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalle del Expediente",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            _card(
              icon: Icons.person,
              title: "Información del cliente",
              children: [
                _item(
                  "Nombre",
                  applicant == null
                      ? "Sin información"
                      : "${applicant.firstName} "
                      "${applicant.lastName}",
                ),

                _item(
                  "Tipo de visa",
                  expediente.visaType,
                ),

                _item(
                  "País",
                  expediente.countryCode,
                ),

                _item(
                  "Expediente",
                  expediente.id,
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.description,
                    ),

                    label: const Text(
                      "VER EXPEDIENTE COMPLETO",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ExpedienteTrackingScreen(
                                expediente:
                                expediente,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _card(
              icon: Icons.assignment,
              title: "Estado del proceso",
              children: [
                _item(
                  "Estado",
                  expediente.processStatus,
                ),

                _item(
                  "Pago",
                  expediente.paymentStatus,
                ),

                _item(
                  "DS-160",
                  expediente.ds160Status,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _card(
              icon: Icons.fact_check,
              title: "Resultado de la entrevista",
              children: [
                _item(
                  "Resultado",
                  expediente.finalDecision.isEmpty
                      ? "Pendiente"
                      : expediente.finalDecision,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _card(
              icon: Icons.lock,
              title: "Perfil CAS",
              children: [
                _item(
                  "Usuario CAS",
                  _casUsernameController
                      .text
                      .isEmpty
                      ? "No registrado"
                      : _casUsernameController
                      .text,
                ),

                _item(
                  "Contraseña CAS",
                  "************",
                ),

                Align(
                  alignment:
                  Alignment.centerRight,
                  child:
                  OutlinedButton.icon(
                    icon:
                    const Icon(Icons.edit),
                    label:
                    const Text("EDITAR"),
                    onPressed: () {
                      _editarPerfilCas(
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                _appointmentCard(
                  icon:
                  Icons.fingerprint,
                  title:
                  "Cita CAS (Huella y foto)",
                  date:
                  _casDateController.text,
                  time:
                  _casTimeController.text,
                  location:
                  _casDireccionFija,
                  onEdit: () {
                    _editarCitaCas(
                      context,
                    );
                  },
                ),

                const SizedBox(height: 20),

                _appointmentCard(
                  icon:
                  Icons.account_balance,
                  title:
                  "Entrevista Consular",
                  date:
                  _interviewDateController
                      .text,
                  time:
                  _interviewTimeController
                      .text,
                  location:
                  _entrevistaDireccionFija,
                  onEdit: () {
                    _editarEntrevistaConsular(
                      context,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            _card(
              icon: Icons.description,
              title: "Proceso DS-160",
              children: [
                _item(
                  "Estado actual",
                  expediente.ds160Status,
                ),

                _item(
                  "Documento",
                  expediente
                      .visaProcessInformation
                      ?.ds160FileName ??
                      "No se ha subido el DS-160",
                ),

                const SizedBox(height: 10),

                if (expediente
                    .visaProcessInformation
                    ?.ds160PdfUrl !=
                    null)
                  SizedBox(
                    width: double.infinity,
                    child:
                    OutlinedButton.icon(
                      icon: const Icon(
                        Icons.picture_as_pdf,
                      ),

                      label: const Text(
                        "VER DS-160",
                      ),

                      onPressed: () async {
                        final url = Uri.parse(
                          expediente
                              .visaProcessInformation!
                              .ds160PdfUrl!,
                        );

                        if (await canLaunchUrl(
                          url,
                        )) {
                          await launchUrl(
                            url,
                            mode: LaunchMode
                                .externalApplication,
                          );
                        }
                      },
                    ),
                  ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child:
                  ElevatedButton.icon(
                    icon: subiendoDs160
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                        Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.upload_file,
                    ),

                    label: Text(
                      subiendoDs160
                          ? "SUBIENDO PDF..."
                          : "SUBIR PDF DS-160",
                    ),

                    onPressed:
                    subiendoDs160
                        ? null
                        : _subirDs160,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.save,
                ),

                label: const Text(
                  "GUARDAR INFORMACIÓN",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                onPressed:
                _guardarVisaProcessInformation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==================================================
  // CARD
  //==================================================

  Widget _card({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,

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
            Row(
              children: [
                Icon(
                  icon,
                  color:
                  AppColors.primary,
                ),

                const SizedBox(width: 12),

                Text(
                  title,
                  style:
                  const TextStyle(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ...children,
          ],
        ),
      ),
    );
  }

  //==================================================
  // ITEM
  //==================================================

  Widget _item(
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(
              "$label:",
              style:
              const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty
                  ? "No registrado"
                  : value,
            ),
          ),
        ],
      ),
    );
  }

  //==================================================
  // APPOINTMENT CARD
  //==================================================

  Widget _appointmentCard({
    required IconData icon,
    required String title,
    required String date,
    required String time,
    required String location,
    required VoidCallback onEdit,
  }) {
    return Card(
      elevation: 2,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color:
                  AppColors.primary,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    title,
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _item(
              "Fecha",
              date,
            ),

            _item(
              "Hora",
              time,
            ),

            _item(
              "Lugar",
              location,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child:
              OutlinedButton.icon(
                icon: const Icon(
                  Icons.edit,
                ),

                label: const Text(
                  "EDITAR",
                ),

                onPressed: onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}