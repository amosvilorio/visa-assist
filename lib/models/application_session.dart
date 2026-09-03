import 'applicant.dart';

class ApplicationSession {
  final String? expedienteId;

  final String? countryCode;
  final String? countryName;

  final String? visaType;

  final Applicant? applicant;

  final Map<String, dynamic> personalInformation;

  const ApplicationSession({
    this.expedienteId,
    this.countryCode,
    this.countryName,
    this.visaType,
    this.applicant,
    this.personalInformation = const {},
  });

  ApplicationSession copyWith({
    String? expedienteId,
    String? countryCode,
    String? countryName,
    String? visaType,
    Applicant? applicant,
    Map<String, dynamic>? personalInformation,
  }) {
    return ApplicationSession(
      expedienteId: expedienteId ?? this.expedienteId,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      visaType: visaType ?? this.visaType,
      applicant: applicant ?? this.applicant,
      personalInformation:
      personalInformation ?? this.personalInformation,
    );
  }
}