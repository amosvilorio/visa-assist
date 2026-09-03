import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/evaluation_service.dart';
import 'evaluation_question_screen.dart';

class NewEvaluationScreen extends StatefulWidget {
  const NewEvaluationScreen({super.key});

  @override
  State<NewEvaluationScreen> createState() =>
      _NewEvaluationScreenState();
}

class _NewEvaluationScreenState
    extends State<NewEvaluationScreen> {

  String? evaluationFor;

  final nombreController =
  TextEditingController();

  final apellidoController =
  TextEditingController();

  bool loading = false;

  String country = "usa";

  String visaType = "turismo";

  final EvaluationService _evaluationService =
  EvaluationService();

  @override
  void initState() {
    super.initState();

    final user =
        FirebaseAuth.instance.currentUser;

    if (user != null) {
      final displayName =
          user.displayName ?? "";

      if (displayName.trim().isNotEmpty) {
        final parts =
        displayName.trim().split(" ");

        nombreController.text =
            parts.first;

        if (parts.length > 1) {
          apellidoController.text =
              parts.sublist(1).join(" ");
        }
      }

      evaluationFor = "me";
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    super.dispose();
  }

  //==================================================
  // VALIDAR FORMULARIO
  //==================================================

  bool get canContinue {
    return nombreController.text
        .trim()
        .isNotEmpty &&
        apellidoController.text
            .trim()
            .isNotEmpty;
  }

  //==================================================
  // CREAR NUEVA EVALUACIÓN
  //==================================================

  Future<void> continuar() async {
    setState(() {
      loading = true;
    });

    try {
      final evaluationId =
      await _evaluationService
          .createEvaluation(
        countryCode: country,
        visaType: visaType,
        isForAnotherPerson:
        evaluationFor == "other",
        firstName:
        nombreController.text.trim(),
        lastName:
        apellidoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EvaluationQuestionScreen(
                evaluationId:
                evaluationId,
                countryCode:
                country,
                visaType:
                visaType,
              ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  //==================================================
  // BUILD
  //==================================================

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text("Nueva Evaluación"),
        centerTitle: true,
      ),

      body: SafeArea(
        child:
        SingleChildScrollView(
          padding:
          const EdgeInsets.all(20),

          child: Column(
            children: [

              const Text(
                "¿Para quién deseas realizar esta evaluación?",
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //==================================================
              // PARA MÍ
              //==================================================

              RadioListTile<String>(
                title:
                const Text("Para mí"),
                value: "me",
                groupValue:
                evaluationFor,
                onChanged:
                    (value) {

                  setState(() {

                    evaluationFor =
                        value;

                    final user =
                        FirebaseAuth
                            .instance
                            .currentUser;

                    if (user != null) {

                      final displayName =
                          user.displayName ??
                              "";

                      if (displayName
                          .trim()
                          .isNotEmpty) {

                        final parts =
                        displayName
                            .trim()
                            .split(" ");

                        nombreController
                            .text =
                            parts.first;

                        apellidoController
                            .text =
                        parts.length > 1
                            ? parts
                            .sublist(
                          1,
                        )
                            .join(" ")
                            : "";
                      }
                    }
                  });
                },
              ),

              //==================================================
              // PARA OTRA PERSONA
              //==================================================

              RadioListTile<String>(
                title:
                const Text(
                    "Para otra persona"),
                value: "other",
                groupValue:
                evaluationFor,
                onChanged:
                    (value) {

                  setState(() {

                    evaluationFor =
                        value;

                    nombreController
                        .clear();

                    apellidoController
                        .clear();
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              //==================================================
              // NOMBRE
              //==================================================

              TextField(
                controller:
                nombreController,
                decoration:
                const InputDecoration(
                  labelText: "Nombre",
                  border:
                  OutlineInputBorder(),
                ),
                onChanged:
                    (_) => setState(() {}),
              ),

              const SizedBox(
                height: 15,
              ),

              //==================================================
              // APELLIDO
              //==================================================

              TextField(
                controller:
                apellidoController,
                decoration:
                const InputDecoration(
                  labelText: "Apellido",
                  border:
                  OutlineInputBorder(),
                ),
                onChanged:
                    (_) => setState(() {}),
              ),

              const SizedBox(
                height: 20,
              ),

              //==================================================
              // PAÍS
              //==================================================

              DropdownButtonFormField<String>(
                value: country,
                decoration:
                const InputDecoration(
                  labelText: "País",
                  border:
                  OutlineInputBorder(),
                ),
                items: const [

                  DropdownMenuItem(
                    value: "usa",
                    child: Text(
                        "Estados Unidos"),
                  ),
                ],
                onChanged: null,
              ),

              const SizedBox(
                height: 15,
              ),

              //==================================================
              // TIPO DE VISA
              //==================================================

              DropdownButtonFormField<String>(
                value: visaType,
                decoration:
                const InputDecoration(
                  labelText:
                  "Tipo de Visa",
                  border:
                  OutlineInputBorder(),
                ),
                items: const [

                  DropdownMenuItem(
                    value: "turismo",
                    child: Text(
                        "Turismo B1/B2"),
                  ),
                ],
                onChanged: null,
              ),

              const SizedBox(
                height: 20,
              ),

              //==================================================
              // CONTINUAR
              //==================================================

              SizedBox(
                width:
                double.infinity,
                height: 55,

                child:
                ElevatedButton(
                  onPressed:
                  (!canContinue ||
                      loading)
                      ? null
                      : continuar,

                  child: loading
                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )
                      : const Text(
                    "Continuar",
                    style:
                    TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}