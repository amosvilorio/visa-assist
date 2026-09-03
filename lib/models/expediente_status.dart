enum ExpedienteStatus {
  draft,
  inProgress,
  completed,
  cancelled,
}

extension ExpedienteStatusExtension on ExpedienteStatus {
  String get value {
    switch (this) {
      case ExpedienteStatus.draft:
        return "draft";

      case ExpedienteStatus.inProgress:
        return "in_progress";

      case ExpedienteStatus.completed:
        return "completed";

      case ExpedienteStatus.cancelled:
        return "cancelled";
    }
  }

  String get label {
    switch (this) {
      case ExpedienteStatus.draft:
        return "Borrador";

      case ExpedienteStatus.inProgress:
        return "En proceso";

      case ExpedienteStatus.completed:
        return "Completado";

      case ExpedienteStatus.cancelled:
        return "Cancelado";
    }
  }

  static ExpedienteStatus fromString(String value) {
    switch (value) {
      case "draft":
        return ExpedienteStatus.draft;

      case "completed":
        return ExpedienteStatus.completed;

      case "cancelled":
        return ExpedienteStatus.cancelled;

      default:
        return ExpedienteStatus.inProgress;
    }
  }
}