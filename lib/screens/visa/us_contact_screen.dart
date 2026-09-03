import 'package:flutter/material.dart';

import 'family_information_screen.dart';
import '../../models/expediente.dart';
import '../../models/us_contact.dart';
import '../../services/expediente_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/visa/visa_dropdown.dart';
import '../../widgets/visa/visa_primary_button.dart';
import '../../widgets/visa/visa_section_card.dart';
import '../../widgets/visa/visa_step_header.dart';
import '../../widgets/visa/visa_text_field.dart';

class UsContactScreen extends StatefulWidget {
  final bool viewOnly;
  final Expediente? expediente;

  const UsContactScreen({
    super.key,
    this.viewOnly = false,
    this.expediente,
  });

  @override
  State<UsContactScreen> createState() => _UsContactScreenState();
}

class _UsContactScreenState extends State<UsContactScreen> {
  final _formKey = GlobalKey<FormState>();

  final ExpedienteService _expedienteService =
  ExpedienteService();

  final ProgressService _progressService =
      ProgressService.instance;

  Expediente? _expediente;

  bool _loading = true;
  bool _saving = false;

  // null = todavía no ha seleccionado una opción.
  bool? _hasUsContact;

  final _contactNameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _relationship;
  String? _state;

  final List<String> _relationships = const [
    "Familiar",
    "Amigo",
    "Conocido",
    "Empleador",
    "Empresa",
    "Otro",
  ];

  final List<String> _states = const [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Illinois",
    "Nevada",
    "New Jersey",
    "New York",
    "North Carolina",
    "Ohio",
    "Pennsylvania",
    "Texas",
    "Virginia",
    "Washington",
    "Otro",
  ];

  @override
  void initState() {
    super.initState();
    _loadExpediente();
  }

  Future<void> _loadExpediente() async {

    final expediente = widget.expediente;

    if (expediente == null) {

      if (!mounted) return;

      Navigator.pop(context);

      return;
    }

    _expediente = expediente;

    if (expediente.usContact != null) {
      _hasUsContact = true;

      final contact = expediente.usContact!;

      _contactNameController.text =
          contact.contactName;

      _organizationController.text =
          contact.organizationName;

      _address1Controller.text =
          contact.addressLine1;

      _address2Controller.text =
          contact.addressLine2;

      _cityController.text =
          contact.city;

      _zipController.text =
          contact.zipCode;

      _phoneController.text =
          contact.phoneNumber;

      _emailController.text =
          contact.email;

      _relationship =
      contact.relationship.isNotEmpty
          ? contact.relationship
          : null;

      _state =
      contact.state.isNotEmpty
          ? contact.state
          : null;
    } else {
      _hasUsContact = null;
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveAndContinue() async {
    // Primero obligamos al usuario a responder
    // si tiene o no contacto.
    if (_hasUsContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Indique si tiene un contacto en Estados Unidos.",
          ),
        ),
      );

      return;
    }

    // Si tiene contacto, validamos todos los campos.
    if (_hasUsContact == true) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      _saving = true;
    });

    try {
      // -----------------------------------------------
      // TIENE CONTACTO
      // -----------------------------------------------
      if (_hasUsContact == true) {
        final contact = UsContact(
          contactName:
          _contactNameController.text.trim(),

          organizationName:
          _organizationController.text.trim(),

          relationship:
          _relationship ?? "",

          addressLine1:
          _address1Controller.text.trim(),

          addressLine2:
          _address2Controller.text.trim(),

          city:
          _cityController.text.trim(),

          state:
          _state ?? "",

          zipCode:
          _zipController.text.trim(),

          phoneNumber:
          _phoneController.text.trim(),

          email:
          _emailController.text.trim(),
        );

        await _expedienteService.saveUsContact(
          expedienteId: _expediente!.id,
          usContact: contact,
        );
      }

      // -----------------------------------------------
      // NO TIENE CONTACTO
      // -----------------------------------------------
      else {
        await _expedienteService.deleteUsContact(
          expedienteId: _expediente!.id,
        );
      }

      // -----------------------------------------------
      // AVANZAR AL PASO 12
      // -----------------------------------------------

      await _progressService.saveStep(
        expedienteId: _expediente!.id,
        step: 12,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FamilyInformationScreen(
            expediente: _expediente!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No se pudo guardar la información: $e",
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });
    }
  }

  Widget _contactOption({
    required bool value,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final selected = _hasUsContact == value;

    return InkWell(
      onTap: widget.viewOnly
          ? null
          : () {
        setState(() {
          _hasUsContact = value;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blue.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context)
                    .primaryColor
                    .withOpacity(0.12)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade600,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _organizationController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacto en EE.UU."),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const VisaStepHeader(
                  currentStep: 11,
                  totalSteps: 18,
                  title: "Contacto en Estados Unidos",
                  description:
                  "Indique si cuenta con una persona u organización que pueda servir como contacto en los Estados Unidos.",
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        // ------------------------------------------
                        // PREGUNTA PRINCIPAL
                        // ------------------------------------------

                        VisaSectionCard(
                          title:
                          "¿Tienes un contacto en Estados Unidos?",
                          icon: Icons.contact_page,
                          child: Column(
                            children: [
                              _contactOption(
                                value: true,
                                icon: Icons.person,
                                title:
                                "Sí, tengo un contacto",
                                description:
                                "Tengo una persona u organización en Estados Unidos y puedo proporcionar sus datos.",
                              ),

                              const SizedBox(height: 12),

                              _contactOption(
                                value: false,
                                icon: Icons.person_off,
                                title:
                                "No tengo contacto",
                                description:
                                "No cuento con una persona u organización en Estados Unidos que pueda indicar como contacto.",
                              ),
                            ],
                          ),
                        ),

                        // ------------------------------------------
                        // FORMULARIO
                        // ------------------------------------------

                        if (_hasUsContact == true) ...[
                          const SizedBox(height: 20),

                          VisaSectionCard(
                            title:
                            "Información del contacto",
                            icon:
                            Icons.person_pin_circle,
                            child: Column(
                              children: [
                                VisaTextField(
                                  controller:
                                  _contactNameController,
                                  label:
                                  "Nombre del contacto",
                                  hint:
                                  "Ej: John Smith",
                                  prefixIcon:
                                  Icons.person,
                                  validator: (value) {
                                    if (value ==
                                        null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return "Ingrese el nombre del contacto.";
                                    }

                                    return null;
                                  },
                                ),

                                VisaTextField(
                                  controller:
                                  _organizationController,
                                  label:
                                  "Organización (Opcional)",
                                  hint:
                                  "Empresa u organización",
                                  prefixIcon:
                                  Icons.business,
                                ),

                                VisaDropdown<String>(
                                  label: "Relación",
                                  value: _relationship,
                                  prefixIcon:
                                  Icons.people,
                                  items:
                                  _relationships
                                      .map(
                                        (e) =>
                                        DropdownMenuItem(
                                          value: e,
                                          child:
                                          Text(e),
                                        ),
                                  )
                                      .toList(),
                                  onChanged: (value) {
                                    if (widget.viewOnly) return;

                                    setState(() {
                                      _relationship = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value ==
                                        null) {
                                      return "Seleccione una relación.";
                                    }

                                    return null;
                                  },
                                ),

                                VisaTextField(
                                  controller:
                                  _address1Controller,
                                  label: "Dirección",
                                  hint:
                                  "Address Line 1",
                                  prefixIcon:
                                  Icons.home,
                                  validator: (value) {
                                    if (value ==
                                        null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return "Ingrese la dirección.";
                                    }

                                    return null;
                                  },
                                ),

                                VisaTextField(
                                  controller:
                                  _address2Controller,
                                  label:
                                  "Dirección 2 (Opcional)",
                                  hint:
                                  "Apartment, Suite, etc.",
                                  prefixIcon:
                                  Icons.home_work,
                                ),

                                VisaTextField(
                                  controller:
                                  _cityController,
                                  label: "Ciudad",
                                  hint: "Ciudad",
                                  prefixIcon:
                                  Icons.location_city,
                                  validator: (value) {
                                    if (value ==
                                        null ||
                                        value
                                            .trim()
                                            .isEmpty) {
                                      return "Ingrese la ciudad.";
                                    }

                                    return null;
                                  },
                                ),

                                VisaDropdown<String>(
                                  label: "Estado",
                                  value: _state,
                                  prefixIcon:
                                  Icons.map,
                                  items: _states
                                      .map(
                                        (e) =>
                                        DropdownMenuItem(
                                          value: e,
                                          child:
                                          Text(e),
                                        ),
                                  )
                                      .toList(),
                                  onChanged: (value) {
                                    if (widget.viewOnly) return;

                                    setState(() {
                                      _state = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value ==
                                        null) {
                                      return "Seleccione un estado.";
                                    }

                                    return null;
                                  },
                                ),

                                VisaTextField(
                                  controller:
                                  _zipController,
                                  label:
                                  "Código Postal",
                                  hint:
                                  "ZIP Code",
                                  prefixIcon: Icons
                                      .local_post_office,
                                ),

                                VisaTextField(
                                  controller:
                                  _phoneController,
                                  label: "Teléfono",
                                  hint:
                                  "Número telefónico",
                                  prefixIcon:
                                  Icons.phone,
                                  keyboardType:
                                  TextInputType
                                      .phone,
                                ),

                                VisaTextField(
                                  controller:
                                  _emailController,
                                  label:
                                  "Correo electrónico (Opcional)",
                                  hint:
                                  "correo@ejemplo.com",
                                  prefixIcon:
                                  Icons.email,
                                  keyboardType:
                                  TextInputType
                                      .emailAddress,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // ------------------------------------------
                        // MENSAJE CUANDO NO TIENE CONTACTO
                        // ------------------------------------------

                        if (_hasUsContact == false) ...[
                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius:
                              BorderRadius.circular(
                                16,
                              ),
                              border: Border.all(
                                color:
                                Colors.blue.shade100,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color:
                                  Colors.blue.shade700,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    "Has indicado que no tienes un contacto en Estados Unidos. Puedes continuar con tu expediente.",
                                    style: TextStyle(
                                      height: 1.5,
                                      color:
                                      Colors.blue
                                          .shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (!widget.viewOnly)
                  VisaPrimaryButton(
                    text: "Guardar y continuar",
                    icon: Icons.arrow_forward,
                    loading: _saving,
                    onPressed: _hasUsContact == null
                        ? null
                        : _saveAndContinue,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}