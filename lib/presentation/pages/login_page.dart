import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsis_survey/common/styles.dart';
import 'package:synapsis_survey/data/models/login_model.dart';
import 'package:synapsis_survey/domain/usecases/post_login.dart';
import 'package:synapsis_survey/injection.dart';
import 'package:synapsis_survey/presentation/pages/survey_page.dart';
import 'package:synapsis_survey/presentation/provider/login_notifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool save = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email and password are required");
      return;
    }

    try {
      final loginEither = await locator<PostLogin>().execute(email, password);

      loginEither.fold(
        (failure) {
          _showSnackBar("Authentication Failed");
        },
        (login) async {
          if (save) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _emailController.text);
            prefs.setString('password', _passwordController.text);
          }

          final loginModel = LoginModel(
            occupationLevel: login.occupationLevel,
            occupationName: login.occupationName,
          );

          locator<LoginNotifier>().login(loginModel);

          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted == true) {
            Navigator.of(context).pushReplacementNamed(SurveyPage.routeName);
          }
        },
      );
    } catch (e) {
      _showSnackBar("An unknown error occurred");
    }
  }


  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Login to Synapsis", style: myTextTheme.titleLarge),
                    const SizedBox(height: 30),
                    const Text("Email", style: TextStyle(color: textColor)),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        hintText: 'Email',
                        hintStyle: myTextTheme.bodySmall?.copyWith(color: textColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Password",
                      style: myTextTheme.titleSmall?.copyWith(color: textColor),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            size: 20,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: 'Password',
                        hintStyle: myTextTheme.bodySmall?.copyWith(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: save,
                      onChanged: (bool? value) {
                        setState(() {
                          save = value!;
                        });
                      },
                      activeColor: textColor,
                      checkColor: primaryColor,
                    ),
                    Text(
                      'Remember me',
                      style: myTextTheme.titleSmall?.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MaterialButton(
                      color: secondaryColor,
                      textTheme: ButtonTextTheme.primary,
                      height: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      onPressed: _handleLogin,
                      child: Text(
                        'Log in',
                        style: myTextTheme.labelLarge?.copyWith(color: primaryColor),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "or",
                          style: myTextTheme.labelLarge?.copyWith(color: secondaryColor),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      onPressed: () => _showSnackBar("This feature will be coming soon!"),
                      child: Text(
                        "Fingerprint",
                        style: myTextTheme.labelLarge?.copyWith(color: secondaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  void _showSnackBar(String errorMessage) {
    final snackBar = SnackBar(content: Text(errorMessage));
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
