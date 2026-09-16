import 'package:flutter/material.dart';

import '../../services/expediente_service.dart';
import '../../models/bank_account.dart';
import '../../services/bank_service.dart';
import '../../services/settings_service.dart';
import '../../utils/app_colors.dart';
import 'service_upload_receipt_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String paymentType;

  final String paymentTitle;

  final double amount;

  final String currencySymbol;

  final String expedienteId;

  const PaymentMethodScreen({
    super.key,
    required this.paymentType,
    required this.paymentTitle,
    required this.amount,
    required this.currencySymbol,
    required this.expedienteId,
  });

  @override
  State<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState
    extends State<PaymentMethodScreen> {
  final ExpedienteService _expedienteService =
  ExpedienteService();

  final BankService _bankService =
  BankService();

  final SettingsService _settingsService =
  SettingsService();

  bool loading = true;

  double usdToDopRate = 0.0;

  //==================================================
  // VISA ASSIST UTILIZA SIEMPRE USD
  //==================================================

  bool get isServicePayment =>
      widget.paymentType == "service";

  String _formatMoney(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final integerPart = parts[0];

    final formattedInteger =
    integerPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );

    return "$formattedInteger.${parts[1]}";
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final settings = await _settingsService.getSettings();

      if (!mounted) return;

      setState(() {
        usdToDopRate =
            double.tryParse(
              settings["usdToDopRate"]?.toString() ?? "",
            ) ??
                0.0;

        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        usdToDopRate = 0.0;
        loading = false;
      });
    }
  }

  //==================================================
  // TARJETA BANCARIA
  //==================================================

  Widget bankCard(BankAccount bank) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    bank.bankName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(
              height: 30,
            ),

            dato(
              "Titular",
              bank.accountHolder,
            ),

            dato(
              "Tipo",
              bank.accountType,
            ),

            dato(
              "Cuenta",
              bank.accountNumber,
            ),

            dato(
              "Moneda",
              bank.currency,
            ),

            const SizedBox(
              height: 25,
            ),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                ),
                label: const Text(
                  "SUBIR COMPROBANTE DE PAGO",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  foregroundColor:
                  Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ServiceUploadReceiptScreen(
                            bankId: bank.id,

                            bankName:
                            bank.bankName,

                            //================================
                            // VISA ASSIST = USD
                            // EVALUACIÓN = MONEDA ACTUAL
                            //================================
                            currency: isServicePayment
                                ? bank.currency.trim().toUpperCase()
                                : bank.currency,

                            amount: isServicePayment &&
                                bank.currency.trim().toUpperCase() == "DOP"
                                ? widget.amount * usdToDopRate
                                : widget.amount,

                            expedienteId:
                            widget.expedienteId,

                            paymentType:
                            widget.paymentType,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==================================================
  // DATO
  //==================================================

  Widget dato(
      String titulo,
      String valor,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
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

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      AppColors.background,

      appBar: AppBar(
        title: Text(
          widget.paymentTitle,
        ),
      ),

      body:
      StreamBuilder<List<BankAccount>>(
        stream:
        _bankService.watchBanks(
          onlyEnabled: true,
        ),

        builder:
            (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          //================================================
          // CUENTAS DISPONIBLES
          //
          // VISA ASSIST:
          // SOLO CUENTAS USD
          //
          // EVALUACIÓN:
          // TODAS LAS CUENTAS ACTIVAS
          //================================================

          final allBanks =
          snapshot.data!;

          final banks =
          isServicePayment
              ? allBanks
              .where(
                (bank) {
              final currency =
              bank.currency.trim().toUpperCase();

              return currency == "USD" ||
                  currency == "DOP";
            },
          )
              .toList()
              : allBanks;

          return ListView(
            padding:
            const EdgeInsets.all(20),

            children: [
              Text(
                widget.paymentTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                isServicePayment
                    ? "Realiza el depósito utilizando una de las cuentas bancarias disponibles."
                    : "Realiza la transferencia utilizando cualquiera de las siguientes cuentas bancarias disponibles.",
                style: const TextStyle(
                  color:
                  AppColors.textSecondary,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              //================================================
              // COSTO
              //================================================

              Card(
                color:
                AppColors.primary,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    25,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Costo del pago",
                        style: TextStyle(
                          color:
                          Colors.white70,
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      if (isServicePayment) ...[
                        Text(
                          "US\$ ${widget.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (usdToDopRate > 0) ...[
                          const SizedBox(height: 8),

                          Text(
                            "RD\$ ${_formatMoney(widget.amount * usdToDopRate)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ] else
                        Text(
                          "${widget.currencySymbol} ${widget.amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Card(
                color:
                Colors.green.shade50,
                child: const Padding(
                  padding:
                  EdgeInsets.all(18),
                  child: Text(
                    "Después de completar el pago, sube el comprobante para que nuestro equipo pueda verificarlo.",
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              const Text(
                "Cuentas Bancarias Disponibles",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //================================================
              // SIN CUENTAS
              //================================================

              if (banks.isEmpty)
                Card(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(
                      25,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons
                              .account_balance_outlined,
                          size: 70,
                          color:
                          Colors.grey,
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          isServicePayment
                              ? "No hay cuentas bancarias en USD disponibles para realizar el pago de Visa Assist."
                              : "No hay cuentas bancarias disponibles.",
                          textAlign:
                          TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )

              //================================================
              // CUENTAS
              //================================================

              else
                ...banks.map(
                  bankCard,
                ),

              const SizedBox(
                height: 25,
              ),

              Container(
                padding:
                const EdgeInsets.all(18),
                decoration:
                BoxDecoration(
                  color:
                  Colors.amber.shade50,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
                child: Text(
                  isServicePayment
                      ? "Nuestro equipo verificará el comprobante y confirmará el pago antes de iniciar el proceso correspondiente."
                      : "Nuestro equipo verificará el comprobante antes de iniciar el proceso correspondiente.",
                  style:
                  const TextStyle(
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          );
        },
      ),
    );
  }
}