import 'package:flutter/material.dart';

import '../../services/expediente_service.dart';
import '../../models/bank_account.dart';
import '../../services/bank_service.dart';
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


  bool loading = true;



  @override
  void initState() {

    super.initState();

    loadData();

  }



  Future<void> loadData() async {


    if (!mounted) return;


    setState(() {

      loading = false;

    });

  }




  Widget bankCard(BankAccount bank) {


    return Card(

      margin:
      const EdgeInsets.only(
        bottom: 18,
      ),


      elevation: 3,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(18),

      ),



      child:
      Padding(

        padding:
        const EdgeInsets.all(20),


        child:
        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Row(

              children: [


                const Icon(

                  Icons.account_balance,

                  color:
                  AppColors.primary,

                ),


                const SizedBox(
                  width: 10,
                ),



                Expanded(

                  child: Text(

                    bank.bankName,

                    style:
                    const TextStyle(

                      fontSize:
                      20,

                      fontWeight:
                      FontWeight.bold,

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

              width:
              double.infinity,


              height:
              58,


              child:
              ElevatedButton.icon(


                icon:
                const Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                ),


                label:
                const Text(
                  "SUBIR COMPROBANTE DE PAGO",
                ),



                style:
                ElevatedButton.styleFrom(

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

                            bankId:
                            bank.id,


                            bankName:
                            bank.bankName,


                            currency:
                            bank.currency,


                            amount:
                            widget.amount,


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

  Widget dato(
      String titulo,
      String valor,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 14),

      child:
      Row(

        children: [


          Expanded(

            flex:
            2,


            child:
            Text(

              titulo,

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),



          Expanded(

            flex:
            3,


            child:
            SelectableText(
              valor,
            ),

          ),


        ],

      ),

    );

  }





  @override
  Widget build(BuildContext context) {


    if (loading) {


      return const Scaffold(

        body:
        Center(

          child:
          CircularProgressIndicator(),

        ),

      );

    }



    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar:
      AppBar(

        title:
        Text(
          widget.paymentTitle,
        ),

      ),




      body:
      StreamBuilder<List<BankAccount>>(


        stream:
        _bankService.watchBanks(

          onlyEnabled:
          true,

        ),



        builder:
            (context, snapshot) {



          if (!snapshot.hasData) {


            return const Center(

              child:
              CircularProgressIndicator(),

            );

          }



          final banks =
          snapshot.data!;



          return ListView(


            padding:
            const EdgeInsets.all(20),



            children: [



              Text(

                widget.paymentTitle,

                style:
                const TextStyle(

                  fontSize:
                  28,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              const SizedBox(
                height: 10,
              ),




              const Text(

                "Realiza la transferencia utilizando cualquiera de las siguientes cuentas bancarias disponibles.",

                style:
                TextStyle(

                  color:
                  AppColors.textSecondary,

                ),

              ),




              const SizedBox(
                height: 25,
              ),




              Card(

                color:
                AppColors.primary,


                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(18),

                ),



                child:
                Padding(

                  padding:
                  const EdgeInsets.all(25),



                  child:
                  Column(

                    children: [



                      const Text(

                        "Costo del pago",

                        style:
                        TextStyle(

                          color:
                          Colors.white70,

                        ),

                      ),




                      const SizedBox(
                        height: 20,
                      ),




                      Text(

                        "${widget.currencySymbol} ${widget.amount.toStringAsFixed(2)}",


                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontSize:
                          34,

                          fontWeight:
                          FontWeight.bold,

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


                child:
                const Padding(

                  padding:
                  EdgeInsets.all(18),



                  child:
                  Text(

                    "Después de completar el pago, sube el comprobante para que nuestro equipo pueda verificarlo.",


                    style:
                    TextStyle(

                      height:
                      1.5,

                    ),

                  ),

                ),

              ),




              const SizedBox(
                height: 30,
              ),




              const Text(

                "Cuentas Bancarias Disponibles",

                style:
                TextStyle(

                  fontSize:
                  22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              const SizedBox(
                height: 20,
              ),




              if (banks.isEmpty)


                Card(

                  child:
                  Padding(

                    padding:
                    const EdgeInsets.all(25),


                    child:
                    Column(

                      children: const [


                        Icon(

                          Icons.account_balance_outlined,

                          size:
                          70,

                          color:
                          Colors.grey,

                        ),



                        SizedBox(
                          height: 15,
                        ),



                        Text(

                          "No hay cuentas bancarias disponibles.",

                          textAlign:
                          TextAlign.center,

                        ),



                      ],

                    ),

                  ),

                )



              else


                ...banks.map(bankCard),





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
                  BorderRadius.circular(18),

                ),

                child:
                const Text(

                  "Nuestro equipo verificará el comprobante antes de iniciar el proceso correspondiente.",

                  style:
                  TextStyle(

                    height:
                    1.5,

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