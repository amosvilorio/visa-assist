import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class AgentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _users =>
      _db.collection("users");

  //==================================================
  // LISTAR AGENTES ACTIVOS
  //==================================================

  Stream<List<AppUser>> getActiveAgents() {
    return _users
        .where("role", isEqualTo: "agent")
        .where("status", isEqualTo: "active")
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
  // OBTENER AGENTE
  //==================================================

  Future<AppUser?> getAgent(
      String uid,
      ) async {
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
  // ACTIVAR AGENTE
  //==================================================

  Future<void> activateAgent(
      String uid,
      ) async {
    await _users.doc(uid).update({
      "status": "active",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // DESACTIVAR AGENTE
  //==================================================

  Future<void> deactivateAgent(
      String uid,
      ) async {
    await _users.doc(uid).update({
      "status": "inactive",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // SUSPENDER AGENTE
  //==================================================

  Future<void> suspendAgent(
      String uid,
      ) async {
    await _users.doc(uid).update({
      "status": "suspended",
      "updatedAt": Timestamp.now(),
    });
  }

  //==================================================
  // ASIGNAR CLIENTE
  //==================================================

  Future<void> assignClient({
    required String clientId,
    required String agentId,
  }) async {
    await _users.doc(clientId).update({
      "assignedAgentId": agentId,
      "updatedAt": Timestamp.now(),
    });
  }
}
