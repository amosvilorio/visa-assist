import 'package:flutter/material.dart';

class HomeAgentScreen extends StatelessWidget {
  const HomeAgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Agente"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Bienvenido Agente Migratorio",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}