class OptionTemplates {
  static final Map<String, List<String>> templates = {
    //====================================================
    // INFORMACIÓN PERSONAL
    //====================================================

    "estado civil": [
      "Soltero(a)",
      "Casado(a)",
      "Unión libre",
      "Divorciado(a)",
      "Viudo(a)",
    ],

    "sexo": [
      "Masculino",
      "Femenino",
    ],

    "nivel educativo": [
      "Primaria",
      "Secundaria",
      "Técnico",
      "Universitario",
      "Maestría",
      "Doctorado",
    ],

    //====================================================
    // TRABAJO
    //====================================================

    "situación laboral": [
      "Empleado",
      "Independiente",
      "Empresario",
      "Estudiante",
      "Pensionado",
      "Desempleado",
      "Ama de casa",
    ],

    "ocupación": [
      "Empleado privado",
      "Empleado público",
      "Profesional",
      "Comerciante",
      "Empresario",
      "Independiente",
      "Estudiante",
      "Ama de casa",
      "Pensionado",
      "Desempleado",
      "Otro",
    ],

    "tipo de empleo": [
      "Tiempo completo",
      "Medio tiempo",
      "Temporal",
      "Contrato",
      "Independiente",
    ],

    "tiempo trabajando": [
      "Menos de 6 meses",
      "6 meses a 1 año",
      "1 a 2 años",
      "2 a 5 años",
      "Más de 5 años",
    ],

    //====================================================
    // INGRESOS
    //====================================================

    "ingresos mensuales": [
      "Menos de US\$500",
      "US\$500 - US\$999",
      "US\$1,000 - US\$1,999",
      "US\$2,000 - US\$2,999",
      "US\$3,000 - US\$4,999",
      "Más de US\$5,000",
    ],

    //====================================================
    // BIENES
    //====================================================

    "bienes": [
      "Casa",
      "Apartamento",
      "Terreno",
      "Vehículo",
      "Empresa",
      "Finca",
      "Local comercial",
      "Ninguno",
    ],

    "tipo de vivienda": [
      "Propia",
      "Alquilada",
      "Familiar",
      "Prestada",
    ],

    //====================================================
    // VIAJE
    //====================================================

    "motivo del viaje": [
      "Turismo",
      "Negocios",
      "Estudios",
      "Visita familiar",
      "Tratamiento médico",
      "Conferencia",
      "Evento",
      "Otro",
    ],

    "quien pagara el viaje": [
      "Yo mismo",
      "Padres",
      "Esposo(a)",
      "Familiar",
      "Empresa",
      "Patrocinador",
    ],

    "duración del viaje": [
      "Menos de 1 semana",
      "1 a 2 semanas",
      "2 a 4 semanas",
      "1 a 3 meses",
      "Más de 3 meses",
    ],

    //====================================================
    // FAMILIARES
    //====================================================

    "relación familiar": [
      "Padre",
      "Madre",
      "Hermano(a)",
      "Hijo(a)",
      "Abuelo(a)",
      "Tío(a)",
      "Primo(a)",
      "Esposo(a)",
      "Otro",
    ],

    "estatus migratorio": [
      "Ciudadano",
      "Residente permanente",
      "Visa temporal",
      "Indocumentado",
    ],

    //====================================================
    // VISA
    //====================================================

    "tipo de visa": [
      "Turismo (B1/B2)",
      "Trabajo",
      "Estudiante",
      "Intercambio",
      "Residencia",
      "Otro",
    ],

    "resultado de solicitud": [
      "Nunca he solicitado",
      "Aprobada",
      "Rechazada",
      "Cancelada",
    ],

    "motivo del rechazo": [
      "Sección 214(b)",
      "Documentación insuficiente",
      "Información inconsistente",
      "Fondos insuficientes",
      "Otro",
    ],

    //====================================================
    // VIAJES
    //====================================================

    "continente visitado": [
      "América",
      "Europa",
      "Asia",
      "África",
      "Oceanía",
    ],

    //====================================================
    // ANTECEDENTES
    //====================================================

    "antecedentes penales": [
      "No tengo antecedentes penales",
      "Sí, en mi país",
      "Sí, en otro país",
      "Prefiero no responder",
    ],

    "estado del proceso penal": [
      "Nunca he tenido un proceso",
      "Caso cerrado",
      "Caso pendiente",
      "Cumplí la condena",
      "Otro",
    ],

    //====================================================
    // DOCUMENTOS
    //====================================================

    "pasaporte": [
      "Vigente",
      "Vencido",
      "Nunca he tenido pasaporte",
    ],

    //====================================================
    // IDIOMAS
    //====================================================

    "idioma": [
      "Español",
      "Inglés",
      "Francés",
      "Portugués",
      "Otro",
    ],
  };

  static List<String>? findTemplate(String question) {
    final key = question.toLowerCase().trim();

    for (final item in templates.entries) {
      if (key.contains(item.key)) {
        return List<String>.from(item.value);
      }
    }

    return null;
  }
}