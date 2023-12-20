import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/View/Widget/Button.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/View/Widget/Dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  late AuthProvider auth;
  late int _userId;
  late String _password;
  late String _name;
  late String _email;
  late int _enroll;

  void tryregister() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      auth
          .register(_userId, _password, _name, _email, _enroll, null)
          .then((loginStatus) {
        if (auth.registeredInStatus == AuthStatus.Registered) {
          shortDialog("회원가입 성공", auth.message, context);

          Navigator.pushReplacementNamed(context, '/login');
        } else if (auth.registeredInStatus == AuthStatus.NotRegistered) {
          shortDialog("회원가입 실패", auth.message, context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);

    final usernameField = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Empty!';
        if (value!.contains(RegExp(r'[^0-9]'))) return 'Not Number!';
        return null;
      },
      onSaved: (value) => _userId = int.parse(value!),
      decoration: buildInputDecoration("ID", Icons.person),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Empty!';
        return null;
      },
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Password", Icons.lock),
    );
    final emailField = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Empty!';
        if (!value!.contains('@')) return 'Not email!';
        return null;
      },
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("email", Icons.email),
    );
    final nameField = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Empty!';
        return null;
      },
      onSaved: (value) => _name = value!,
      decoration: buildInputDecoration("name", Icons.person),
    );
    final enrollField = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Empty!';
        return null;
      },
      onSaved: (value) => _enroll = int.parse(value!),
      decoration: buildInputDecoration(
          "Enroll-year", Icons.format_list_numbered_rounded),
    );

    var loading = const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          child: Container(
            color: const Color(0xFFFEE7E7),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SignUp",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                usernameField,
                const SizedBox(height: 15.0),
                passwordField,
                const SizedBox(height: 15.0),
                emailField,
                const SizedBox(height: 15.0),
                nameField,
                const SizedBox(height: 15.0),
                enrollField,
                const SizedBox(height: 15.0),
                auth.loggedInStatus == AuthStatus.Loading
                    ? loading
                    : longButtons("SingUp", tryregister),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
