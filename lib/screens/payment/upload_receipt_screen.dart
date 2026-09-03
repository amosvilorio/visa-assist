import 'dart:io';
import 'payment_pending_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/payment_service.dart';
import '../../services/settings_service.dart';
import '../../services/evaluation_service.dart';

class UploadReceiptScreen extends StatefulWidget {

  final String evaluationId;

  const UploadReceiptScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  State<UploadReceiptScreen> createState() =>
      _UploadReceiptScreenState();
}

class _UploadReceiptScreenState
    extends State<UploadReceiptScreen> {

  final ImagePicker _picker = ImagePicker();

  File? receiptImage;

  final TextEditingController notesController =
  TextEditingController();

  bool uploading = false;

  final PaymentService _paymentService =
  PaymentService();

  final SettingsService _settingsService =
  SettingsService();

  final EvaluationService _evaluationService =
  EvaluationService();

  Future<void> pickImage() async {

    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      receiptImage = File(file.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Subir Comprobante"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                const Icon(
                Icons.receipt_long,
                size: 90,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                "Sube el comprobante de pago",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Nuestro equipo verificará el depósito o transferencia. Una vez aprobado podrás continuar tu evaluación desde la pregunta 11.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              InkWell(
                onTap: pickImage,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: receiptImage == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.add_photo_alternate,
                        size: 70,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Seleccionar comprobante",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius:
                    BorderRadius.circular(18),
                    child: Image.file(
                      receiptImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Observación (opcional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        "VOLVER",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: uploading
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      icon: uploading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.cloud_upload),
                      label: Text(
                        uploading
                            ? "ENVIANDO..."
                            : "ENVIAR COMPROBANTE",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: uploading
                          ? null
                          : () async {

                        if (uploading) {
                          return;
                        }

                        setState(() {
                          uploading = true;
                        });

                        if (receiptImage == null) {

                          setState(() {
                            uploading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Debes seleccionar el comprobante.",
                              ),
                            ),
                          );

                          return;
                        }



                        try {

                          final settings =
                          await _settingsService.getSettings();

                          final double amount =
                          (settings["evaluationPrice"] ?? 0)
                              .toDouble();

                          final String currency =
                              settings["currency"] ?? "DOP";

                          await _paymentService.createPayment(

                            bankId: "evaluation",

                            bankName: "Transferencia Bancaria",

                            expedienteId: widget.evaluationId,

                            paymentType: "evaluation",

                            receiptImage: receiptImage!,

                            amount: amount,

                            currency: currency,

                            paymentMethod: "Transferencia Bancaria",

                            notes: notesController.text.trim(),

                          );

                          await _evaluationService.waitingPayment(
                            widget.evaluationId,
                          );

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(

                            const SnackBar(

                              content: Text(
                                "Comprobante enviado correctamente.",
                              ),

                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushAndRemoveUntil(

                            context,

                            MaterialPageRoute(

                              builder: (_) => PaymentPendingScreen(
                                evaluationId: widget.evaluationId,
                              ),

                            ),

                                (route) => false,

                          );

                        } catch (e) {

                          ScaffoldMessenger.of(context).showSnackBar(

                            SnackBar(

                              content: Text(
                                "Error: $e",
                              ),

                              backgroundColor: Colors.red,
                            ),
                          );

                        } finally {

                          if (mounted) {

                            setState(() {

                              uploading = false;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
        ),
    );
  }
}