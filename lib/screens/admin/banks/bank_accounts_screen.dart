import 'package:flutter/material.dart';

import '../../../models/bank_account.dart';
import '../../../services/bank_service.dart';
import 'add_edit_bank_screen.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() =>
      _BankAccountsScreenState();
}

class _BankAccountsScreenState
    extends State<BankAccountsScreen> {

  final BankService _bankService =
  BankService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: const Text(
            "Cuentas Bancarias",
          ),

          centerTitle: true,

        ),

        floatingActionButton:
        FloatingActionButton.extended(

          icon: const Icon(Icons.add),

          label: const Text("Agregar"),

          onPressed: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) =>
                const AddEditBankScreen(),

              ),

            );

          },

        ),

        body: StreamBuilder<List<BankAccount>>(

            stream: _bankService.watchBanks(),

            builder: (context, snapshot) {

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {

                return const Center(

                  child:
                  CircularProgressIndicator(),

                );

              }

              if (!snapshot.hasData ||
                  snapshot.data!.isEmpty) {

                return const Center(

                  child: Text(
                    "No hay cuentas bancarias registradas.",
                  ),

                );

              }

              final banks = snapshot.data!;

              return ListView.builder(

                  padding:
                  const EdgeInsets.all(15),

                  itemCount: banks.length,

                  itemBuilder: (context, index) {

                    final bank = banks[index];

                    return Card(

                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),

                        elevation: 4,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(
                              18),

                        ),

                        child: ListTile(

                            leading: CircleAvatar(

                              backgroundColor:
                              Colors.blue.shade100,

                              child: const Icon(
                                Icons.account_balance,
                              ),

                            ),

                            title: Text(

                              bank.bankName,

                              style: const TextStyle(

                                fontWeight:
                                FontWeight.bold,

                              ),

                            ),

                            subtitle: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                const SizedBox(
                                    height: 5),

                                Text(
                                  "Titular: ${bank.accountHolder}",
                                ),

                                Text(
                                  "Cuenta: ${bank.accountNumber}",
                                ),

                                Text(
                                  "Tipo: ${bank.accountType}",
                                ),

                                Text(
                                  "Moneda: ${bank.currency}",
                                ),

                                Text(

                                  bank.enabled
                                      ? "Estado: Activa"
                                      : "Estado: Inactiva",

                                  style: TextStyle(

                                    color: bank.enabled
                                        ? Colors.green
                                        : Colors.red,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),

                              ],

                            ),

                            trailing:
                            PopupMenuButton<String>(

                                onSelected: (value) async {

                                  if (value == "edit") {

                                    Navigator.push(

                                      context,

                                      MaterialPageRoute(

                                        builder: (_) =>
                                            AddEditBankScreen(

                                              bankId: bank.id,

                                              bank: bank,

                                            ),

                                      ),

                                    );

                                  }

                                  if (value == "enable") {

                                    await _bankService.setEnabled(

                                      bankId: bank.id,

                                      enabled: !bank.enabled,

                                    );

                                  }

                                  if (value == "delete") {

                                    await _deleteBank(bank);

                                  }

                                },

                                itemBuilder: (_) => [

                                  const PopupMenuItem(

                                    value: "edit",

                                    child: Text("Editar"),

                                  ),

                                  PopupMenuItem(

                                    value: "enable",

                                    child: Text(

                                      bank.enabled
                                          ? "Desactivar"
                                          : "Activar",

                                    ),

                                  ),

                                  const PopupMenuItem(

                                    value: "delete",

                                    child: Text("Eliminar"),

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

  Future<void> _deleteBank(
      BankAccount bank,
      ) async {

    final confirmar =
    await showDialog<bool>(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text(
          "Eliminar Banco",
        ),

        content: Text(
          "¿Deseas eliminar ${bank.bankName}?",
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
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
                context,
                true,
              );

            },

            child: const Text(
              "Eliminar",
            ),

          ),

        ],

      ),

    );

    if (confirmar != true) return;

    await _bankService.deleteBank(
      bank.id,
    );
  }

}