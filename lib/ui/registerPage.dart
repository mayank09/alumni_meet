import 'package:alumnimeet/firebase/fire_auth.dart' as FireAuth;
import 'package:alumnimeet/ui/homePage.dart';
import 'package:alumnimeet/util/constants.dart';
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
                      name: NAME,
                      hint: NAME_HINT,
                      label: NAME_LABEL,
                      inputType: TextInputType.name,
                      focusNode: _nameFocusNode,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: NAME_ERR),
                      ]),
                  FormTextField(
                      name: EMAIL_ID,
                      hint: EMAIL_HINT,
                      label: EMAIL_LABEL,
                      inputType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: EMAIL_ERR),
                        FormBuilderValidators.email(context,
                            errorText: EMAIL_VALID_ERR)
                      ]),
                  FormTextField(
                      name: PASS_FIELD,
                      label: PASS_LABEL,
                      inputType: TextInputType.text,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      validators: [
                        FormBuilderValidators.required(context,
                            errorText: PASS_ERR),
                      ]),
                  PhoneNumberField(
                    name: PHONE,
                    focusNode: _phoneFocusNode,
                    textInputAction: TextInputAction.done,
                  ),
                  _isProcessing
                      ? CircularProgressIndicator()
                      : SubmitButton(
                          title: REGISTER,
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
                                          .fields[NAME]!.value,
                                      email: _formKey
                                          .currentState!.fields[EMAIL_ID]!.value,
                                      password: _formKey.currentState!
                                          .fields[PASS_FIELD]!.value,
                                      phoneNumber: _formKey.currentState!
                                          .fields[PHONE]!.value);
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
                      question: ALREADY_HAVE_ACC,
                      feature: LOGIN,
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
