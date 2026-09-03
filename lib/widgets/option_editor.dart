import 'package:flutter/material.dart';

class OptionEditor extends StatefulWidget {
  final List<String> initialOptions;
  final ValueChanged<List<String>> onChanged;

  const OptionEditor({
    super.key,
    required this.initialOptions,
    required this.onChanged,
  });

  @override
  State<OptionEditor> createState() => _OptionEditorState();
}

class _OptionEditorState extends State<OptionEditor> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _loadControllers(widget.initialOptions);
  }

  void _loadControllers(List<String> values) {
    for (final controller in _controllers) {
      controller.dispose();
    }

    _controllers.clear();

    for (final value in values) {
      _controllers.add(
        TextEditingController(text: value),
      );
    }

    if (_controllers.isEmpty) {
      _controllers.add(
        TextEditingController(),
      );
    }
  }

  bool _sameOptions(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  void didUpdateWidget(covariant OptionEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Solo reconstruimos los campos si realmente cambió
    // la cantidad o el contenido de las opciones desde el padre.
    if (!_sameOptions(
      oldWidget.initialOptions,
      widget.initialOptions,
    )) {
      if (!_sameOptions(
        _controllers
            .map((controller) => controller.text)
            .toList(),
        widget.initialOptions,
      )) {
        setState(() {
          _loadControllers(widget.initialOptions);
        });
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _notifyParent() {
    widget.onChanged(
      _controllers
          .map((controller) => controller.text)
          .toList(),
    );
  }

  void _addOption() {
    setState(() {
      _controllers.add(
        TextEditingController(),
      );
    });

    // Importante:
    // notificamos al padre DESPUÉS de crear el nuevo campo,
    // pero conservamos también el campo vacío.
    _notifyParent();
  }

  void _removeOption(int index) {
    if (_controllers.length <= 1) {
      return;
    }

    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });

    _notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Opciones",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ...List.generate(
          _controllers.length,
              (index) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        labelText: "Opción ${index + 1}",
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        _notifyParent();
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _removeOption(index);
                    },
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 5),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addOption,
            icon: const Icon(Icons.add),
            label: const Text(
              "Agregar opción",
            ),
          ),
        ),
      ],
    );
  }
}