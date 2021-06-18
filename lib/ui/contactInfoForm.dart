import 'package:alumnimeet/firebase/firestore.dart';
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
      appBar: AppBar(title: Text("Contact Info")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormTextField(
                        name: "name",
                        hint: "John Doe",
                        label: "Full Name",
                        inputType: TextInputType.name,
                        focusNode: _nameFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: "Please enter your full name")
                        ],
                        initialValue: _name),
                    FormTextField(
                        name: "email",
                        hint: "john.doe@gmail.com",
                        label: "Email",
                        inputType: TextInputType.name,
                        focusNode: _emailFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: "Please enter your full name"),
                        ],
                        initialValue: _email),
                    PhoneNumberField(
                      focusNode: _phoneFocusNode,
                      name: "phoneNumber",
                      initialValue: _phone,
                    ),
                    FormTextField(
                        name: "link",
                        hint: "www.linkedin/joe.com",
                        label: "Profile Link",
                        inputType: TextInputType.name,
                        focusNode: _linkFocusNode,
                        validators: [
                          FormBuilderValidators.url(context,
                              errorText: "Please enter a valid url")
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
              title: "Submit",
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
