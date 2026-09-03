import 'package:flutter/material.dart';
import '../payment/service_payment_screen.dart';
import '../../utils/app_colors.dart';
import '../../models/expediente.dart';

class SummaryScreen extends StatelessWidget {

  final Expediente expediente;

  const SummaryScreen({
    super.key,
    required this.expediente,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Resumen del Expediente"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "PASO 17 DE 18",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Resumen",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Verifica cuidadosamente toda la información antes de continuar.",
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 30),

          _section(
            title: "Solicitante",
            icon: Icons.person,
            information: expediente.applicant != null
                ? "${expediente.applicant!.firstName} ${expediente.applicant!.lastName}"
                : "Información no completada",
          ),

          _section(
            title: "Información Personal",
            icon: Icons.badge,
            information: expediente.personalInformation != null
                ? "Estado civil: ${expediente.personalInformation!.maritalStatus}\n"
                "Lugar de nacimiento: ${expediente.personalInformation!.cityOfBirth}, "
                "${expediente.personalInformation!.stateOfBirth}, "
                "${expediente.personalInformation!.countryOfBirth}\n"
                "Nacionalidad: ${expediente.personalInformation!.nationality}\n"
                "ID nacional: ${expediente.personalInformation!.nationalIdNumber}"
                : "Información no completada",
          ),

          _section(
            title: "Información del Pasaporte",
            icon: Icons.book,
            information: expediente.passportInformation != null
                ? "Número de pasaporte: ${expediente.passportInformation!.passportNumber}\n"
                "País de expedición: ${expediente.passportInformation!.issuingCountry}\n"
                "Ciudad de expedición: ${expediente.passportInformation!.issuingCity}\n"
                "Estado/Provincia: ${expediente.passportInformation!.issuingState}\n"
                "Fecha de emisión: ${expediente.passportInformation!.issueDate.day}/"
                "${expediente.passportInformation!.issueDate.month}/"
                "${expediente.passportInformation!.issueDate.year}\n"
                "Fecha de vencimiento: ${expediente.passportInformation!.expirationDate.day}/"
                "${expediente.passportInformation!.expirationDate.month}/"
                "${expediente.passportInformation!.expirationDate.year}"
                : "Información no completada",
          ),

          _section(
            title: "Dirección y Contacto",
            icon: Icons.home,
            information: expediente.addressInformation != null
                ? "Dirección: ${expediente.addressInformation!.streetAddress}\n"
                "Apartamento/Suite: ${expediente.addressInformation!.apartmentNumber}\n"
                "Ciudad: ${expediente.addressInformation!.city}\n"
                "Provincia/Estado: ${expediente.addressInformation!.stateProvince}\n"
                "Código postal: ${expediente.addressInformation!.postalCode}\n"
                "País: ${expediente.addressInformation!.country}\n"
                "Teléfono: ${expediente.addressInformation!.primaryPhone}\n"
                "Correo: ${expediente.addressInformation!.emailAddress}"
                : "Información no completada",
          ),

          _section(
            title: "Trabajo y Educación",
            icon: Icons.work,
            information: expediente.workEducationInformation != null
                ? "Ocupación: ${expediente.workEducationInformation!.occupation}\n"
                "Empleador: ${expediente.workEducationInformation!.employerName}\n"
                "Ciudad: ${expediente.workEducationInformation!.city}\n"
                "Provincia/Estado: ${expediente.workEducationInformation!.stateProvince}\n"
                "País: ${expediente.workEducationInformation!.country}\n"
                "Teléfono: ${expediente.workEducationInformation!.phoneNumber}\n"
                "Salario mensual: ${expediente.workEducationInformation!.monthlySalary}\n"
                "Nivel educativo: ${expediente.workEducationInformation!.highestEducationLevel}\n"
                "Institución: ${expediente.workEducationInformation!.institutionName}\n"
                "Área de estudio: ${expediente.workEducationInformation!.courseOfStudy}"
                : "Información no completada",
          ),

          _section(
            title: "Información del Viaje",
            icon: Icons.flight,
            information: expediente.travelInformation != null
                ? "Propósito del viaje: "
                "${expediente.travelInformation!.purposeOfTrip}\n"
                "Fecha estimada de llegada: "
                "${expediente.travelInformation!.estimatedArrivalDate != null
                ? "${expediente.travelInformation!.estimatedArrivalDate!.day}/"
                "${expediente.travelInformation!.estimatedArrivalDate!.month}/"
                "${expediente.travelInformation!.estimatedArrivalDate!.year}"
                : "No indicada"}\n"
                "Duración de la estadía: "
                "${expediente.travelInformation!.lengthOfStay}\n"
                "¿Conoce dónde se hospedará?: "
                "${expediente.travelInformation!.knowsWhereWillStay ? "Sí" : "No"}\n"
                "Dirección de hospedaje: "
                "${expediente.travelInformation!.stayAddress.isEmpty
                ? "No indicada"
                : expediente.travelInformation!.stayAddress}\n"
                "Quién paga el viaje: "
                "${expediente.travelInformation!.personPayingTrip}\n"
                "Relación con quien paga: "
                "${expediente.travelInformation!.payerRelationship.isEmpty
                ? "No indicada"
                : expediente.travelInformation!.payerRelationship}"
                : "Información no completada",
          ),

          _section(
            title: "Historial de Viajes",
            icon: Icons.flight_takeoff,
            information: expediente.travelHistory != null
                ? "¿Ha viajado anteriormente?: "
                "${expediente.travelHistory!.hasTraveledBefore ? "Sí" : "No"}\n"
                "Países visitados: "
                "${expediente.travelHistory!.countriesVisited.isEmpty ? "Ninguno indicado" : expediente.travelHistory!.countriesVisited}\n"
                "Motivo de los viajes: "
                "${expediente.travelHistory!.travelPurpose.isEmpty ? "No indicado" : expediente.travelHistory!.travelPurpose}\n"
                "¿Tuvo visa estadounidense?: "
                "${expediente.travelHistory!.hadAmericanVisa ? "Sí" : "No"}\n"
                "¿Visa estadounidense denegada?: "
                "${expediente.travelHistory!.visaDenied ? "Sí" : "No"}\n"
                "¿Ha sido deportado?: "
                "${expediente.travelHistory!.deported ? "Sí" : "No"}"
                : "Información no completada",
          ),

          _section(
            title: "Acompañante de Viaje",
            icon: Icons.people,
            information: expediente.travelingWithOthers == true
                ? expediente.travelCompanions.isNotEmpty
                ? expediente.travelCompanions
                .map(
                  (companion) =>
              "Nombre: ${companion.fullName}\n"
                  "Parentesco: ${companion.relationship}\n"
                  "Viaja con el solicitante: "
                  "${companion.travelingWithApplicant ? "Sí" : "No"}",
            )
                .join("\n\n")
                : "Viaja acompañado, pero no hay compañeros registrados."
                : "Viaja solo",
          ),

          _section(
            title: "Información Familiar",
            icon: Icons.family_restroom,
            information: expediente.familyInformation != null
                ? "Padre: ${expediente.familyInformation!.fatherGivenNames} "
                "${expediente.familyInformation!.fatherSurname}\n"
                "Padre en EE.UU.: "
                "${expediente.familyInformation!.fatherInUs ? "Sí" : "No"}\n"
                "Estatus del padre: "
                "${expediente.familyInformation!.fatherStatus}\n"
                "Madre: ${expediente.familyInformation!.motherGivenNames} "
                "${expediente.familyInformation!.motherSurname}\n"
                "Madre en EE.UU.: "
                "${expediente.familyInformation!.motherInUs ? "Sí" : "No"}\n"
                "Estatus de la madre: "
                "${expediente.familyInformation!.motherStatus}\n"
                "Familiares inmediatos en EE.UU.: "
                "${expediente.familyInformation!.hasImmediateRelatives ? "Sí" : "No"}\n"
                "Familiar: "
                "${expediente.familyInformation!.immediateRelativeName}\n"
                "Parentesco: "
                "${expediente.familyInformation!.immediateRelativeRelationship}\n"
                "Estatus: "
                "${expediente.familyInformation!.immediateRelativeStatus}"
                : "Información no completada",
          ),

          _section(
            title: "Seguridad y Antecedentes",
            icon: Icons.security,
            information: expediente.securityBackground != null
                ? "Enfermedad contagiosa: "
                "${expediente.securityBackground!.hasCommunicableDisease ? "Sí" : "No"}\n"
                "Trastorno mental: "
                "${expediente.securityBackground!.hasMentalDisorder ? "Sí" : "No"}\n"
                "Uso de drogas: "
                "${expediente.securityBackground!.drugAbuser ? "Sí" : "No"}\n"
                "Antecedentes criminales: "
                "${expediente.securityBackground!.arrestedOrConvicted ? "Sí" : "No"}\n"
                "Violación de leyes sobre sustancias controladas: "
                "${expediente.securityBackground!.violatedControlledSubstancesLaw ? "Sí" : "No"}\n"
                "Prostitución o actividades relacionadas: "
                "${expediente.securityBackground!.prostitutionOrVice ? "Sí" : "No"}\n"
                "Lavado de dinero: "
                "${expediente.securityBackground!.moneyLaundering ? "Sí" : "No"}\n"
                "Espionaje: "
                "${expediente.securityBackground!.espionage ? "Sí" : "No"}\n"
                "Terrorismo: "
                "${expediente.securityBackground!.terrorism ? "Sí" : "No"}\n"
                "Genocidio: "
                "${expediente.securityBackground!.genocide ? "Sí" : "No"}\n"
                "Tortura: "
                "${expediente.securityBackground!.torture ? "Sí" : "No"}\n"
                "Niño soldado: "
                "${expediente.securityBackground!.childSoldier ? "Sí" : "No"}\n"
                "Fraude de visa: "
                "${expediente.securityBackground!.visaFraud ? "Sí" : "No"}\n"
                "Deportación: "
                "${expediente.securityBackground!.deported ? "Sí" : "No"}\n"
                "Presencia ilegal: "
                "${expediente.securityBackground!.unlawfullyPresent ? "Sí" : "No"}"
                : "Información no completada",
          ),

          _section(
            title: "Información Adicional",
            icon: Icons.description,
            information: expediente.additionalInformation != null
                ? "Idiomas: "
                "${expediente.additionalInformation!.languages.isEmpty ? "No indicado" : expediente.additionalInformation!.languages}\n"
                "Redes sociales: "
                "${expediente.additionalInformation!.socialNetworks.isEmpty ? "No indicado" : expediente.additionalInformation!.socialNetworks}\n"
                "Usuario: "
                "${expediente.additionalInformation!.socialMediaUsername.isEmpty ? "No indicado" : expediente.additionalInformation!.socialMediaUsername}\n"
                "Información adicional: "
                "${expediente.additionalInformation!.additionalNotes.isEmpty ? "No indicada" : expediente.additionalInformation!.additionalNotes}"
                : "Información no completada",
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.blue.shade100,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "¿Qué sucede después?",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 18),

                Text(
                  "• Nuestro equipo revisará cuidadosamente toda la información de tu expediente.",
                  style: TextStyle(
                    height: 1.6,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "• Si necesitamos información o documentos adicionales, nos comunicaremos con usted a través del chat de Visa Assist o por WhatsApp.",
                  style: TextStyle(
                    height: 1.6,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "• Una vez tu expediente esté completo iniciaremos la preparación del formulario DS-160 y la creación de tu perfil CAS.",
                  style: TextStyle(
                    height: 1.6,
                  ),
                ),

                SizedBox(height: 18),

                Text(
                  "Mantén activas las notificaciones para no perder ninguna solicitud de nuestro equipo.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text(
                "CONTINUAR AL PAGO",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServicePaymentScreen(
                      expedienteId: expediente.id,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    String? information,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(.10),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          information ?? "Información pendiente de mostrar.",
          style: const TextStyle(
            color: Colors.grey,
            height: 1.4,
          ),
        ),
        trailing: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
      ),
    );
  }
}