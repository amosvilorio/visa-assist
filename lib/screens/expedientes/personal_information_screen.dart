import 'package:flutter/material.dart';

import '../../models/personal_information.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../utils/app_colors.dart';
import 'address_screen.dart';
import 'passport_information_screen.dart';
import '../../models/expediente.dart';

class PersonalInformationScreen extends StatefulWidget {

  final Expediente expediente;

  const PersonalInformationScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {

  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  //---------------------------------------
  // CONTROLADORES
  //---------------------------------------

  final ciudadNacimientoController =
  TextEditingController();

  final provinciaNacimientoController =
  TextEditingController();

  final paisNacimientoController =
  TextEditingController();

  final nacionalidadController =
  TextEditingController();

  final otraNacionalidadController =
  TextEditingController();

  final paisResidenciaController =
  TextEditingController();

  final otrosNombresController =
  TextEditingController();

  final cedulaController =
  TextEditingController();

  //---------------------------------------
  // VARIABLES
  //---------------------------------------

  String estadoCivil = "SOLTERO";

  bool haUsadoOtrosNombres = false;

  bool tieneOtraNacionalidad = false;

  bool residenteOtroPais = false;

  @override
  void dispose() {

    ciudadNacimientoController.dispose();

    provinciaNacimientoController.dispose();

    paisNacimientoController.dispose();

    nacionalidadController.dispose();

    otraNacionalidadController.dispose();

    paisResidenciaController.dispose();

    otrosNombresController.dispose();

    cedulaController.dispose();

    super.dispose();

  }

  InputDecoration decoration(

      String label,

      IconData icon,

      ) {

    return InputDecoration(

      labelText: label,

      prefixIcon: Icon(icon),

    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: AppColors.background,

        appBar: AppBar(

          title: const Text(
            "Información Personal",
          ),

        ),

        body: Form(

            key: _formKey,

            child: ListView(

              padding: const EdgeInsets.all(20),

              children: [

              const Text(

                "PASO 6 DE 18",

              style: TextStyle(

                color: AppColors.primary,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 8),

            const Text(

              "Información Personal",

              style: TextStyle(

                fontSize: 28,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 10),

            const Text(

              "Completa la información solicitada. Estas preguntas corresponden a la sección Personal Information del formulario DS-160.",

              style: TextStyle(

                color: AppColors.textSecondary,

                height: 1.4,

              ),

            ),

            const SizedBox(height: 30),

            //--------------------------------
            // OTROS NOMBRES
            //--------------------------------

            SwitchListTile(

              value: haUsadoOtrosNombres,

              title: const Text(

                "¿Ha utilizado otros nombres?",

              ),

              subtitle: const Text(

                "Por ejemplo apellido de casada, nombre legal anterior o alias.",

              ),

              onChanged: (value) {

                setState(() {

                  haUsadoOtrosNombres = value;

                });

              },

            ),

            if (haUsadoOtrosNombres) ...[

        const SizedBox(height: 15),

    TextFormField(

    controller: otrosNombresController,

    decoration: decoration(

    "Otros nombres utilizados",

    Icons.person,

    ),

    ),

    ],

    const SizedBox(height: 25),

    //--------------------------------
    // ESTADO CIVIL
    //--------------------------------

    DropdownButtonFormField<String>(

    value: estadoCivil,

    decoration: const InputDecoration(

    labelText: "Estado civil",

    ),

    items: const [

    DropdownMenuItem(

    value: "SOLTERO",

    child: Text("Soltero(a)"),

    ),

    DropdownMenuItem(

    value: "CASADO",

    child: Text("Casado(a)"),

    ),

    DropdownMenuItem(

    value: "UNION_LIBRE",

    child: Text("Unión libre"),

    ),

    DropdownMenuItem(

    value: "DIVORCIADO",

    child: Text("Divorciado(a)"),

    ),

    DropdownMenuItem(

    value: "VIUDO",

    child: Text("Viudo(a)"),

    ),

    DropdownMenuItem(

    value: "SEPARADO",

    child: Text("Separado legalmente"),

    ),

    ],

    onChanged: (value) {

    if (value == null) return;

    setState(() {

    estadoCivil = value;

    });

    },

    ),

    const SizedBox(height: 25),

    //--------------------------------
    // LUGAR DE NACIMIENTO
    //--------------------------------

    TextFormField(

    controller: ciudadNacimientoController,

    decoration: decoration(

    "Ciudad de nacimiento",

    Icons.location_city,

    ),

    ),

    const SizedBox(height: 20),

    TextFormField(

    controller: provinciaNacimientoController,

    decoration: decoration(

    "Provincia / Estado de nacimiento",

    Icons.map,

    ),

    ),

    const SizedBox(height: 20),

    TextFormField(

    controller: paisNacimientoController,

    decoration: decoration(

    "País de nacimiento",

    Icons.public,

    ),

    ),

    const SizedBox(height: 25),

    //--------------------------------
    // NACIONALIDAD
    //--------------------------------

    TextFormField(

    controller: nacionalidadController,

    decoration: decoration(

    "Nacionalidad",

    Icons.flag,

    ),

    ),

    const SizedBox(height: 25),

    //--------------------------------
    // OTRA NACIONALIDAD
    //--------------------------------

    SwitchListTile(

    value: tieneOtraNacionalidad,

    title: const Text(

    "¿Posee otra nacionalidad?",

    ),

    onChanged: (value) {

    setState(() {

    tieneOtraNacionalidad = value;

    });

    },

    ),

    if (tieneOtraNacionalidad) ...[

    const SizedBox(height: 15),

    TextFormField(

    controller: otraNacionalidadController,

    decoration: decoration(

    "Indique la otra nacionalidad",

    Icons.flag_circle,

    ),

    ),

    ],

    const SizedBox(height: 25),

    //--------------------------------
    // RESIDENTE EN OTRO PAIS
    //--------------------------------

    SwitchListTile(

    value: residenteOtroPais,

    title: const Text(

    "¿Es residente permanente de otro país?",

    ),

    onChanged: (value) {

    setState(() {

    residenteOtroPais = value;

    });

    },

    ),

    if (residenteOtroPais) ...[

    const SizedBox(height: 15),

    TextFormField(

    controller: paisResidenciaController,

    decoration: decoration(

    "País de residencia permanente",

    Icons.home,

    ),

    ),

    ],

    const SizedBox(height: 25),

    //--------------------------------
    // DOCUMENTO NACIONAL
    //--------------------------------

    TextFormField(

    controller: cedulaController,

    decoration: decoration(

    "Número de identificación nacional (Cédula)",

    Icons.badge,

    ),

    ),

    const SizedBox(height: 35),

                SizedBox(

                  height: 55,

                  child: ElevatedButton(

                    onPressed: () async {

                      if (!_formKey.currentState!.validate()) {

                        return;

                      }


                      final personalInformation =

                      PersonalInformation(

                        cityOfBirth:
                        ciudadNacimientoController.text.trim(),

                        stateOfBirth:
                        provinciaNacimientoController.text.trim(),

                        countryOfBirth:
                        paisNacimientoController.text.trim(),

                        nationality:
                        nacionalidadController.text.trim(),

                        maritalStatus:
                        estadoCivil,

                        nationalIdNumber:
                        cedulaController.text.trim(),

                        hasOtherNationality:
                        tieneOtraNacionalidad,

                        otherNationality:
                        otraNacionalidadController.text.trim(),

                        hasOtherNames:
                        haUsadoOtrosNombres,

                        otherNames:
                        otrosNombresController.text.trim(),

                        isPermanentResidentOtherCountry:
                        residenteOtroPais,

                        permanentResidentCountry:
                        paisResidenciaController.text.trim(),

                      );

                      await _expedienteService.savePersonalInformation(

                        expedienteId: widget.expediente.id,

                        personalInformation: personalInformation,

                      );

                      await _progressService.saveStep(

                        expedienteId: widget.expediente.id,

                        step: 7,

                      );

                      if (!mounted) return;

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) => PassportInformationScreen(

                            expediente: widget.expediente,

                          ),

                        ),

                      );
                    },

                    child: const Text(

                      "CONTINUAR",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ),

                ),

                const SizedBox(height: 30),

              ],

            ),

        ),

    );

  }

}