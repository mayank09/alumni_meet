import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({
    Key? key,
    required this.userId,
    this.dob,
    this.homeTown,
  }) : super(key: key);

  final String? dob, homeTown;
  final String userId;

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  late String? _dob, _homeTown;
  late String _userId;
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();

  bool _isProcessing = false;

  @override
  void initState() {
    _userId = widget.userId;
    _dob = widget.dob;
    _homeTown = widget.homeTown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal Info")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DatePickerForm(
                      name: "dob",
                      label: "Date of Birth",
                      format: "dd-MM-yyyy",
                      mode: DatePickerMode.day,
                      focusNode: _dobFocusNode,
                      textInputAction: TextInputAction.next,
                      initialValue: _dob,
                      validators: FormBuilderValidators.required(context,
                          errorText: "Please fill Date of Birth"),
                    ),
                    FormTextField(
                        name: "hometown",
                        hint: "",
                        label: "HomeTown",
                        inputType: TextInputType.name,
                        focusNode: _cityFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: "Please enter your hometown")
                        ],
                        initialValue: _homeTown),

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
                  FireStore.updateContactAndPersonalInfo(
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
