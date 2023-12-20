import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/Provider/BoardProvider.dart';
import 'package:dasom_community_app/View/Widget/Button.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/View/Widget/Dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late AuthProvider auth;
  late int _username;
  late String _password;

  void tryLogin() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      auth.tryLogin(_username, _password).then((loginStatus) {
        if (auth.loggedInStatus == AuthStatus.LoggedIn) {
          Provider.of<BoarderProvider>(context, listen: false).getBoardList();
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (auth.loggedInStatus == AuthStatus.NotLoggedIn) {
          shortDialog("로그인 실패", auth.message, context);
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
      onSaved: (value) => _username = int.parse(value!),
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

    var loading = const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Text("New User?"),
        TextButton(
          child: const Text("Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black38)),
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
        ),
      ],
    );
    return SafeArea(
      child: Scaffold(
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
                  "Login",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                usernameField,
                const SizedBox(height: 15.0),
                passwordField,
                const SizedBox(height: 15.0),
                auth.loggedInStatus == AuthStatus.Loading
                    ? loading
                    : longButtons("Login", tryLogin),
                const SizedBox(height: 5.0),
                forgotLabel
              ],
            ),
          ),
        ),
      ),
    );
  }
}
