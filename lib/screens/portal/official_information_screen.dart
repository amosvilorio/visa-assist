import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficialInformationScreen extends StatelessWidget {
  const OfficialInformationScreen({super.key});

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("No se pudo abrir el enlace.");
    }
  }

  Widget _linkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _openLink(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información Oficial"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.orange,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 30,
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Text(
                      "Visa Assist es una aplicación privada de asistencia y organización. "
                          "No está afiliada, respaldada ni operada por el Gobierno de los Estados Unidos, "
                          "el Departamento de Estado, USCIS, ni por ninguna Embajada o Consulado.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Fuentes oficiales",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Para obtener información actualizada y oficial sobre visas y procesos migratorios, consulta las siguientes páginas del Gobierno de los Estados Unidos.",
            ),

            const SizedBox(height: 20),

            _linkCard(
              icon: Icons.public,
              title: "Departamento de Estado",
              subtitle: "travel.state.gov",
              url: "https://travel.state.gov",
              color: Colors.blue,
            ),

            _linkCard(
              icon: Icons.description,
              title: "Formulario Oficial DS-160",
              subtitle: "ceac.state.gov",
              url: "https://ceac.state.gov/CEAC",
              color: Colors.green,
            ),

            _linkCard(
              icon: Icons.account_balance,
              title: "USCIS",
              subtitle: "uscis.gov",
              url: "https://www.uscis.gov",
              color: Colors.red,
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Todas las decisiones relacionadas con la aprobación o rechazo de una visa son tomadas exclusivamente por las autoridades gubernamentales correspondientes. "
                    "Visa Assist únicamente ayuda a organizar la información necesaria para facilitar el proceso de preparación del solicitante.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}