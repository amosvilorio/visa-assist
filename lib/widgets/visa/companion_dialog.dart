import 'package:flutter/material.dart';

import '../../models/travel_companion.dart';
import 'visa_dropdown.dart';
import 'visa_primary_button.dart';
import 'visa_text_field.dart';

class CompanionDialog extends StatefulWidget {
  final TravelCompanion? companion;

  const CompanionDialog({
    super.key,
    this.companion,
  });

  @override
  State<CompanionDialog> createState() => _CompanionDialogState();
}

class _CompanionDialogState extends State<CompanionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;

  String? _relationship;

  final List<String> _relationships = const [
    "Esposo(a)",
    "Padre",
    "Madre",
    "Hijo(a)",
    "Hermano(a)",
    "Abuelo(a)",
    "Nieto(a)",
    "Tío(a)",
    "Primo(a)",
    "Amigo(a)",
    "Compañero de trabajo",
    "Otro",
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.companion?.fullName ?? "",
    );

    _relationship = widget.companion?.relationship;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      TravelCompanion(
        fullName: _nameController.text.trim(),
        relationship: _relationship!,
        travelingWithApplicant: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.companion == null
            ? "Agregar compañero"
            : "Editar compañero",
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VisaTextField(
                  controller: _nameController,
                  label: "Nombre completo",
                  hint: "Ej: Juan Pérez",
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Ingrese el nombre.";
                    }
                    return null;
                  },
                ),

                VisaDropdown<String>(
                  label: "Relación",
                  value: _relationship,
                  prefixIcon: Icons.people,
                  items: _relationships
                      .map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _relationship = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Seleccione una relación.";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: VisaPrimaryButton(
                text: "Guardar",
                icon: Icons.save,
                onPressed: _save,
                expanded: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}