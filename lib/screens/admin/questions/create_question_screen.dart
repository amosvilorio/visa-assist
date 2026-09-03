import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../widgets/option_editor.dart';
import '../../../../models/evaluation_question.dart';
import '../../../../models/evaluation_rule_editor.dart';
import '../../../../services/question_service.dart';
import '../../../../data/option_templates.dart';

class CreateQuestionScreen extends StatefulWidget {

  final EvaluationQuestion? question;

  const CreateQuestionScreen({
    super.key,
    this.question,
  });

  @override
  State<CreateQuestionScreen> createState() =>
      _CreateQuestionScreenState();
}

class _CreateQuestionScreenState
    extends State<CreateQuestionScreen> {

  //----------------------------------------------------------
  // SERVICES
  //----------------------------------------------------------

  final QuestionService _questionService =
  QuestionService();

  //----------------------------------------------------------
  // CONTROLLERS
  //----------------------------------------------------------

  final TextEditingController questionController =
  TextEditingController();

  final TextEditingController categoryController =
  TextEditingController();

  final TextEditingController keyController =
  TextEditingController();

  final TextEditingController orderController =
  TextEditingController();

  //----------------------------------------------------------
  // INFORMACIÓN GENERAL
  //----------------------------------------------------------

  String countryCode = "usa";

  String visaType = "turismo";

  bool isPremium = false;

  //----------------------------------------------------------
  // RESPUESTA
  //----------------------------------------------------------

  String responseType = "text";

  List<String> options = [];

  final List<TextEditingController> optionControllers = [];

  //----------------------------------------------------------
  // EVALUACIÓN
  //----------------------------------------------------------

  bool evaluationEnabled = true;

  String evaluationType = "none";

  //----------------------------------------------------------
  // REGLAS
  //----------------------------------------------------------

  List<EvaluationRuleEditor> rules = [];

  //----------------------------------------------------------
  // DEPENDENCIAS
  //----------------------------------------------------------

  String dependsOn = "";

  List<String> dependsValues = [];

  //----------------------------------------------------------
  // PREGUNTAS
  //----------------------------------------------------------

  List<EvaluationQuestion> allQuestions = [];

  //----------------------------------------------------------
  // INIT
  //----------------------------------------------------------

  @override
  void initState() {

    super.initState();

    _loadQuestions();

    if (widget.question != null) {

      final question = widget.question!;

      questionController.text =
          question.question;

      categoryController.text =
          question.category;

      keyController.text =
          question.questionKey;

      orderController.text =
          question.order.toString();

      countryCode =
          question.countryCode;

      visaType =
          question.visaType;

      isPremium =
          question.isPremium;

      responseType =
          question.responseType;

      evaluationEnabled =
          question.evaluationEnabled;

      evaluationType =
          question.evaluationType;

      options =
          List.from(question.options);

      optionControllers.clear();

      for (final option in options) {

        optionControllers.add(
          TextEditingController(text: option),
        );

      }

      rules = question.rules
          .map(
            (e) => EvaluationRuleEditor.fromRule(e),
      )
          .toList();

      dependsOn =
          question.dependsOn ?? "";

      dependsValues =
      List<String>.from(
        question.dependsValues,
      );

    }

  }

  //----------------------------------------------------------
  // LOAD QUESTIONS
  //----------------------------------------------------------

  Future<void> _loadQuestions() async {

    allQuestions =
    await _questionService.getAllQuestions();

    if (!mounted) return;

    setState(() {});

  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(

          title: Text(

            widget.question == null
                ? "Nueva Pregunta"
                : "Editar Pregunta",

          ),

          centerTitle: true,

        ),

        body: SafeArea(
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                  //--------------------------------------------------
                  // INFORMACIÓN GENERAL
                  //--------------------------------------------------

                  const Text(
                  "Información General",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 20),

              TextFormField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: "Pregunta",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: keyController,
                decoration: const InputDecoration(
                  labelText: "Question Key",
                  hintText: "monthly_income",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: "Categoría",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Orden",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: countryCode,
                decoration: const InputDecoration(
                  labelText: "País",
                  border: OutlineInputBorder(),
                ),
                items: const [

                  DropdownMenuItem(
                    value: "usa",
                    child: Text("Estados Unidos"),
                  ),

                  DropdownMenuItem(
                    value: "canada",
                    child: Text("Canadá"),
                  ),

                  DropdownMenuItem(
                    value: "espana",
                    child: Text("España"),
                  ),

                ],
                onChanged: (value) {

                  if (value == null) return;

                  setState(() {

                    countryCode = value;

                  });

                },
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: visaType,
                decoration: const InputDecoration(
                  labelText: "Tipo de Visa",
                  border: OutlineInputBorder(),
                ),
                items: const [

                  DropdownMenuItem(
                    value: "turismo",
                    child: Text("Turismo"),
                  ),

                  DropdownMenuItem(
                    value: "trabajo",
                    child: Text("Trabajo"),
                  ),

                  DropdownMenuItem(
                    value: "estudiante",
                    child: Text("Estudiante"),
                  ),

                ],
                onChanged: (value) {

                  if (value == null) return;

                  setState(() {

                    visaType = value;

                  });

                },
              ),

              const SizedBox(height: 15),

              SwitchListTile(
                value: isPremium,
                title: const Text(
                  "Pregunta Premium",
                ),
                onChanged: (value) {

                  setState(() {

                    isPremium = value;

                  });

                },
              ),

              const Divider(
                height: 40,
              ),

                //--------------------------------------------------
                // RESPUESTA
                //--------------------------------------------------

                const Text(
                  "Tipo de Respuesta",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: responseType,
                  decoration: const InputDecoration(
                    labelText: "Tipo de Respuesta",
                    border: OutlineInputBorder(),
                  ),
                  items: const [

                    DropdownMenuItem(
                      value: "text",
                      child: Text("Texto"),
                    ),

                    DropdownMenuItem(
                      value: "number",
                      child: Text("Número"),
                    ),

                    DropdownMenuItem(
                      value: "date",
                      child: Text("Fecha"),
                    ),

                    DropdownMenuItem(
                      value: "yes_no",
                      child: Text("Sí / No"),
                    ),

                    DropdownMenuItem(
                      value: "dropdown",
                      child: Text("Lista"),
                    ),

                    DropdownMenuItem(
                      value: "single_choice",
                      child: Text("Selección única"),
                    ),

                    DropdownMenuItem(
                      value: "multiple",
                      child: Text("Selección múltiple"),
                    ),

                  ],
                  onChanged: (value) {

                    if (value == null) return;

                    setState(() {

                      responseType = value;

                      options.clear();

                      rules.clear();

                    });

                  },
                ),

                      if (responseType == "dropdown" ||
                          responseType == "single_choice" ||
                          responseType == "multiple") ...[

                        const SizedBox(height: 25),

                        OptionEditor(

                          initialOptions: options,

                          onChanged: (newOptions) {

                            setState(() {

                              options = newOptions;

                            });

                          },

                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text("SUGERIR OPCIONES"),
                            onPressed: () {

                              final suggested =
                              OptionTemplates.findTemplate(
                                  questionController.text);

                              if (suggested == null) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "No se encontraron opciones sugeridas para esta pregunta.",
                                    ),
                                  ),
                                );

                                return;
                              }

                              setState(() {

                                options = suggested;

                              });

                            },
                          ),
                        ),

                      ],

                const SizedBox(height: 25),

                //--------------------------------------------------
                // ¿SE EVALÚA?
                //--------------------------------------------------

                SwitchListTile(

                  value: evaluationEnabled,

                  title: const Text(
                    "Evaluar esta pregunta",
                  ),

                  onChanged: (value) {

                    setState(() {

                      evaluationEnabled = value;

                    });

                  },

                ),

                if (evaluationEnabled) ...[

            const SizedBox(height: 20),

      const Text(
        "Tipo de Evaluación",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 20),

      DropdownButtonFormField<String>(
        value: evaluationType,
        decoration: const InputDecoration(
          labelText: "Tipo de Evaluación",
          border: OutlineInputBorder(),
        ),
        items: const [

          DropdownMenuItem(
            value: "none",
            child: Text("Sin evaluación"),
          ),

          DropdownMenuItem(
            value: "option",
            child: Text("Por opción"),
          ),

          DropdownMenuItem(
            value: "range",
            child: Text("Por rangos"),
          ),

          DropdownMenuItem(
            value: "multiple",
            child: Text("Selección múltiple"),
          ),

          DropdownMenuItem(
            value: "quantity",
            child: Text("Cantidad"),
          ),

        ],
        onChanged: (value) {

          if (value == null) return;

          setState(() {

            evaluationType = value;

            rules.clear();

          });

        },
      ),

      const Divider(
      height: 40,
    ),

    //--------------------------------------------------
    // REGLAS DE EVALUACIÓN
    //--------------------------------------------------

    if (evaluationType != "none") ...[

    const Text(
    "Reglas de Evaluación",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),

    const SizedBox(height: 20),

      if (evaluationType == "option" ||
          evaluationType == "multiple" ||
          evaluationType == "range" ||
          evaluationType == "quantity") ...[


    SizedBox(
    width: double.infinity,
    child:
    ElevatedButton.icon(

    icon: const Icon(Icons.add),

    label: const Text(
    "Agregar Regla",
    ),

    onPressed: () {

    setState(() {

    rules.add(
    EvaluationRuleEditor(),
    );

    });

    },

    ),
    ),

    const SizedBox(height: 20),
    ...List.generate(

    rules.length,

    (index) {

    final rule = rules[index];

    return Card(
      key: ObjectKey(rule),

    margin: const EdgeInsets.only(
    bottom: 20,
    ),

    child: Padding(

    padding: const EdgeInsets.all(15),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

    children: [

      if (evaluationType == "option" ||
          evaluationType == "multiple") ...[

        if (responseType == "yes_no") ...[

          DropdownButtonFormField<String>(
            value: rule.valueController.text.isEmpty
                ? null
                : rule.valueController.text,
            decoration: const InputDecoration(
              labelText: "Valor",
            ),
            items: const [

              DropdownMenuItem(
                value: "Sí",
                child: Text("Sí"),
              ),

              DropdownMenuItem(
                value: "No",
                child: Text("No"),
              ),

            ],
            onChanged: (value) {

              if (value == null) return;

              rule.valueController.text = value;

            },

          ),

        ] else if (responseType == "dropdown" ||
            responseType == "single_choice") ...[

          DropdownButtonFormField<String>(
            value: rule.valueController.text.isEmpty
                ? null
                : rule.valueController.text,

            decoration: const InputDecoration(
              labelText: "Valor",
            ),

            items: options.map((option) {

              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );

            }).toList(),

            onChanged: (value) {

              if (value == null) return;

              rule.valueController.text = value;

            },

          ),

        ] else ...[

          TextFormField(
            controller: rule.valueController,
            decoration: const InputDecoration(
              labelText: "Valor",
            ),
          ),

        ],

      ] else ...[

        Row(
          children: [

            Expanded(
              child: TextFormField(
                controller: rule.fromController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Desde",
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: TextFormField(
                controller: rule.toController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Hasta",
                ),
              ),
            ),

          ],
        ),
    ],

      const SizedBox(height: 10),

      TextFormField(
        key: ValueKey("points_$index"),
        controller: rule.pointsController,

    keyboardType: TextInputType.number,

    decoration: const InputDecoration(
    labelText: "Puntos",
    ),

    ),

    const SizedBox(height: 10),

      DropdownButtonFormField<String>(

        value: const [
          "Fortaleza",
          "Debilidad",
          "Neutral",
        ].contains(rule.classification)
            ? rule.classification
            : "Neutral",

    items: const [

    DropdownMenuItem(
    value: "Fortaleza",
    child: Text("Fortaleza"),
    ),

    DropdownMenuItem(
    value: "Debilidad",
    child: Text("Debilidad"),
    ),

    DropdownMenuItem(
    value: "Neutral",
    child: Text("Neutral"),
    ),

    ],

        onChanged: (value) {

          if (value == null) return;

          rule.classification = value;

        },

    ),

    const SizedBox(height: 10),

    TextFormField(

    controller: rule.strengthController,

    decoration: const InputDecoration(
    labelText: "Mensaje Fortaleza",
    ),

    ),

    const SizedBox(height: 10),

    TextFormField(

    controller: rule.weaknessController,

    decoration: const InputDecoration(
    labelText: "Mensaje Debilidad",
    ),

    ),

    const SizedBox(height: 10),

    TextFormField(

    controller: rule.recommendationController,

    decoration: const InputDecoration(
    labelText: "Recomendación",
    ),

    ),

    const SizedBox(height: 15),

    SizedBox(

    width: double.infinity,

    child: ElevatedButton.icon(

    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    ),

    icon: const Icon(Icons.delete),

    label: const Text("Eliminar"),

    onPressed: () {

    setState(() {

    rule.dispose();

    rules.removeAt(index);

    });

    },

    ),

    ),

    ],

    ),

    ),

    );

    },

    ),

    ],
    ],
                ],
//--------------------------------------------------
// DEPENDENCIAS
//--------------------------------------------------

                      const Divider(
                        height: 40,
                      ),

                      const Text(
                        "Dependencias",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: dependsOn,

                        decoration: const InputDecoration(
                          labelText: "Depende de",
                          border: OutlineInputBorder(),
                        ),

                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(
                            value: "",
                            child: Text("Ninguna"),
                          ),

                          ...allQuestions.map(
                                (q) => DropdownMenuItem<String>(
                              value: q.questionKey,
                              child: Text(q.question),
                            ),
                          ),
                        ],

                        onChanged: (value) {
                          setState(() {
                            dependsOn = value ?? "";
                            dependsValues.clear();
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      if (dependsOn.isNotEmpty)

                        Builder(
                          builder: (_) {

                            final dependencyQuestion = allQuestions.firstWhere(

                                  (q) => q.questionKey == dependsOn,

                              orElse: () => EvaluationQuestion(
                                id: "",
                                countryCode: "",
                                visaType: "",
                                isPremium: false,
                                order: 0,
                                category: "",
                                question: "",
                                questionKey: "",
                                responseType: "text",
                                options: const [],
                                required: true,
                                evaluationEnabled: false,
                                evaluationType: "none",
                                rules: const [],
                                dependsValues: const [],
                                createdAt: Timestamp.now(),
                              ),

                            );

                            List<String> availableOptions = [];

                            switch (dependencyQuestion.responseType) {
                              case "yes_no":
                                availableOptions = [
                                  "Sí",
                                  "No",
                                ];
                                break;

                              case "dropdown":
                              case "single_choice":
                              case "multiple":
                                availableOptions =
                                List<String>.from(dependencyQuestion.options);
                                break;

                              default:
                                availableOptions = [];
                            }

                            if (availableOptions.isEmpty) {
                              return const SizedBox();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Valores esperados",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                ...availableOptions.map(
                                      (option) {
                                    return CheckboxListTile(
                                      value: dependsValues.contains(option),
                                      title: Text(option),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      onChanged: (selected) {
                                        setState(() {
                                          if (selected == true) {
                                            if (!dependsValues.contains(option)) {
                                              dependsValues.add(option);
                                            }
                                          } else {
                                            dependsValues.remove(option);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),

                              ],
                            );
                          },

                        ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton.icon(

                          icon: const Icon(Icons.save),

                          label: const Text(
                            "GUARDAR PREGUNTA",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          onPressed: _saveQuestion,

                        ),
                      ),
                        ],
                      ),
                    ),
                  );
                },
            ),
        ),
    );
  }

  //----------------------------------------------------------
  // GUARDAR
  //----------------------------------------------------------

  Future<void> _saveQuestion() async {

    final firestoreRules =
    rules.map((e) => e.toRule()).toList();

    final question = EvaluationQuestion(

      id: widget.question?.id ?? "",

      countryCode: countryCode,

      visaType: visaType,

      isPremium: isPremium,

      order:
      int.tryParse(
        orderController.text.trim(),
      ) ??
          0,

      category:
      categoryController.text.trim(),

      question:
      questionController.text.trim(),

      questionKey:
      keyController.text.trim(),

      responseType: responseType,

      options: options,

      required: true,

      evaluationEnabled:
      evaluationEnabled,

      evaluationType:
      evaluationType,

      rules: firestoreRules,

      dependsOn: dependsOn,

      dependsValues: dependsValues,

      createdAt: Timestamp.now(),

    );

    if (widget.question == null) {

      await _questionService.createQuestion(
        question,
      );

    } else {

      await _questionService.updateQuestion(
        widget.question!.id,
        question,
      );
    }

    if (!mounted) return;

    if (widget.question == null) {

      setState(() {

        questionController.clear();
        keyController.clear();
        categoryController.clear();
        orderController.clear();

        responseType = "text";
        evaluationEnabled = true;
        evaluationType = "none";

        options.clear();

        dependsOn = "";
        dependsValues.clear();

        for (final rule in rules) {
          rule.dispose();
        }

        rules.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pregunta guardada correctamente."),
        ),
      );

    } else {

      Navigator.pop(context);
    }
  }

  //----------------------------------------------------------
  // DISPOSE
  //----------------------------------------------------------

  @override
  void dispose() {

    questionController.dispose();

    categoryController.dispose();

    keyController.dispose();

    orderController.dispose();

    for (final rule in rules) {

      rule.dispose();
    }

    super.dispose();
  }
}