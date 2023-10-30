import 'package:flutter/foundation.dart';
import 'package:synapsis_survey/data/models/login_model.dart';

class LoginNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  LoginModel? _loginData;

  bool get isLoggedIn => _isLoggedIn;
  LoginModel? get loginData => _loginData;

  Future<void> login(LoginModel loginData) async {
    _isLoggedIn = true;
    _loginData = loginData;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _loginData = null;
    notifyListeners();
  }
}
