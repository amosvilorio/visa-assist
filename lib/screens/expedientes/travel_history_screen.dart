import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../models/travel_history.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../utils/app_colors.dart';
import '../visa/travel_companion_screen.dart';


class TravelHistoryScreen extends StatefulWidget {

  final Expediente expediente;

  const TravelHistoryScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<TravelHistoryScreen> createState() =>
      _TravelHistoryScreenState();
}

class _TravelHistoryScreenState
    extends State<TravelHistoryScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;


  //------------------------------------------
  // CONTROLADORES
  //------------------------------------------

  final paisesController =
  TextEditingController();

  final motivoController =
  TextEditingController();


  //------------------------------------------
  // VARIABLES
  //------------------------------------------

  String haViajado = "No";


  //------------------------------------------
  // LIBERAR MEMORIA
  //------------------------------------------

  @override
  void initState() {
    super.initState();

    cargarInformacion();
  }


  void cargarInformacion() {

    final history = widget.expediente.travelHistory;

    if (history == null) return;


    setState(() {

      haViajado =
      history.hasTraveledBefore
          ? "Sí"
          : "No";


      paisesController.text =
          history.countriesVisited;


      motivoController.text =
          history.travelPurpose;

    });

  }

  @override
  void dispose() {

    paisesController.dispose();

    motivoController.dispose();

    super.dispose();

  }


  List<DropdownMenuItem<String>> get opciones => const [

    DropdownMenuItem(
      value: "Sí",
      child: Text("Sí"),
    ),

    DropdownMenuItem(
      value: "No",
      child: Text("No"),
    ),

  ];


  //------------------------------------------
  // GUARDAR INFORMACIÓN
  //------------------------------------------

  Future<void> guardarYContinuar() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }


    final expedienteActual = widget.expediente;





    final travelHistory = TravelHistory(

      hasTraveledBefore:
      haViajado == "Sí",

      countriesVisited:
      paisesController.text.trim(),

      travelPurpose:
      motivoController.text.trim(),

    );


    await _expedienteService.saveTravelHistory(

      expedienteId: expedienteActual.id,

      travelHistory: travelHistory,

    );

    await _progressService.saveStep(
      expedienteId: expedienteActual.id,
      step: 11,
    );

    if (!mounted) return;

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => TravelCompanionScreen(
          expediente: widget.expediente,
        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "Historial de Viajes",
        ),
      ),


      body: Form(

        key: _formKey,

        child: ListView(

          padding: const EdgeInsets.all(20),

          children: [

            const Text(
              "PASO 10 DE 18",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Historial de Viajes",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),


            const Text(
              "Cuéntanos sobre tus viajes anteriores.",
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),


            const SizedBox(height: 30),



            DropdownButtonFormField<String>(

              value: haViajado,

              decoration: const InputDecoration(

                labelText:
                "¿Has viajado anteriormente?",

                prefixIcon:
                Icon(Icons.flight),

              ),


              items: opciones,


              onChanged: (value) {

                if (value == null) return;


                setState(() {

                  haViajado = value;

                });

              },

            ),



            if (haViajado == "Sí") ...[


              const SizedBox(height: 25),


              TextFormField(

                controller:
                paisesController,


                decoration:
                const InputDecoration(

                  labelText:
                  "Países visitados",

                  hintText:
                  "Ejemplo: España, México, Canadá",

                  prefixIcon:
                  Icon(Icons.public),

                ),

              ),



              const SizedBox(height: 20),



              TextFormField(

                controller:
                motivoController,


                maxLines: 4,


                decoration:
                const InputDecoration(

                  labelText:
                  "Motivo de esos viajes",

                  hintText:
                  "Turismo, trabajo, estudios, etc.",

                  prefixIcon:
                  Icon(Icons.description),

                ),

              ),

            ],



            const SizedBox(height: 40),



            SizedBox(

              height: 55,

              child: ElevatedButton(

                onPressed:
                guardarYContinuar,


                child: const Text(

                  "CONTINUAR",

                  style: TextStyle(

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              ),

            ),



            const SizedBox(height: 25),



            Container(

              padding:
              const EdgeInsets.all(16),


              decoration:
              BoxDecoration(

                color:
                Colors.blue.shade50,


                borderRadius:
                BorderRadius.circular(15),

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

                      "Si durante la revisión necesitamos información adicional sobre tus viajes anteriores, nos comunicaremos contigo mediante la aplicación o WhatsApp.",

                      style: TextStyle(
                        height: 1.5,
                      ),

                    ),

                  ),

                ],

              ),

            ),


          ],

        ),

      ),

    );

  }
}