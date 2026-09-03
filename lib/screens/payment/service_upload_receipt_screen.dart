import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'payment_review_screen.dart';
import '../../services/payment_service.dart';
import '../../utils/app_colors.dart';

class ServiceUploadReceiptScreen extends StatefulWidget {

  final String expedienteId;

  final String bankId;

  final String bankName;

  final double amount;

  final String paymentType;

  final String currency;

  const ServiceUploadReceiptScreen({

    super.key,

    required this.expedienteId,

    required this.bankId,

    required this.bankName,

    required this.amount,

    required this.paymentType,

    required this.currency,

  });

  @override
  State<ServiceUploadReceiptScreen> createState() =>
      _ServiceUploadReceiptScreenState();
}

class _ServiceUploadReceiptScreenState
    extends State<ServiceUploadReceiptScreen> {

  final ImagePicker _picker =
  ImagePicker();

  final PaymentService _paymentService =
  PaymentService();

  File? receiptImage;

  final notesController =
  TextEditingController();

  bool uploading = false;

  Future<void> pickImage() async {

    final file =
    await _picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 80,

    );

    if (file == null) return;

    setState(() {

      receiptImage =
          File(file.path);

    });

  }

  @override
  void dispose() {

    notesController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor:
        AppColors.background,

        appBar: AppBar(

          title: const Text(
            "Comprobante del Servicio",
          ),

        ),

        body: SafeArea(

            child: SingleChildScrollView(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                children: [

                const Icon(

                Icons.receipt_long,

                size: 90,

                color: Colors.green,

              ),

              const SizedBox(height: 20),

              const Text(

                "Sube el comprobante de tu pago",

                textAlign:
                TextAlign.center,

                style: TextStyle(

                  fontSize: 27,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),

              const SizedBox(height: 20),

              Card(

                shape: RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(18),

                ),

                child: Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Column(

                    children: [

                      dato(
                        "Banco",
                        widget.bankName,
                      ),

                      dato(
                        "Monto",
                        "${widget.currency} ${widget.amount}",
                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 25),

              InkWell(

                onTap: pickImage,

                borderRadius:
                BorderRadius.circular(18),

                child: Container(

                  width: double.infinity,

                  height: 220,

                  decoration: BoxDecoration(

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

                    ),

                  ),

                ),

              ),

              const SizedBox(height: 25),

              TextField(

                controller:
                notesController,

                maxLines: 4,

                decoration:
                const InputDecoration(

                  labelText:
                  "Observación (Opcional)",

                  border:
                  OutlineInputBorder(),

                ),

              ),

                  const SizedBox(height: 30),

                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child: OutlinedButton.icon(

                      icon: const Icon(Icons.arrow_back),

                      label: const Text("VOLVER"),

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

                        if (receiptImage == null) {

                          ScaffoldMessenger.of(context)

                              .showSnackBar(

                            const SnackBar(

                              content: Text(

                                "Selecciona el comprobante.",

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

                            expedienteId:
                            widget.expedienteId,

                            paymentType:
                            widget.paymentType,

                            receiptImage:
                            receiptImage!,

                            amount:
                            widget.amount,

                            currency:
                            widget.currency,

                            paymentMethod:
                            "Transferencia Bancaria",

                            bankId:
                            widget.bankId,

                            bankName:
                            widget.bankName,

                            notes:
                            notesController.text.trim(),

                          );

                          if (!mounted) return;

                          Navigator.pushReplacement(

                            context,

                            MaterialPageRoute(

                              builder: (_) => const PaymentReviewScreen(),

                            ),

                          );

                        } catch (e) {

                          if (!mounted) return;

                          ScaffoldMessenger.of(context)

                              .showSnackBar(

                            SnackBar(

                              backgroundColor:
                              Colors.red,

                              content: Text(

                                e.toString().contains(
                                    "Ya existe un pago enviado o aprobado"
                                )
                                    ? "Ya existe un pago enviado. Espera la revisión del equipo."
                                    : "Error: $e",

                              ),

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

  Widget dato(
      String titulo,
      String valor,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 14),

      child: Row(

        children: [

          Expanded(

            flex: 2,

            child: Text(

              titulo,

              style: const TextStyle(

                fontWeight: FontWeight.bold,

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