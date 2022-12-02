import 'package:chatpp/helper/service/auth_service.dart';
import 'package:chatpp/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text('LOGOUT'),
        onPressed: () {
          authService.signOut();
          nextScreenReplace(context, const LoginPage());
        },
      )),
    );
  }
}
