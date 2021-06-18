import 'package:alumnimeet/firebase/firestore.dart' as FireStore;
import 'package:alumnimeet/util/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WorkInfoForm extends StatefulWidget {
  const WorkInfoForm({
    Key? key,
    this.org,
    this.city,
    this.title,
    this.start,
    this.end,
    required this.userId,
    required this.isPresent, required this.isProfessional,
  }) : super(key: key);

  final String? org, city, title, start, end;
  final String userId;
  final bool? isPresent;
  final bool isProfessional;

  @override
  _WorkInfoFormState createState() => _WorkInfoFormState();
}

class _WorkInfoFormState extends State<WorkInfoForm> {
  late String? _org, _city, _title, _start, _end;
  late String _userId;
  late bool? _isPresent;
  late bool _isProfessional;
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _orgFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _startFocusNode = FocusNode();
  final FocusNode _endFocusNode = FocusNode();
  final FocusNode _isPresentFocusNode = FocusNode();

  bool _isProcessing = false;

  @override
  void initState() {
    _userId = widget.userId;
    _org = widget.org;
    _city = widget.city;
    _title = widget.title;
    _start = widget.start;
    _end = widget.end;
    _isPresent = widget.isPresent != null ? widget.isPresent : true;
    _isProfessional = widget.isProfessional;
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormTextField(
                        name: "org",
                        hint: "",
                        label: _isProfessional?"Organization Name": "Institution Name",
                        inputType: TextInputType.name,
                        focusNode: _orgFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: "Please enter your Organization name")
                        ],
                        initialValue: _org),
                    FormTextField(
                        name: "city",
                        hint: "",
                        label: "City Name",
                        inputType: TextInputType.name,
                        focusNode: _cityFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: "Please enter your city name")
                        ],
                        initialValue: _city),
                    FormTextField(
                        name: _isProfessional?"job_title":"course",
                        hint: "",
                        label: _isProfessional?"Designation":"Course with Specialization",
                        inputType: TextInputType.name,
                        focusNode: _titleFocusNode,
                        validators: [
                          FormBuilderValidators.required(context,
                              errorText: _isProfessional?"Please enter your Designation": "Please enter your Course name")
                        ],
                        initialValue: _title),
                    //Spacer(),
                    DatePickerForm(
                      name: "from",
                      label: "From",
                      format: "MMMM y",
                      mode: DatePickerMode.year,
                      focusNode: _startFocusNode,
                      textInputAction: TextInputAction.next,
                      initialValue: _start,
                      validators: FormBuilderValidators.required(context,
                          errorText: "Please fill a Starting date"),
                    ),
                    FormCheckBox(
                      initialValue: _isPresent,
                      focusNode: _isPresentFocusNode,
                      onChanged: (bool? val) {
                        _formKey.currentState!.save();
                        val = _formKey.currentState!.fields['isPresent']!.value;
                        setState(() {
                          _isPresent = val!;
                        });
                      },
                    ),
                    _isPresent!
                        ? Container()
                        : DatePickerForm(
                            name: "to",
                            label: "To",
                            format: "MMMM y",
                            mode: DatePickerMode.year,
                            focusNode: _endFocusNode,
                            firstDate: _formKey.currentState?.fields['from']?.value,
                            textInputAction: TextInputAction.done,
                            initialValue: _isPresent! ? null : _end,
                            validators: _isPresent!
                                ? null
                                : FormBuilderValidators.required(context,
                                    errorText: "Please fill a Completion date")
/*                      selectableDayPredicate: (DateTime day) {
                              String s = _formKey.currentState!.fields['from']!.value;
                              DateFormat f = DateFormat("MMMM y");
                              DateTime dt = f.parse(s);
                              if (day.isAfter(DateTime(2017, 4, 1)))
                                return true;
                              else
                                return false;
                            }*/
                            ),
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
                  FireStore.updateWorkAndEducationInfo(
                      _userId, _formKey.currentState!.value, _isProfessional);
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
