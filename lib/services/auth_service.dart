import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn =
  GoogleSignIn(
    serverClientId:
    '462394857537-i39gvuimgevlp6aikje2g7n1gl4c019n.apps.googleusercontent.com',
  );

  CollectionReference get _users =>
      _db.collection("users");

  //==================================================
  // CLAVE PARA GUARDAR EL ROL LOCALMENTE
  //
  // Se mantiene únicamente por compatibilidad.
  // NO se utilizará para decidir el panel.
  //==================================================

  static const String _roleKey =
      "visa_assist_user_role";

  //==================================================
  // USUARIO ACTUAL
  //==================================================

  User? get currentUser =>
      _auth.currentUser;

  bool get isLogged =>
      _auth.currentUser != null;

  //==================================================
  // REGISTRO CLIENTE
  //==================================================

  Future<String?> register({
    required String nombre,
    required String apellido,
    required String email,
    required String telefono,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = AppUser(
        uid: credential.user!.uid,
        name: nombre.trim(),
        lastName: apellido.trim(),
        email: email.trim(),
        phone: telefono.trim(),
        photo: "",
        role: "client",
        status: "active",
        country: "",
        language: "es",
        assignedAgentId: "",
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _users
          .doc(credential.user!.uid)
          .set(user.toMap());

      await _saveRoleLocally("client");

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //==================================================
  // LOGIN
  //==================================================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return "No se pudo obtener el usuario.";
      }

      final uid = firebaseUser.uid;

      print("==========================================");
      print("LOGIN NORMAL");
      print("UID: $uid");
      print("EMAIL: ${firebaseUser.email}");
      print("==========================================");

      //==================================================
      // VERIFICAR USUARIO EN FIRESTORE
      //==================================================

      final userRef = _users.doc(uid);

      final doc = await userRef.get();

      if (!doc.exists) {
        //================================================
        // SEGURIDAD:
        // Si por alguna razón Authentication tiene el
        // usuario pero Firestore no, lo reconstruimos
        // como cliente.
        //================================================

        final user = AppUser(
          uid: uid,
          name: firebaseUser.displayName ?? "",
          lastName: "",
          email: firebaseUser.email ?? email.trim(),
          phone: firebaseUser.phoneNumber ?? "",
          photo: firebaseUser.photoURL ?? "",
          role: "client",
          status: "active",
          country: "",
          language: "es",
          assignedAgentId: "",
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        await userRef.set(
          user.toMap(),
        );

        await _saveRoleLocally("client");

        print(
          "LOGIN: USUARIO FALTANTE CREADO EN FIRESTORE "
              "users/$uid",
        );
      } else {
        final data =
        doc.data() as Map<String, dynamic>;

        final role =
        data["role"]?.toString();

        if (role != null && role.isNotEmpty) {
          await _saveRoleLocally(role);
        }

        print(
          "LOGIN: USUARIO ENCONTRADO EN FIRESTORE",
        );

        print(
          "LOGIN: ROL: $role",
        );
      }

      //==================================================
      // INICIALIZAR FCM PARA ESTA CUENTA
      //==================================================

      try {
        await NotificationService().initialize();

        print(
          "LOGIN: NOTIFICACIONES INICIALIZADAS "
              "PARA $uid",
        );
      } catch (e) {
        print(
          "LOGIN: ERROR INICIALIZANDO "
              "NOTIFICACIONES: $e",
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //==================================================
// LOGIN CON GOOGLE
//==================================================

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        return "Inicio de sesión cancelado.";
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return "No se pudo obtener el usuario de Google.";
      }

      final uid = firebaseUser.uid;

      print("==========================================");
      print("GOOGLE LOGIN");
      print("UID: $uid");
      print("EMAIL: ${firebaseUser.email}");
      print("NOMBRE: ${firebaseUser.displayName}");
      print("==========================================");

      //==================================================
      // BUSCAR USUARIO EN FIRESTORE
      //==================================================

      final userRef = _users.doc(uid);

      final doc = await userRef.get();

      //==================================================
      // SI NO EXISTE, CREARLO COMO CLIENTE
      //==================================================

      if (!doc.exists) {
        final now = Timestamp.now();

        final user = AppUser(
          uid: uid,
          name: firebaseUser.displayName ?? "",
          lastName: "",
          email: firebaseUser.email ?? "",
          phone: firebaseUser.phoneNumber ?? "",
          photo: firebaseUser.photoURL ?? "",
          role: "client",
          status: "active",
          country: "",
          language: "es",
          assignedAgentId: "",
          createdAt: now,
          updatedAt: now,
        );

        await userRef.set(
          user.toMap(),
        );

        print(
          "GOOGLE: USUARIO CREADO EN FIRESTORE "
              "users/$uid",
        );

        await _saveRoleLocally("client");
      } else {
        //================================================
        // EL USUARIO YA EXISTE
        // NO CAMBIAMOS SU ROL
        //================================================

        final data =
        doc.data() as Map<String, dynamic>;

        final role =
        data["role"]?.toString();

        print(
          "GOOGLE: USUARIO YA EXISTE EN FIRESTORE",
        );

        print(
          "GOOGLE: ROL ACTUAL: $role",
        );

        if (role != null && role.isNotEmpty) {
          await _saveRoleLocally(role);
        }

        // Actualizamos solamente información que puede
        // venir de Google sin tocar el rol.
        await userRef.set(
          {
            "email": firebaseUser.email ?? "",
            "updatedAt": Timestamp.now(),
          },
          SetOptions(merge: true),
        );
      }

      //==================================================
      // INICIALIZAR FCM PARA ESTA CUENTA
      //==================================================

      try {
        await NotificationService().initialize();

        print(
          "GOOGLE: NOTIFICACIONES INICIALIZADAS "
              "PARA $uid",
        );
      } catch (e) {
        print(
          "GOOGLE: ERROR INICIALIZANDO "
              "NOTIFICACIONES: $e",
        );
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print(
        "ERROR FIREBASE GOOGLE: ${e.message}",
      );

      return e.message;
    } catch (e) {
      print(
        "ERROR LOGIN GOOGLE: $e",
      );

      return e.toString();
    }
  }

  //==================================================
  // OBTENER APP USER
  //==================================================

  Future<AppUser?> getCurrentAppUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final doc = await _users
          .doc(user.uid)
          .get()
          .timeout(
        const Duration(seconds: 5),
      );

      if (!doc.exists) {
        return null;
      }

      return AppUser.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      print(
        "No se pudo obtener AppUser desde Firestore: $e",
      );

      return null;
    }
  }

  //==================================================
  // OBTENER ROL
  //
  // ESTA ES AHORA LA FUENTE DE VERDAD.
  //
  // Siempre utiliza:
  //
  // FirebaseAuth.currentUser.uid
  //              ↓
  // users/{uid}
  //              ↓
  // role
  //
  // Nunca usa SharedPreferences para decidir
  // si es admin, agent o client.
  //==================================================

  Future<String?> getCurrentRole() async {
    final user = _auth.currentUser;

    if (user == null) {
      print("GET ROLE: NO HAY USUARIO");
      return null;
    }

    final uid = user.uid;

    print(
      "GET ROLE UID: $uid",
    );

    try {
      final doc = await _users
          .doc(uid)
          .get()
          .timeout(
        const Duration(seconds: 5),
      );

      if (!doc.exists) {
        print(
          "GET ROLE: NO EXISTE users/$uid",
        );

        return null;
      }

      final data =
      doc.data() as Map<String, dynamic>;

      final role =
      data["role"]?.toString();

      print(
        "GET ROLE FIRESTORE: $role",
      );

      if (role == null ||
          role.isEmpty) {
        return null;
      }

      // Lo guardamos solamente como respaldo.
      await _saveRoleLocally(role);

      return role;
    } catch (e) {
      print(
        "ERROR OBTENIENDO ROL: $e",
      );

      return null;
    }
  }

  //==================================================
  // GUARDAR ROL LOCAL
  //
  // Compatibilidad.
  // NO determina el panel.
  //==================================================

  Future<void> _saveRoleLocally(
      String role,
      ) async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        _roleKey,
        role,
      );
    } catch (e) {
      print(
        "No se pudo guardar rol local: $e",
      );
    }
  }

  //==================================================
  // OBTENER ROL LOCAL
  //
  // Se mantiene por compatibilidad.
  //==================================================

  Future<String?> _getLocalRole() async {
    try {
      final prefs =
      await SharedPreferences.getInstance();

      return prefs.getString(_roleKey);
    } catch (e) {
      return null;
    }
  }

  //==================================================
  // USUARIO ACTIVO
  //==================================================

  Future<bool> isUserActive() async {
    final user =
    await getCurrentAppUser();

    if (user == null) {
      return false;
    }

    return user.status == "active";
  }

  //==================================================
  // ENVIAR CORREO PARA RECUPERAR CONTRASEÑA
  //==================================================

  Future<String?> sendPasswordResetEmail(
      String email,
      ) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //==================================================
  // ACTUALIZAR ÚLTIMO ACCESO
  //==================================================

  Future<void> updateLastLogin() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      await _users
          .doc(user.uid)
          .update({
        "lastLogin": Timestamp.now(),
        "updatedAt": Timestamp.now(),
      }).timeout(
        const Duration(seconds: 5),
      );
    } catch (e) {
      print(
        "No se pudo actualizar último acceso: $e",
      );
    }
  }

  //==================================================
  // CERRAR SESIÓN
  //==================================================

  Future<void> logout() async {
    print(
      "ANTES DEL LOGOUT UID: "
          "${_auth.currentUser?.uid}",
    );

    //==================================================
    // ELIMINAR TOKEN FCM DE LA CUENTA ACTUAL
    //==================================================

    try {
      await NotificationService().clearToken();

      print(
        "FCM TOKEN ELIMINADO ANTES DEL LOGOUT.",
      );
    } catch (e) {
      print(
        "ERROR ELIMINANDO FCM TOKEN: $e",
      );
    }

    //==================================================
    // CERRAR SESIÓN DE GOOGLE
    //==================================================

    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(
        "Error cerrando Google: $e",
      );
    }

    //==================================================
    // CERRAR SESIÓN FIREBASE
    //==================================================

    await _auth.signOut();

    //==================================================
    // ELIMINAR ROL LOCAL
    //==================================================

    try {
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.remove(_roleKey);
    } catch (e) {
      print(
        "No se pudo eliminar rol local: $e",
      );
    }

    print(
      "DESPUÉS DEL LOGOUT UID: "
          "${_auth.currentUser?.uid}",
    );
  }

  //==================================================
  // VERIFICAR SI HAY SESIÓN
  //==================================================

  bool hasSession() {
    return _auth.currentUser != null;
  }

  //==================================================
  // STREAM DEL USUARIO AUTENTICADO
  //==================================================

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}