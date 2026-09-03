import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'user_service.dart';

class RoleService {
  RoleService._();

  static final UserService _userService = UserService();

  //==========================================
  // USUARIO ACTUAL
  //==========================================

  static User? get firebaseUser =>
      FirebaseAuth.instance.currentUser;

  static String? get currentUid =>
      firebaseUser?.uid;

  static bool get isLogged =>
      firebaseUser != null;

  //==========================================
  // OBTENER APP USER
  //==========================================

  static Future<AppUser?> currentUser() async {
    if (currentUid == null) {
      return null;
    }

    return await _userService.getUser(
      currentUid!,
    );
  }

  //==========================================
  // OBTENER ROL
  //==========================================

  static Future<String?> currentRole() async {
    final user = await currentUser();

    return user?.role;
  }

  //==========================================
  // ADMINISTRADOR
  //==========================================

  static Future<bool> isAdmin() async {
    return (await currentRole()) == "admin";
  }

  //==========================================
  // AGENTE
  //==========================================

  static Future<bool> isAgent() async {
    return (await currentRole()) == "agent";
  }

  //==========================================
  // CLIENTE
  //==========================================

  static Future<bool> isClient() async {
    return (await currentRole()) == "client";
  }

  //==========================================
  // USUARIO ACTIVO
  //==========================================

  static Future<bool> isActive() async {
    final user = await currentUser();

    return user?.status == "active";
  }

  //==========================================
  // CERRAR SESIÓN
  //==========================================

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}