import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;

  final String name;

  final String lastName;

  final String email;

  final String phone;

  final String photo;

  /// admin | agent | client
  final String role;

  /// active | inactive | suspended
  final String status;

  final String country;

  final String language;

  /// Solo aplica para clientes
  final String assignedAgentId;

  final Timestamp createdAt;

  final Timestamp updatedAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.photo,
    required this.role,
    required this.status,
    required this.country,
    required this.language,
    required this.assignedAgentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return AppUser(
      uid: id,
      name: map["name"] ?? "",
      lastName: map["lastName"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
      photo: map["photo"] ?? "",
      role: map["role"] ?? "client",
      status: map["status"] ?? "active",
      country: map["country"] ?? "",
      language: map["language"] ?? "es",
      assignedAgentId: map["assignedAgentId"] ?? "",
      createdAt: map["createdAt"] ?? Timestamp.now(),
      updatedAt: map["updatedAt"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "photo": photo,
      "role": role,
      "status": status,
      "country": country,
      "language": language,
      "assignedAgentId": assignedAgentId,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  AppUser copyWith({
    String? uid,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? photo,
    String? role,
    String? status,
    String? country,
    String? language,
    String? assignedAgentId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      status: status ?? this.status,
      country: country ?? this.country,
      language: language ?? this.language,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}