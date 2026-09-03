class EvaluationRules {
  const EvaluationRules._();

  //==========================================================
// MÉTODO PRINCIPAL
//==========================================================

  static int calculatePoints(
      String questionKey,
      dynamic answer,
      ) {

    switch (questionKey) {

      case "monthly_income":

        return calculateIncomePoints(
          num.tryParse(answer.toString()) ?? 0,
        );

      case "marital_status":

        return calculateMaritalStatusPoints(
          answer.toString(),
        );

      case "dependent_children":

        return calculateDependentChildrenPoints(
          int.tryParse(answer.toString()) ?? 0,
        );

      case "independent_children":

        return calculateIndependentChildrenPoints(
          int.tryParse(answer.toString()) ?? 0,
        );

      case "employment_years":

        return calculateEmploymentYearsPoints(
          double.tryParse(answer.toString()) ?? 0,
        );

      case "properties":

        return calculatePropertiesPoints(
          int.tryParse(answer.toString()) ?? 0,
        );

      case "vehicles":

        return calculateVehiclesPoints(
          int.tryParse(answer.toString()) ?? 0,
        );

      case "businesses":

        return calculateBusinessPoints(
          int.tryParse(answer.toString()) ?? 0,
        );

      default:

        return 0;

    }

  }

  //==========================================================
  // INGRESOS MENSUALES
  //==========================================================

  static int calculateIncomePoints(num income) {

    if (income >= 0 && income <= 19999) {
      return 0;
    }

    if (income >= 20000 && income <= 29999) {
      return 2;
    }

    if (income >= 30000 && income <= 39999) {
      return 4;
    }

    if (income >= 40000 && income <= 49999) {
      return 6;
    }

    if (income >= 50000 && income <= 74999) {
      return 8;
    }

    if (income >= 75000 && income <= 99999) {
      return 10;
    }

    if (income >= 100000 && income <= 149999) {
      return 12;
    }

    if (income >= 150000 && income <= 199999) {
      return 14;
    }

    return 15;
  }

  //==========================================================
  // ESTADO CIVIL
  //==========================================================

  static int calculateMaritalStatusPoints(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case "casado":
        return 10;

      case "unión libre":
      case "union libre":
        return 8;

      case "divorciado":
        return 6;

      case "viudo":
        return 6;

      case "soltero":
        return 5;

      default:
        return 0;
    }
  }

  //==========================================================
  // HIJOS DEPENDIENTES
  //==========================================================

  static int calculateDependentChildrenPoints(
      int children,
      ) {

    if (children == 0) {
      return 0;
    }

    if (children == 1) {
      return 4;
    }

    if (children == 2) {
      return 6;
    }

    if (children == 3) {
      return 8;
    }

    return 10;
  }

  //==========================================================
  // HIJOS NO DEPENDIENTES
  //==========================================================

  static int calculateIndependentChildrenPoints(
      int children,
      ) {

    if (children == 0) {
      return 0;
    }

    if (children == 1) {
      return 2;
    }

    if (children == 2) {
      return 3;
    }

    return 4;
  }

  //==========================================================
  // TIEMPO EN EL EMPLEO
  //==========================================================

  static int calculateEmploymentYearsPoints(
      double years,
      ) {

    if (years >= 0 && years < 0.5) {
      return 1;
    }

    if (years >= 0.5 && years < 1) {
      return 3;
    }

    if (years >= 1 && years < 2) {
      return 5;
    }

    if (years >= 2 && years < 5) {
      return 8;
    }

    return 10;
  }

  //==========================================================
  // PROPIEDADES
  //==========================================================

  static int calculatePropertiesPoints(
      int properties,
      ) {

    if (properties == 0) {
      return 0;
    }

    if (properties == 1) {
      return 8;
    }

    if (properties == 2) {
      return 12;
    }

    return 15;
  }

  //==========================================================
  // VEHÍCULOS
  //==========================================================

  static int calculateVehiclesPoints(
      int vehicles,
      ) {

    if (vehicles == 0) {
      return 0;
    }

    if (vehicles == 1) {
      return 5;
    }

    if (vehicles == 2) {
      return 8;
    }

    return 10;
  }

  //==========================================================
  // NEGOCIOS
  //==========================================================

  static int calculateBusinessPoints(
      int businesses,
      ) {

    if (businesses == 0) {
      return 0;
    }

    if (businesses == 1) {
      return 8;
    }

    if (businesses == 2) {
      return 12;
    }

    return 15;
  }
}