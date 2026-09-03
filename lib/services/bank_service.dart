import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bank_account.dart';

class BankService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
  get _collection =>
      _firestore.collection("bank_accounts");

  //==========================================
  // OBTENER TODOS LOS BANCOS
  //==========================================

  Future<List<BankAccount>> getBanks({
    bool onlyEnabled = false,
  }) async {
    Query<Map<String, dynamic>> query =
    _collection.orderBy("order");

    if (onlyEnabled) {
      query = query.where(
        "enabled",
        isEqualTo: true,
      );
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map(
          (doc) => BankAccount.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  //==========================================
  // ESCUCHAR BANCOS
  //==========================================

  Stream<List<BankAccount>> watchBanks({
    bool onlyEnabled = false,
  }) {
    Query<Map<String, dynamic>> query =
    _collection.orderBy("order");

    if (onlyEnabled) {
      query = query.where(
        "enabled",
        isEqualTo: true,
      );
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => BankAccount.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList(),
    );
  }

  //==========================================
  // OBTENER UN BANCO
  //==========================================

  Future<BankAccount?> getBank(
      String bankId,
      ) async {
    final doc =
    await _collection.doc(bankId).get();

    if (!doc.exists) return null;

    return BankAccount.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  //==========================================
  // CREAR
  //==========================================

  Future<void> createBank(
      BankAccount bank,
      ) async {
    await _collection
        .doc(bank.id)
        .set(bank.toMap());
  }

  //==========================================
  // ACTUALIZAR
  //==========================================

  Future<void> updateBank(
      BankAccount bank,
      ) async {
    await _collection
        .doc(bank.id)
        .update(bank.toMap());
  }

  //==========================================
  // ELIMINAR
  //==========================================

  Future<void> deleteBank(
      String bankId,
      ) async {
    await _collection
        .doc(bankId)
        .delete();
  }

  //==========================================
  // ACTIVAR / DESACTIVAR
  //==========================================

  Future<void> setEnabled({
    required String bankId,
    required bool enabled,
  }) async {
    await _collection.doc(bankId).update({
      "enabled": enabled,
      "updatedAt": Timestamp.now(),
    });
  }
}