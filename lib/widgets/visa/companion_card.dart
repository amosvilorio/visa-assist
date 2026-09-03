import 'package:flutter/material.dart';

import '../../models/travel_companion.dart';

class CompanionCard extends StatelessWidget {
  final TravelCompanion companion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CompanionCard({
    super.key,
    required this.companion,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
        ),

        title: Text(
          companion.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(companion.relationship),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: "Editar",
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onPressed: onEdit,
            ),

            IconButton(
              tooltip: "Eliminar",
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}