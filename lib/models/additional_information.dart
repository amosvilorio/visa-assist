class AdditionalInformation {
  /// Idiomas que habla
  final String languages;

  /// Redes sociales utilizadas
  final String socialNetworks;

  /// Nombre(s) de usuario
  final String socialMediaUsername;

  /// Información adicional opcional
  final String additionalNotes;

  const AdditionalInformation({
    this.languages = '',
    this.socialNetworks = '',
    this.socialMediaUsername = '',
    this.additionalNotes = '',
  });

  AdditionalInformation copyWith({
    String? languages,
    String? socialNetworks,
    String? socialMediaUsername,
    String? additionalNotes,
  }) {
    return AdditionalInformation(
      languages: languages ?? this.languages,
      socialNetworks: socialNetworks ?? this.socialNetworks,
      socialMediaUsername:
      socialMediaUsername ?? this.socialMediaUsername,
      additionalNotes:
      additionalNotes ?? this.additionalNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'languages': languages,
      'socialNetworks': socialNetworks,
      'socialMediaUsername': socialMediaUsername,
      'additionalNotes': additionalNotes,
    };
  }

  factory AdditionalInformation.fromMap(
      Map<String, dynamic> map) {
    return AdditionalInformation(
      languages: map['languages'] ?? '',
      socialNetworks: map['socialNetworks'] ?? '',
      socialMediaUsername:
      map['socialMediaUsername'] ?? '',
      additionalNotes:
      map['additionalNotes'] ?? '',
    );
  }
}