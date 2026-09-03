import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportChatService {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>
  get _conversations =>
      _db.collection('support_conversations');

  // ============================================================
  // CONVERSACIÓN DEL CLIENTE ACTUAL
  // ============================================================

  DocumentReference<Map<String, dynamic>>
  get currentConversation {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un usuario autenticado.',
      );
    }

    return _conversations.doc(user.uid);
  }

  // ============================================================
  // OBTENER DATOS DEL CLIENTE
  // ============================================================

  Future<void> createOrUpdateConversation() async {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un usuario autenticado.',
      );
    }

    final doc =
    await _conversations
        .doc(user.uid)
        .get();

    if (!doc.exists) {

      await _conversations
          .doc(user.uid)
          .set({

        'clientId':
        user.uid,

        'clientEmail':
        user.email ?? '',

        'lastMessage':
        '',

        'lastMessageAt':
        FieldValue.serverTimestamp(),

        'unreadForAdmin':
        false,

        'unreadForClient':
        false,

        'createdAt':
        FieldValue.serverTimestamp(),

      });

    } else {

      await _conversations
          .doc(user.uid)
          .update({

        'clientEmail':
        user.email ?? '',

      });
    }
  }

  // ============================================================
  // ENVIAR MENSAJE
  // ============================================================

  Future<void> sendMessage({
    required String text,
    required String senderRole,
  }) async {

    final message =
    text.trim();

    if (message.isEmpty) {
      return;
    }

    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un usuario autenticado.',
      );
    }

    await createOrUpdateConversation();

    final conversationRef =
    _conversations.doc(user.uid);

    final messageRef =
    conversationRef
        .collection('messages')
        .doc();

    final batch =
    _db.batch();

    batch.set(
      messageRef,
      {

        'id':
        messageRef.id,

        'text':
        message,

        'senderId':
        user.uid,

        'senderRole':
        senderRole,

        'createdAt':
        FieldValue.serverTimestamp(),

      },
    );

    batch.update(
      conversationRef,
      {

        'lastMessage':
        message,

        'lastMessageAt':
        FieldValue.serverTimestamp(),

        if (senderRole == 'client')
          'unreadForAdmin':
          true,

        if (senderRole == 'admin')
          'unreadForClient':
          true,

      },
    );

    await batch.commit();
  }

  // ============================================================
  // MENSAJES DEL CLIENTE
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  clientMessages() {

    return currentConversation
        .collection('messages')
        .orderBy(
      'createdAt',
      descending: false,
    )
        .snapshots();
  }

  // ============================================================
  // CONVERSACIONES PARA ADMIN
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  adminConversations() {

    return _conversations
        .orderBy(
      'lastMessageAt',
      descending: true,
    )
        .snapshots();
  }

  // ============================================================
  // MENSAJES DE UNA CONVERSACIÓN
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
  adminMessages(
      String clientId,
      ) {

    return _conversations
        .doc(clientId)
        .collection('messages')
        .orderBy(
      'createdAt',
      descending: false,
    )
        .snapshots();
  }

  // ============================================================
  // MARCAR COMO LEÍDO POR CLIENTE
  // ============================================================

  Future<void>
  markClientMessagesAsRead() async {

    final user =
        _auth.currentUser;

    if (user == null) {
      return;
    }

    await _conversations
        .doc(user.uid)
        .update({
      'unreadForClient': false,
    });
  }

  // ============================================================
  // MARCAR COMO LEÍDO POR ADMIN
  // ============================================================

  Future<void>
  markAdminMessagesAsRead(
      String clientId,
      ) async {

    await _conversations
        .doc(clientId)
        .update({
      'unreadForAdmin': false,
    });
  }

  // ============================================================
  // ENVIAR MENSAJE COMO ADMINISTRADOR
  // ============================================================

  Future<void> sendMessageAsAdmin({
    required String clientId,
    required String text,
  }) async {

    final message =
    text.trim();

    if (message.isEmpty) {
      return;
    }

    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No hay un administrador autenticado.',
      );
    }

    final conversationRef =
    _conversations.doc(clientId);

    final messageRef =
    conversationRef
        .collection('messages')
        .doc();

    final batch =
    _db.batch();

    batch.set(
      messageRef,
      {
        'id':
        messageRef.id,

        'text':
        message,

        'senderId':
        user.uid,

        'senderRole':
        'admin',

        'createdAt':
        FieldValue.serverTimestamp(),
      },
    );

    batch.update(
      conversationRef,
      {
        'lastMessage':
        message,

        'lastMessageAt':
        FieldValue.serverTimestamp(),

        'unreadForClient':
        true,

        'unreadForAdmin':
        false,
      },
    );

    await batch.commit();
  }
}