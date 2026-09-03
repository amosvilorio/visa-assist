import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/bank_account.dart';
import '../../../services/bank_service.dart';

class AddEditBankScreen extends StatefulWidget {
  final String? bankId;

  final BankAccount? bank;

  const AddEditBankScreen({
    super.key,
    this.bankId,
    this.bank,
  });

  @override
  State<AddEditBankScreen> createState() =>
      _AddEditBankScreenState();
}

class _AddEditBankScreenState
    extends State<AddEditBankScreen> {

  final BankService _bankService =
  BankService();

  final _formKey =
  GlobalKey<FormState>();

  final bankNameController =
  TextEditingController();

  final holderController =
  TextEditingController();

  final accountController =
  TextEditingController();

  bool enabled = true;

  String accountType = "Ahorros";

  String currency = "DOP";

  bool saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.bank != null) {

      bankNameController.text =
          widget.bank!.bankName;

      holderController.text =
          widget.bank!.accountHolder;

      accountController.text =
          widget.bank!.accountNumber;

      accountType =
          widget.bank!.accountType;

      currency =
          widget.bank!.currency;

      enabled =
          widget.bank!.enabled;

    }
  }

  @override
  void dispose() {

    bankNameController.dispose();

    holderController.dispose();

    accountController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: Text(

            widget.bank == null
                ? "Agregar Banco"
                : "Editar Banco",

          ),

          centerTitle: true,

        ),

        body: Form(

            key: _formKey,

            child: SingleChildScrollView(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [

                TextFormField(

                controller:
                bankNameController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Nombre del Banco",

                  border:
                  OutlineInputBorder(),

                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Ingrese el nombre del banco";

                  }

                  return null;

                },

              ),

              const SizedBox(height: 20),

              TextFormField(

                controller:
                holderController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Titular",

                  border:
                  OutlineInputBorder(),

                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Ingrese el titular";

                  }

                  return null;

                },

              ),

              const SizedBox(height: 20),

              TextFormField(

                controller:
                accountController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Número de Cuenta",

                  border:
                  OutlineInputBorder(),

                ),

                validator: (value) {

                  if (value == null ||
                      value.trim().isEmpty) {

                    return "Ingrese el número de cuenta";

                  }

                  return null;

                },

              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(

                value: accountType,

                decoration:
                const InputDecoration(

                  labelText:
                  "Tipo de Cuenta",

                  border:
                  OutlineInputBorder(),

                ),

                items: const [

                  DropdownMenuItem(
                    value: "Ahorros",
                    child: Text("Ahorros"),
                  ),

                  DropdownMenuItem(
                    value: "Corriente",
                    child: Text("Corriente"),
                  ),

                ],

                onChanged: (value) {

                  if (value == null) return;

                  setState(() {

                    accountType = value;

                  });

                },

              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(

                value: currency,

                decoration:
                const InputDecoration(

                  labelText:
                  "Moneda",

                  border:
                  OutlineInputBorder(),

                ),

                items: const [

                  DropdownMenuItem(
                    value: "DOP",
                    child: Text("Peso Dominicano"),
                  ),

                  DropdownMenuItem(
                    value: "USD",
                    child: Text("Dólar Americano"),
                  ),

                  DropdownMenuItem(
                    value: "EUR",
                    child: Text("Euro"),
                  ),

                ],

                onChanged: (value) {

                  if (value == null) return;

                  setState(() {

                    currency = value;

                  });

                },

              ),

              const SizedBox(height: 20),

              SwitchListTile(

                value: enabled,

                title: const Text(
                  "Cuenta Activa",
                ),

                onChanged: (value) {

                  setState(() {

                    enabled = value;

                  });

                },

              ),

              const SizedBox(height: 35),

                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(

                      onPressed: saving
                          ? null
                          : () async {

                        if (!_formKey.currentState!
                            .validate()) {
                          return;
                        }

                        setState(() {
                          saving = true;
                        });

                        try {

                          final now =
                          DateTime.now();

                          final bank = BankAccount(

                            id: widget.bankId ??
                                FirebaseFirestore
                                    .instance
                                    .collection(
                                    "bank_accounts")
                                    .doc()
                                    .id,

                            bankName:
                            bankNameController.text
                                .trim(),

                            accountHolder:
                            holderController.text
                                .trim(),

                            accountType:
                            accountType,

                            accountNumber:
                            accountController.text
                                .trim(),

                            currency: currency,

                            enabled: enabled,

                            order: widget.bank?.order ??
                                0,

                            createdAt:
                            widget.bank
                                ?.createdAt ??
                                now,

                            updatedAt: now,

                          );

                          if (widget.bank == null) {

                            await _bankService
                                .createBank(
                                bank);

                          } else {

                            await _bankService
                                .updateBank(
                                bank);

                          }

                          if (!mounted) return;

                          Navigator.pop(context);

                        } catch (e) {

                          if (!mounted) return;

                          ScaffoldMessenger.of(
                              context)
                              .showSnackBar(

                            SnackBar(
                              content: Text(
                                "Error: $e",
                              ),
                            ),

                          );

                        } finally {

                          if (mounted) {

                            setState(() {

                              saving = false;

                            });

                          }

                        }

                      },

                      child: saving

                          ? const SizedBox(

                        width: 24,

                        height: 24,

                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),

                      )

                          : Text(

                        widget.bank == null
                            ? "GUARDAR BANCO"
                            : "ACTUALIZAR BANCO",

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

        ),

    );

  }

}