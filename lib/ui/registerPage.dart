import 'package:alumnimeet/firebase/fire_auth.dart' as FireAuth;
import 'package:alumnimeet/ui/homePage.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          AppLabel(),
          FormBuilder(
              key: _formKey,
              //autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormTextField(
                      name: "fullname",
                      hint: "John Doe",
                      label: "Full Name",
                      inputType: TextInputType.name,
                      focusNode: _nameFocusNode,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: "Please enter your full name"),
                      ]),
                  FormTextField(
                      name: "email",
                      hint: "john.doe@gmail.com",
                      label: "Email",
                      inputType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: "Email address can't be left blank"),
                        FormBuilderValidators.email(context,
                            errorText: "Not a valid Email")
                      ]),
                  FormTextField(
                      name: "password",
                      label: "Password",
                      inputType: TextInputType.text,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: "Password can't be left blank"),
                      ]),
                  PhoneNumberField(
                    name: 'phone_number',
                    focusNode: _phoneFocusNode,
                    textInputAction: TextInputAction.done,
                  ),
                  _isProcessing
                      ? CircularProgressIndicator()
                      : SubmitButton(
                          title: "Register",
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });
                              _formKey.currentState!.save();
                              print(_formKey.currentState!.value);
                              User? user =
                                  await FireAuth.registerUsingEmailPassword(
                                      context: context,
                                      name: _formKey.currentState!
                                          .fields['fullname']!.value,
                                      email: _formKey
                                          .currentState!.fields['email']!.value,
                                      password: _formKey.currentState!
                                          .fields['password']!.value,
                                      phoneNumber: _formKey.currentState!
                                          .fields['phone_number']!.value);
                              setState(() {
                                _isProcessing = false;
                              });

                              if (user != null) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(user: user),
                                  ),
                                  ModalRoute.withName('/'),
                                );
                              }
                            } else {
                              print("validation failed");
                            }
                          }),
                  CreateAccountLabel(
                      question: "Already have account ?",
                      feature: "Login",
                      onTap: () {
                        Navigator.pop(context);
                      })
                ],
              ))
        ],
      ),
    ));
  }
}
