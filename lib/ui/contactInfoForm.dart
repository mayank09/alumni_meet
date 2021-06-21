import 'package:alumnimeet/firebase/firestore.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ContactInfoForm extends StatefulWidget {
  const ContactInfoForm(
      {Key? key,
      required this.name,
      required this.email,
      this.phone,
      this.link,
      required this.userId})
      : super(key: key);

  final String name, email, userId;
  final String? phone, link;

  @override
  _ContactInfoFormState createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  late String _name, _email, _userId;
  late String? _phone, _link;
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _linkFocusNode = FocusNode();

  bool _isProcessing = false;

  @override
  void initState() {
    _name = widget.name;
    _email = widget.email;
    _phone = widget.phone;
    _link = widget.link;
    _userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(CONTACT_INFO)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormTextField(
                        name: NAME,
                        hint: NAME_HINT,
                        label: NAME_LABEL,
                        inputType: TextInputType.name,
                        focusNode: _nameFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: NAME_ERR)
                        ],
                        initialValue: _name),
                    FormTextField(
                        name: EMAIL_ID,
                        hint: EMAIL_HINT,
                        label: EMAIL_LABEL,
                        inputType: TextInputType.name,
                        focusNode: _emailFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: EMAIL_ERR),
                          FormBuilderValidators.email(context, errorText: EMAIL_VALID_ERR)
                        ],
                        initialValue: _email),
                    PhoneNumberField(
                      focusNode: _phoneFocusNode,
                      name: PHONE,
                      initialValue: _phone,
                    ),
                    FormTextField(
                        name: LINK,
                        hint: LINK_HINT,
                        label: LINK_LABEL,
                        inputType: TextInputType.name,
                        focusNode: _linkFocusNode,
                        validators: [
                          FormBuilderValidators.url(context,
                              errorText: LINK_VALID_ERR)
                        ],
                        initialValue: _link),
                  ],
                ),
              ),
            ),
          ),
          _isProcessing
              ? CircularProgressIndicator()
              : SubmitButton(
              title: SUBMIT,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });
                  _formKey.currentState!.save();
                  print(_formKey.currentState!.value);
                  updateContactAndPersonalInfo(
                      _userId, _formKey.currentState!.value);
                  setState(() {
                    _isProcessing = false;
                  });
                  Navigator.pop(context);
                } else {
                  print("validation failed");
                }
              })
        ],
      ),
    );
  }
}
