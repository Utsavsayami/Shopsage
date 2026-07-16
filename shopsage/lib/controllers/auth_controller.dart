import 'package:flutter/foundation.dart';
import '../models/auth_result.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service;
  AuthController({AuthService? service}) : _service = service ?? AuthService();

  bool isLoading = false;
  String? error;

  Future<AuthResult?> login(String email, String password) async {
    return _run(() => _service.login(email: email, password: password));
  }

  Future<AuthResult?> signup(String name, String email, String password) async {
    return _run(() => _service.signup(name: name, email: email, password: password));
  }

  Future<AuthResult?> forgotPassword(String email) async {
    return _run(() => _service.forgotPassword(email: email));
  }

  Future<AuthResult?> _run(Future<AuthResult> Function() request) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      return await request();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
