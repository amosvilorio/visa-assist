import 'package:flutter/material.dart';

class VisaAddButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const VisaAddButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          foregroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}