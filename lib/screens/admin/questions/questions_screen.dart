import 'package:flutter/material.dart';
import 'create_question_screen.dart';
import '../../../services/question_service.dart';
import '../../../models/evaluation_question.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() =>
      _QuestionsScreenState();
}

class _QuestionsScreenState
    extends State<QuestionsScreen> {

  final QuestionService _questionService =
  QuestionService();

  Future<void> _copyAllQuestions() async {
    try {
      final questions =
      await _questionService.getAllQuestions();

      final data = questions.map((question) {
        return {
          'id': question.id,
          'countryCode': question.countryCode,
          'visaType': question.visaType,
          'isPremium': question.isPremium,
          'order': question.order,
          'category': question.category,
          'question': question.question,
          'questionKey': question.questionKey,
          'responseType': question.responseType,
          'options': question.options,
          'required': question.required,
          'evaluationEnabled':
          question.evaluationEnabled,
          'evaluationType':
          question.evaluationType,
          'rules': question.rules.map((rule) {
            return {
              'value': rule.value,
              'from': rule.from,
              'to': rule.to,
              'points': rule.points,
              'classification':
              rule.classification,
              'strengthMessage':
              rule.strengthMessage,
              'weaknessMessage':
              rule.weaknessMessage,
              'recommendationMessage':
              rule.recommendationMessage,
            };
          }).toList(),
          'dependsOn': question.dependsOn,
          'dependsValues':
          question.dependsValues,
          'createdAt':
          question.createdAt.toDate().toIso8601String(),
        };
      }).toList();

      final json = const JsonEncoder.withIndent(
        '  ',
      ).convert(data);

      await Clipboard.setData(
        ClipboardData(text: json),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${questions.length} preguntas copiadas correctamente.',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al copiar las preguntas: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banco de Preguntas"),
        actions: [
          IconButton(
            tooltip: 'Copiar todas las preguntas',
            icon: const Icon(Icons.copy_all),
            onPressed: _copyAllQuestions,
          ),
        ],
      ),

      body: StreamBuilder<List<EvaluationQuestion>>(
        stream: _questionService.watchAllQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Sin datos"),
            );
          }

          final questions = snapshot.data!;

          if (questions.isEmpty) {
            return const Center(
              child: Text(
                "No hay preguntas registradas.",
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      question.order.toString(),
                    ),
                  ),
                  title: Text(question.question),
                  subtitle: Text(question.category),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateQuestionScreen(
                              question: question,
                            ),
                          ),
                        );
                      }

                      if (value == "delete") {
                        await QuestionService().deleteQuestion(
                          question.id,
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Editar"),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Eliminar"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateQuestionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}