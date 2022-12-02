import 'package:chatpp/helper/service/auth_service.dart';
import 'package:chatpp/helper/service/database_service.dart';
import 'package:chatpp/pages/register_page.dart';
import 'package:chatpp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/service/helper_functions.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Groupie',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Login now to see what they are talking',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Image.asset('images/login.png'),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                              print(email);
                            });
                          },
                          validator: (value) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ? null : 'Please enter valid email';
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                            print(password);
                          });
                        },
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password must be at least 6 caracters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text('Sign In'),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Don\t have an account?',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Register here',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, RegisterPage());
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithEmailAndPassword(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserEmailSF(email);

          nextScreenReplace(context, const HomePage());
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
