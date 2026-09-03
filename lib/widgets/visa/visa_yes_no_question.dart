import 'package:flutter/material.dart';

class VisaYesNoQuestion extends StatelessWidget {
  final String question;
  final bool? value;
  final void Function(bool) onChanged;
  final String? description;

  const VisaYesNoQuestion({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],

            const SizedBox(height: 16),

            RadioListTile<bool>(
              value: true,
              groupValue: value,
              title: const Text("Sí"),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool? value) {
                if (value != null) {
                  onChanged.call(value);
                }
              },
            ),

            RadioListTile<bool>(
              value: false,
              groupValue: value,
              title: const Text("No"),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool? value) {
                if (value != null) {
                  onChanged.call(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}