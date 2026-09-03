import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/payment_service.dart';
import '../../utils/app_colors.dart';
import 'payment_review_screen.dart';

class MrvUploadReceiptScreen extends StatefulWidget {
  final String expedienteId;
  final String bankId;
  final String bankName;
  final double amount;
  final String currency;

  const MrvUploadReceiptScreen({
    super.key,
    required this.expedienteId,
    required this.bankId,
    required this.bankName,
    required this.amount,
    required this.currency,
  });

  @override
  State<MrvUploadReceiptScreen> createState() =>
      _MrvUploadReceiptScreenState();
}

class _MrvUploadReceiptScreenState
    extends State<MrvUploadReceiptScreen> {
  final ImagePicker _picker = ImagePicker();

  final PaymentService _paymentService =
  PaymentService();

  final TextEditingController notesController =
  TextEditingController();

  File? receiptImage;

  bool uploading = false;

  // ============================================================
  // SELECCIONAR COMPROBANTE
  // ============================================================

  Future<void> pickImage() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (file == null) return;

      setState(() {
        receiptImage = File(file.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "No se pudo seleccionar la imagen: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // ENVIAR COMPROBANTE
  // ============================================================

  Future<void> _enviarComprobante() async {
    if (receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Selecciona el comprobante del depósito.",
          ),
        ),
      );

      return;
    }

    setState(() {
      uploading = true;
    });

    try {
      await _paymentService.createPayment(
        expedienteId: widget.expedienteId,

        // IMPORTANTE:
        // Este pago corresponde exclusivamente
        // al dinero entregado para gestionar la tarifa MRV.
        paymentType: "mrv",

        receiptImage: receiptImage!,

        amount: widget.amount,

        currency: widget.currency,

        paymentMethod: "Transferencia Bancaria",

        bankId: widget.bankId,

        bankName: widget.bankName,

        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const PaymentReviewScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      String mensaje =
          "No se pudo enviar el comprobante.";

      if (e.toString().contains(
          "Ya existe un pago enviado o aprobado")) {
        mensaje =
        "Ya existe un comprobante enviado para esta tarifa MRV. "
            "Espera la revisión de Visa Assist.";
      } else {
        mensaje = "Error: $e";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(mensaje),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          uploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Comprobante de depósito MRV",
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const Icon(
                Icons.receipt_long,
                size: 80,
                color: AppColors.primary,
              ),

              const SizedBox(height: 15),

              const Text(
                "Sube el comprobante de tu depósito",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Este comprobante corresponde al dinero "
                    "entregado a Visa Assist para gestionar "
                    "el pago oficial de la tarifa MRV.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // INFORMACIÓN DEL DEPÓSITO
              // ==================================================

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      dato(
                        "Banco",
                        widget.bankName,
                      ),

                      dato(
                        "Monto",
                        "${widget.currency} "
                            "${widget.amount.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // SELECCIONAR IMAGEN
              // ==================================================

              InkWell(
                onTap: uploading
                    ? null
                    : pickImage,

                borderRadius:
                BorderRadius.circular(18),

                child: Container(
                  width: double.infinity,
                  height: 230,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(18),

                    border: Border.all(
                      color:
                      Colors.grey.shade400,
                    ),
                  ),

                  child: receiptImage == null
                      ? const Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons
                            .add_photo_alternate,
                        size: 70,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Seleccionar comprobante",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        "Toca aquí para seleccionar "
                            "la imagen de tu depósito",
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
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
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // OBSERVACIÓN
              // ==================================================

              TextField(
                controller: notesController,

                maxLines: 4,

                enabled: !uploading,

                decoration:
                const InputDecoration(
                  labelText:
                  "Observación (Opcional)",

                  hintText:
                  "Puedes agregar alguna información "
                      "sobre el depósito.",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // INFORMACIÓN
              // ==================================================

              Container(
                width: double.infinity,

                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.amber.shade50,

                  borderRadius:
                  BorderRadius.circular(16),
                ),

                child: const Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Asegúrate de que el comprobante "
                            "sea claro y muestre el monto, la "
                            "fecha y los datos de la transferencia "
                            "o depósito.",
                        style: TextStyle(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // VOLVER
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),

                  label: const Text(
                    "VOLVER",
                  ),

                  onPressed: uploading
                      ? null
                      : () {
                    Navigator.pop(context);
                  },
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // ENVIAR
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  icon: uploading
                      ? const SizedBox(
                    width: 22,
                    height: 22,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.cloud_upload,
                  ),

                  label: Text(
                    uploading
                        ? "ENVIANDO..."
                        : "ENVIAR COMPROBANTE",

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  onPressed: uploading
                      ? null
                      : _enviarComprobante,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DATO
  // ============================================================

  Widget dato(
      String titulo,
      String valor,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 14),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 2,

            child: Text(
              titulo,

              style: const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,

            child: SelectableText(
              valor,
            ),
          ),
        ],
      ),
    );
  }
}