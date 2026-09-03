import 'package:flutter/material.dart';

import '../../../services/settings_service.dart';


class PaymentSettingsScreen extends StatefulWidget {

  const PaymentSettingsScreen({
    super.key,
  });

  @override
  State<PaymentSettingsScreen> createState() =>
      _PaymentSettingsScreenState();

}

class _PaymentSettingsScreenState
    extends State<PaymentSettingsScreen> {

  final SettingsService _settingsService =
  SettingsService();

  //==============================
  // CONTROLADORES
  //==============================

  final TextEditingController evaluationPriceController =
  TextEditingController();


  final TextEditingController servicePriceController =
  TextEditingController();


  final TextEditingController mrvPriceController =
  TextEditingController();


  final TextEditingController symbolController =
  TextEditingController();



  //==============================
  // VARIABLES
  //==============================


  String currency = "DOP";


  bool evaluationEnabled = true;


  bool serviceEnabled = true;


  bool mrvEnabled = true;


  bool loading = true;


  bool saving = false;



  @override
  void initState() {

    super.initState();

    loadSettings();

  }



  //==============================
  // CARGAR CONFIGURACIÓN
  //==============================


  Future<void> loadSettings() async {


    final settings =
    await _settingsService.getSettings();



    evaluationPriceController.text =
        (settings["evaluationPrice"] ?? 0)
            .toString();



    servicePriceController.text =
        (settings["servicePrice"] ?? 0)
            .toString();



    mrvPriceController.text =
        (settings["mrvPrice"] ?? 0)
            .toString();



    symbolController.text =
        settings["currencySymbol"] ?? "RD\$";



    currency =
        settings["currency"] ?? "DOP";



    evaluationEnabled =
        settings["evaluationEnabled"] ?? true;



    serviceEnabled =
        settings["serviceEnabled"] ?? true;



    mrvEnabled =
        settings["mrvEnabled"] ?? true;



    if (!mounted) return;



    setState(() {

      loading = false;

    });

  }




  @override
  void dispose() {


    evaluationPriceController.dispose();


    servicePriceController.dispose();


    mrvPriceController.dispose();


    symbolController.dispose();


    super.dispose();

  }




  Widget priceField({

    required String label,

    required TextEditingController controller,

  }) {


    return TextField(

      controller: controller,


      keyboardType:
      const TextInputType.numberWithOptions(
        decimal: true,
      ),




      decoration: InputDecoration(

        labelText: label,


        border:
        const OutlineInputBorder(),


        prefixIcon:
        const Icon(
          Icons.attach_money,
        ),

      ),

    );
  }

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

      appBar: AppBar(

        title:
        const Text(
          "Configuración de Pagos",
        ),

        centerTitle: true,

      ),



      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child: Column(

            children: [



        //==============================
        // EVALUACIÓN PREMIUM
        //==============================


        Card(

        child: Padding(

        padding:
        const EdgeInsets.all(18),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            const Text(

              "Evaluación Premium",

              style:
              TextStyle(

                fontSize: 20,

                fontWeight:
                FontWeight.bold,

              ),

            ),


            const SizedBox(height: 20),


            priceField(
              label:
              "Precio de evaluación",

              controller:
              evaluationPriceController,

            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
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
                      "Esta tarifa corresponde al monto oficial "
                          "de la visa y puede cambiar en cualquier momento "
                          "si la Embajada de los Estados Unidos modifica "
                          "la tarifa vigente. Actualiza este valor cuando "
                          "sea necesario.",
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),

                ],
              ),
            ),


            const SizedBox(height: 15),


            SwitchListTile(

              value:
              evaluationEnabled,


              title:
              const Text(
                "Evaluación activa",
              ),


              onChanged:
                  (value) {

                setState(() {

                  evaluationEnabled =
                      value;

                });

              },

            ),


          ],

        ),

      ),

    ),



    const SizedBox(height: 20),

              //==============================
              // EXPEDIENTE VISA ASSIST
              //==============================


              Card(

                child: Padding(

                  padding:
                  const EdgeInsets.all(18),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children: [


                      const Text(

                        "Expediente Visa Assist",

                        style:
                        TextStyle(

                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),


                      const SizedBox(height: 20),


                      priceField(

                        label:
                        "Precio del expediente",

                        controller:
                        servicePriceController,

                      ),


                      const SizedBox(height: 15),


                      SwitchListTile(

                        value:
                        serviceEnabled,


                        title:
                        const Text(
                          "Servicio activo",
                        ),


                        onChanged:
                            (value) {

                          setState(() {

                            serviceEnabled =
                                value;

                          });

                        },

                      ),

                    ],

                  ),

                ),

              ),



              const SizedBox(height: 20),



              //==============================
              // MRV
              //==============================


              Card(

                child: Padding(

                  padding:
                  const EdgeInsets.all(18),


                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Tarifa MRV - Visa de EE.UU.",

                        style:
                        TextStyle(

                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,

                        ),
                      ),

                      const SizedBox(height: 20),

                      priceField(
                        label:
                        "Tarifa MRV (USD)",

                        controller:
                        mrvPriceController,
                      ),


                      const SizedBox(height: 15),


                      SwitchListTile(

                        value:
                        mrvEnabled,


                        title:
                        const Text(
                          "MRV activo",
                        ),


                        onChanged:
                            (value) {

                          setState(() {

                            mrvEnabled =
                                value;

                          });

                        },

                      ),

                    ],

                  ),

                ),

              ),



              const SizedBox(height: 20),



              //==============================
              // MONEDA
              //==============================


              DropdownButtonFormField<String>(

                value:
                currency,


                decoration:
                const InputDecoration(

                  labelText:
                  "Moneda",

                  border:
                  OutlineInputBorder(),

                  prefixIcon:
                  Icon(
                    Icons.currency_exchange,
                  ),

                ),


                items:
                const [

                  DropdownMenuItem(

                    value:
                    "DOP",

                    child:
                    Text(
                      "Peso Dominicano",
                    ),

                  ),


                  DropdownMenuItem(

                    value:
                    "USD",

                    child:
                    Text(
                      "Dólar Americano",
                    ),

                  ),


                  DropdownMenuItem(

                    value:
                    "EUR",

                    child:
                    Text(
                      "Euro",
                    ),

                  ),

                ],


                onChanged:
                    (value) {

                  if (value == null) return;


                  setState(() {

                    currency =
                        value;

                  });

                },

              ),



              const SizedBox(height: 20),



              TextField(

                controller:
                symbolController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Símbolo de moneda",

                  border:
                  OutlineInputBorder(),

                  prefixIcon:
                  Icon(
                    Icons.text_fields,
                  ),

                ),

              ),



              const SizedBox(height: 35),



              SizedBox(

                width:
                double.infinity,


                height:
                55,


                child:
                ElevatedButton(


                  onPressed:
                  saving
                      ? null
                      : () async {


                    setState(() {

                      saving = true;

                    });



                    await _settingsService
                        .updateSettings({



                      "evaluationPrice":

                      double.tryParse(

                        evaluationPriceController
                            .text
                            .trim(),

                      ) ?? 0,



                      "servicePrice":

                      double.tryParse(

                        servicePriceController
                            .text
                            .trim(),

                      ) ?? 0,



                      "mrvPrice":

                      double.tryParse(

                        mrvPriceController
                            .text
                            .trim(),

                      ) ?? 0,



                      "evaluationEnabled":
                      evaluationEnabled,



                      "serviceEnabled":
                      serviceEnabled,



                      "mrvEnabled":
                      mrvEnabled,



                      "currency":
                      currency,



                      "currencySymbol":
                      symbolController
                          .text
                          .trim(),



                    });



                    if (!mounted) return;



                    setState(() {

                      saving = false;

                    });



                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content:
                        Text(

                          "Configuración guardada correctamente.",

                        ),


                        backgroundColor:
                        Colors.green,

                      ),

                    );


                  },


                  child:
                  saving

                      ? const CircularProgressIndicator(

                    color:
                    Colors.white,

                  )


                      : const Text(

                    "GUARDAR CONFIGURACIÓN",

                    style:
                    TextStyle(

                      fontSize:
                      17,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                ),

              ),


            ],

        ),

      ),

    );

  }

}