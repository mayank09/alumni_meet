import 'package:alumnimeet/firebase/fire_auth.dart'as FireAuth;
import 'package:alumnimeet/ui/homePage.dart';
import 'package:alumnimeet/ui/registerPage.dart';
import 'package:alumnimeet/util/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isProcessing = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: FireAuth.initializeFirebase(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      AppLabel(),
                      FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FormTextField(
                                  name: "email",
                                  hint: "joe,doe@gmmail.com",
                                  label: "Email",
                                  inputType: TextInputType.emailAddress,
                                  focusNode: _emailFocusNode,
                                  validators: [
                                    FormBuilderValidators.required(context,
                                        errorText:
                                            "Email address can't be left blank"),
                                    FormBuilderValidators.email(context,
                                        errorText: "Not a valid Email"),
                                  ]),
                              FormTextField(
                                  name: "password",
                                  label: "Password",
                                  inputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  focusNode: _passwordFocusNode,
                                  obscureText: true,
                                  validators: [
                                    FormBuilderValidators.required(context,
                                        errorText:
                                            "Password can't be left blank"),
                                  ]),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        SubmitButton(
                                            title: "Login",
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });
                                                _formKey.currentState!.save();
                                                print(_formKey
                                                    .currentState!.value);
                                                User? user =
                                                    await FireAuth.signInUsingEmailPassword(
                                                        email: _formKey
                                                            .currentState!
                                                            .fields['email']!
                                                            .value,
                                                        password: _formKey
                                                            .currentState!
                                                            .fields['password']!
                                                            .value,
                                                        context: context);
                                                setState(() {
                                                  _isProcessing = false;
                                                });

                                                if (user != null) {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage(
                                                                user: user)),
                                                  );
                                                }
                                              } else {
                                                print("validation failed");
                                              }
                                            }),
                                        MyDivider(),
                                        GoogleButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isProcessing = true;
                                            });
                                            User? user = await FireAuth.signInWithGoogle(
                                                context: context);

                                            setState(() {
                                              _isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(
                                                    user: user,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        CreateAccountLabel(
                                            question:
                                                'Don\'t have an account ?',
                                            feature: 'Register',
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterPage()),
                                              );
                                            })
                                      ],
                                    )
                            ],
                          )),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
