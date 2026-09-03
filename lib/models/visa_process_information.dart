class VisaProcessInformation {

  final String? ds160PdfUrl;
  final String? ds160FileName;

  final String? casUsername;

  final String? casPassword;

  final String? casDate;

  final String? casTime;

  final String? interviewDate;

  final String? interviewTime;

  final String? interviewLocation;

  const VisaProcessInformation({

    this.ds160PdfUrl,
    this.ds160FileName,

    this.casUsername,

    this.casPassword,

    this.casDate,

    this.casTime,

    this.interviewDate,

    this.interviewTime,

    this.interviewLocation,

  });

  factory VisaProcessInformation.fromMap(
      Map<String, dynamic> map,
      ) {

    return VisaProcessInformation(

      ds160PdfUrl:
      map["ds160PdfUrl"],

      ds160FileName:
      map["ds160FileName"],

      casUsername:
      map["casUsername"],

      casPassword:
      map["casPassword"],

      casDate:
      map["casDate"],

      casTime:
      map["casTime"],

      interviewDate:
      map["interviewDate"],

      interviewTime:
      map["interviewTime"],

      interviewLocation:
      map["interviewLocation"],

    );
  }

  Map<String, dynamic> toMap() {

    return {

      "ds160PdfUrl":
      ds160PdfUrl,

      "ds160FileName":
      ds160FileName,

      "casUsername":
      casUsername,

      "casPassword":
      casPassword,

      "casDate":
      casDate,

      "casTime":
      casTime,

      "interviewDate":
      interviewDate,

      "interviewTime":
      interviewTime,

      "interviewLocation":
      interviewLocation,

    };
  }

  VisaProcessInformation copyWith({

    String? ds160PdfUrl,

    String? ds160FileName,

    String? casUsername,

    String? casPassword,

    String? casDate,

    String? casTime,

    String? interviewDate,

    String? interviewTime,

    String? interviewLocation,

  }) {

    return VisaProcessInformation(

      ds160PdfUrl:
      ds160PdfUrl ??
          this.ds160PdfUrl,

      ds160FileName:
      ds160FileName ??
          this.ds160FileName,

      casUsername:
      casUsername ??
          this.casUsername,

      casPassword:
      casPassword ??
          this.casPassword,

      casDate:
      casDate ??
          this.casDate,

      casTime:
      casTime ??
          this.casTime,

      interviewDate:
      interviewDate ??
          this.interviewDate,

      interviewTime:
      interviewTime ??
          this.interviewTime,

      interviewLocation:
      interviewLocation ??
          this.interviewLocation,

    );
  }
}

