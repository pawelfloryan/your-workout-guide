// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbro/model/auth_result.dart';
import '../model/login.dart';
import '../services/auth_service.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static late bool loggedInto = false;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Login login = Login();
  AuthResult authResult = AuthResult();
  String errorText = "";

  bool isElevated = false;
  bool isVisible = false;

  bool badEmail = false;
  bool badPassword = false;

  void loginAction() async {
    authResult = (await AuthService().loginAction(login));
    Future.delayed(const Duration(milliseconds: 10))
        .then((value) => setState(() {
              errors();
              authenticated();
            }));
  }

  Future<void> authenticate() async {
    setState(() {
      login.email = _emailController.text;
      login.password = _passwordController.text;
      loginAction();
    });
  }

  Future<void> authenticated() async {
    print(authResult.token);
    print(authResult.result);
    if (authResult.result == true) {
      isVisible = false;
      LoginPage.loggedInto = true;
      setState(() {
        RootPage.logged = true;
      });
      Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
            context.push('/dashboard');
          }));
      //TODO Update both tables with userId keys
      // and specify which sections to show
    } else if (authResult.result == false) {
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            isElevated = !isElevated;
          }));
      isVisible = true;
    }

    final snackBar = SnackBar(
      content: Text('Submitting form...'),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String errors() {
    authResult.errors?.forEach((error) {
      errorText = error;
    });
    return errorText;
  }

  Future<void> inputErrors() async {
    if (badEmail || badPassword) {
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            isElevated = !isElevated;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double deviceWidth(BuildContext context) =>
        MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 0, top: 20, right: 0, bottom: 25),
                  child: Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 30, color: Color(0xFF363f93)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 0, top: 0, right: 0, bottom: 12),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Enter your email"),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                              .hasMatch(value!)) {
                        setState(() {
                          badEmail = true;
                        });
                        return "Enter correct email";
                      } else {
                        setState(() {
                          badEmail = false;
                        });
                        return null;
                      }
                    },
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: "Enter your password",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      setState(() {
                        badPassword = true;
                      });
                      return "Enter correct password";
                    } else {
                      setState(() {
                        badPassword = false;
                      });
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 0, top: 0, right: 40, bottom: 0),
                      child: GestureDetector(
                        onTap: () {
                          context.go('/register');
                        },
                        child: Text(
                          "Haven't made \nan account yet?",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Container(
                      //MediaQuery.of(context).size.width
                      margin: EdgeInsets.only(
                        left: 0,
                        top: 50,
                        right: 0,
                        bottom: 0,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTapDown: (details) {
                            setState(() {
                              isElevated = !isElevated;
                            });
                            Future.delayed(const Duration(milliseconds: 5))
                                .then((value) => setState(() {
                                      inputErrors();
                                    }));
                            if (formKey.currentState!.validate()) {
                              authenticate();
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: isElevated
                                  ? [
                                      BoxShadow(
                                          color: Colors.grey[500]!,
                                          offset: Offset(4, 4),
                                          blurRadius: 15,
                                          spreadRadius: 1),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4, -4),
                                          blurRadius: 15,
                                          spreadRadius: 1),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 75,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isVisible,
                  child: Text(
                    "Error: " + errorText,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}