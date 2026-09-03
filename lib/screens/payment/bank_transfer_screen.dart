import 'package:flutter/material.dart';

import '../../services/settings_service.dart';

class BankTransferScreen extends StatefulWidget {
  final String evaluationId;

  const BankTransferScreen({
    super.key,
    required this.evaluationId,
  });

  @override
  State<BankTransferScreen> createState() =>
      _BankTransferScreenState();
}

class _BankTransferScreenState
    extends State<BankTransferScreen> {

  final SettingsService _settingsService =
  SettingsService();

  bool loading = true;

  Map<String, dynamic> settings = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    settings =
    await _settingsService.getSettings();

    if (!mounted) return;

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

        appBar: AppBar(
          title: const Text(
            "Transferencia Bancaria",
          ),
          centerTitle: true,
        ),

        body: SafeArea(
            child: SingleChildScrollView(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [

                const Icon(
                Icons.account_balance,
                size: 90,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                "Realiza una transferencia o depósito",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Utiliza la siguiente cuenta bancaria para realizar el pago de tu evaluación Premium.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Card(
                elevation: 5,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Padding(

                  padding:
                  const EdgeInsets.all(22),

                  child: Column(

                    children: [

                      dato(
                        "Banco",
                        settings["bankName"] ?? "",
                      ),

                      dato(
                        "Titular",
                        settings["accountHolder"] ?? "",
                      ),

                      dato(
                        "Tipo de cuenta",
                        settings["accountType"] ?? "",
                      ),

                      dato(
                        "Número de cuenta",
                        settings["accountNumber"] ?? "",
                      ),

                      dato(
                        "Monto",
                        "${settings["currencySymbol"] ?? "RD\$"} ${settings["evaluationPrice"] ?? 0}",
                      ),

                    ],

                  ),

                ),

              ),

              const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(18),
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
                            "Una vez realizado el depósito o transferencia, presiona el botón 'Ya realicé el pago' para subir el comprobante. Nuestro equipo verificará el pago y habilitará automáticamente la continuación de tu evaluación.",
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),

                      ],
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text(
                        "YA REALICÉ EL PAGO",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {

                        // Próximo paso:
                        // UploadReceiptScreen

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
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: SelectableText(
              valor,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}