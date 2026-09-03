import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _users =>
      _db.collection("users");

  //==================================================
  // OBTENER UN USUARIO
  //==================================================

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return AppUser.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  //==================================================
  // STREAM DE USUARIO
  //==================================================

  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }

      return AppUser.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    });
  }

  //==================================================
  // CREAR USUARIO
  //==================================================

  Future<void> createUser(AppUser user) async {
    await _users.doc(user.uid).set(
      user.toMap(),
    );
  }

  //==================================================
  // ACTUALIZAR USUARIO
  //==================================================

  Future<void> updateUser(AppUser user) async {
    await _users.doc(user.uid).update(
      user.toMap(),
    );
  }

  //==================================================
  // CAMBIAR ESTADO
  //==================================================

  Future<void> updateStatus({
    required String uid,
    required String status,
  }) async {
    await _users.doc(uid).update({
      "status": status,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // CAMBIAR AGENTE ASIGNADO
  //==================================================

  Future<void> assignAgent({
    required String uid,
    required String agentId,
  }) async {
    await _users.doc(uid).update({
      "assignedAgentId": agentId,
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // LISTAR CLIENTES
  //==================================================

  Stream<List<AppUser>> getClients() {
    return _users
        .where("role", isEqualTo: "client")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => AppUser.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ),
      )
          .toList(),
    );
  }

  //==================================================
  // LISTAR AGENTES
  //==================================================

  Stream<List<AppUser>> getAgents() {
    return _users
        .where("role", isEqualTo: "agent")
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => AppUser.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        ),
      )
          .toList(),
    );
  }

  //==================================================
  // BUSCAR POR EMAIL
  //==================================================

  Future<AppUser?> getUserByEmail(
      String email,
      ) async {
    final result = await _users
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    return AppUser.fromMap(
      result.docs.first.data() as Map<String, dynamic>,
      result.docs.first.id,
    );
  }

  //==================================================
  // EXISTE USUARIO
  //==================================================

  Future<bool> exists(String uid) async {
    final doc = await _users.doc(uid).get();

    return doc.exists;
  }

  //==================================================
  // ELIMINAR USUARIO
  //==================================================

  Future<void> deleteUser(
      String uid,
      ) async {
    await _users.doc(uid).delete();
  }
}