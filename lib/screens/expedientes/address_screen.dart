import 'package:flutter/material.dart';
import '../../models/expediente.dart';
import '../../utils/app_colors.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../models/address_information.dart';
import 'travel_information_screen.dart';

class AddressScreen extends StatefulWidget {

  final Expediente expediente;

  const AddressScreen({
    super.key,
    required this.expediente,
  });

  @override
  State<AddressScreen> createState() =>
      _AddressScreenState();
}

class _AddressScreenState
    extends State<AddressScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    cargarDireccion();
  }

  Future<void> cargarDireccion() async {
    final expediente = widget.expediente;

    final address = expediente.addressInformation;

    if (address == null) return;

    setState(() {
      direccionController.text = address.streetAddress;
      apartamentoController.text = address.apartmentNumber;
      ciudadController.text = address.city;
      provinciaController.text = address.stateProvince;
      codigoPostalController.text = address.postalCode;
      paisController.text = address.country;
      telefonoController.text = address.primaryPhone;
      correoController.text = address.emailAddress;
    });
  }

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  //----------------------------------------
  // CONTROLADORES
  //----------------------------------------

  final direccionController =
  TextEditingController();

  final apartamentoController =
  TextEditingController();

  final ciudadController =
  TextEditingController();

  final provinciaController =
  TextEditingController();

  final codigoPostalController =
  TextEditingController();

  final paisController =
  TextEditingController();

  final telefonoController =
  TextEditingController();

  final correoController =
  TextEditingController();

  //----------------------------------------
  // LIBERAR MEMORIA
  //----------------------------------------

  @override
  void dispose() {

    direccionController.dispose();

    apartamentoController.dispose();

    ciudadController.dispose();

    provinciaController.dispose();

    codigoPostalController.dispose();

    paisController.dispose();

    telefonoController.dispose();

    correoController.dispose();

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

            "Dirección y Contacto",

          ),

        ),

        body: Form(

          key: _formKey,

          child: ListView(

            padding: const EdgeInsets.all(20),

            children: [

            const Text(

              "PASO 8 DE 18",

            style: TextStyle(

              color: AppColors.primary,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 8),

          const Text(

            "Dirección y Contacto",

            style: TextStyle(

              fontSize: 28,

              fontWeight: FontWeight.bold,

            ),

          ),

          const SizedBox(height: 10),

          const Text(

            "Indica la dirección donde resides actualmente y tu información de contacto.",

            style: TextStyle(

              color: AppColors.textSecondary,

              height: 1.4,

            ),

          ),

          const SizedBox(height: 30),

          TextFormField(

            controller: direccionController,

            decoration: decoration(

              "Dirección",

              Icons.home,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese la dirección.";

              }

              return null;

            },

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: apartamentoController,

            decoration: decoration(

              "Apartamento / Suite (Opcional)",

              Icons.apartment,

            ),

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: ciudadController,

            decoration: decoration(

              "Ciudad",

              Icons.location_city,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese la ciudad.";

              }

              return null;

            },

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: provinciaController,

            decoration: decoration(

              "Provincia / Estado",

              Icons.map,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese la provincia.";

              }

              return null;

            },

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: codigoPostalController,

            decoration: decoration(

              "Código Postal (Opcional)",

              Icons.markunread_mailbox,

            ),

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: paisController,

            decoration: decoration(

              "País",

              Icons.public,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese el país.";

              }

              return null;

            },

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: telefonoController,

            keyboardType: TextInputType.phone,

            decoration: decoration(

              "Teléfono principal",

              Icons.phone,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese el teléfono.";

              }

              return null;

            },

          ),

          const SizedBox(height: 20),

          TextFormField(

            controller: correoController,

            keyboardType: TextInputType.emailAddress,

            decoration: decoration(

              "Correo electrónico",

              Icons.email,

            ),

            validator: (value) {

              if (value == null || value.isEmpty) {

                return "Ingrese el correo.";

              }

              return null;

            },

          ),

          const SizedBox(height: 35),

              SizedBox(

                height: 55,

                child: ElevatedButton(

                  onPressed: () async {

                    if (!_formKey.currentState!.validate()) {

                      return;

                    }

                    final addressInformation =

                    AddressInformation(

                      streetAddress:
                      direccionController.text.trim(),

                      apartmentNumber:
                      apartamentoController.text.trim(),

                      city:
                      ciudadController.text.trim(),

                      stateProvince:
                      provinciaController.text.trim(),

                      postalCode:
                      codigoPostalController.text.trim(),

                      country:
                      paisController.text.trim(),

                      primaryPhone:
                      telefonoController.text.trim(),

                      emailAddress:
                      correoController.text.trim(),

                    );

                    await _expedienteService.saveAddressInformation(

                      expedienteId: widget.expediente.id,

                      addressInformation: addressInformation,

                    );

                    await _progressService.saveStep(

                      expedienteId: widget.expediente.id,

                      step: 9,

                    );

                    if (!mounted) return;

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) => TravelInformationScreen(
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