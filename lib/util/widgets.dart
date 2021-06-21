import 'package:alumnimeet/location/location.dart';
import 'package:alumnimeet/ui/contactInfoForm.dart';
import 'package:alumnimeet/ui/mapPage.dart';
import 'package:alumnimeet/ui/personalInfoForm.dart';
import 'package:alumnimeet/ui/workInfoForm.dart';
import 'package:alumnimeet/util/constants.dart';
import 'package:alumnimeet/util/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:intl/intl.dart';

//common Widgets
class SubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SubmitButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w800),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onSurface: Colors.black,
            minimumSize: Size(double.infinity, 50)),
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String name, label;
  final String? hint;
  final TextInputType inputType;
  final List<FormFieldValidator<String>> validators;
  final bool? obscureText;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? initialValue;

  const FormTextField({
    Key? key,
    required this.name,
    this.hint,
    required this.label,
    required this.inputType,
    required this.validators,
    this.obscureText,
    this.focusNode,
    this.textInputAction,
    this.autoFocus,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: FormBuilderTextField(
        name: name,
        obscureText: obscureText == true ? true : false,
        decoration: InputDecoration(
            hintText: hint != null ? hint : "",
            labelText: label,
            border: OutlineInputBorder()),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose(validators),
        keyboardType: inputType,
        textInputAction: textInputAction != null
            ? TextInputAction.done
            : TextInputAction.next,
        autofocus: autoFocus != null ? true : false,
        focusNode: focusNode != null ? focusNode : null,
        initialValue: initialValue != null ? initialValue : null,
/*          onEditingComplete: () {
            if (focusNode != null) focusNode!.nextFocus();

          }*/
      ),
    );
  }
}

class PhotoWidget extends StatelessWidget {
  final String? url;
  final String? name;

  const PhotoWidget({Key? key, this.url, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: (url != null && url!.isNotEmpty)
            ? Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: NetworkImage(url!), fit: BoxFit.cover)))
            : Container(
                height: 60,
                width: 60,
                child: Center(
                  child: Text(name.toString().substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 40, color: Colors.black)),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(100),
                )));
  }
}

class DatePickerFeild extends StatelessWidget {
  const DatePickerFeild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormBuilderDateRangePicker(
        name: 'date_range',
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().month + 1),
        initialEntryMode: DatePickerEntryMode.inputOnly,
        format: DateFormat("MMMM-yyyy"),
        decoration: InputDecoration(
          labelText: 'Date Range',
          helperText: 'Helper text',
          hintText: 'Hint text',
        ),
      ),
    );
  }
}

class DatePickerForm extends StatelessWidget {
  final String name, label, format;
  final String? initialValue;
  final DatePickerMode mode;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final FormFieldValidator<DateTime>? validators;
  final SelectableDayPredicate? selectableDayPredicate;
  final DateTime? firstDate;

  const DatePickerForm(
      {Key? key,
      required this.name,
      required this.label,
      required this.format,
      required this.mode,
      this.initialValue,
      this.focusNode,
      this.textInputAction,
      this.validators,
      this.selectableDayPredicate,
      this.firstDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: FormBuilderDateTimePicker(
        name: name,
        inputType: InputType.date,
        initialDatePickerMode: mode,
        format: DateFormat(format),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        firstDate: firstDate == null ? DateTime(1900) : firstDate,
        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 1),
        focusNode: focusNode,
        initialValue: (initialValue != null)
            ? DateFormat(format).parse(initialValue!)
            : null,
        textInputAction: textInputAction,
        validator: validators,
        selectableDayPredicate: selectableDayPredicate,
      ),
    );
  }
}

class FormCheckBox extends StatelessWidget {
  final bool? initialValue;
  final ValueChanged<bool>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const FormCheckBox(
      {Key? key,
      this.initialValue,
      this.onChanged,
      this.focusNode,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 0, bottom: 0),
      child: FormBuilderCheckbox(
          name: IS_PRESENT,
          title: Text(PRESENT_LABEL),
          initialValue: initialValue,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: onChanged,
          focusNode: focusNode),
    );
  }
}

//login-register page Widgets

class AppLabel extends StatelessWidget {
  const AppLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60),
      child: Text("Alumni Meet",
          style: TextStyle(
            fontSize: 50,
            color: Colors.blueAccent,
          )),
    );
  }
}

class CreateAccountLabel extends StatelessWidget {
  final GestureTapCallback onTap;
  final String question, feature;

  const CreateAccountLabel(
      {Key? key,
      required this.onTap,
      required this.question,
      required this.feature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              question,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              feature,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(thickness: 1),
            ),
          ),
          Text('OR'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blue, width: 3, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              minimumSize: Size(double.infinity, 50)),
          onPressed: onPressed,
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.blue),
          label: Text("Sign-In with Google")),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final String name;
  final FocusNode focusNode;
  final TextInputAction? textInputAction;
  final String? initialValue;

  PhoneNumberField(
      {Key? key,
      required this.focusNode,
      this.textInputAction,
      required this.name,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: FormBuilderPhoneField(
          name: name,
          decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: '9876598765',
              border: OutlineInputBorder()),
          priorityListByIsoCode: ['IN'],
          defaultSelectedCountryIsoCode: "IN",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          initialValue: initialValue != null ? initialValue : null,
          textInputAction: textInputAction != null
              ? TextInputAction.done
              : TextInputAction.next,
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(context,
                  errorText: "Mobile Number can't be blank"),
              FormBuilderValidators.numeric(context,
                  errorText: "Please enter a valid Mobile Number")
            ],
          ),
        ));
  }
}

//user-alumniDirectory pageWidget

class InkwellWithIconClickable extends StatelessWidget {
  final IconData iconData;
  String? title;
  bool? isClickable;

  InkwellWithIconClickable({
    Key? key,
    required this.iconData,
    this.title,
    this.isClickable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: (isClickable == true && title != null && title!.isNotEmpty)
            ? () {
                iconData == Icons.email
                    ? customLaunch('mailto: $title subject: Alumni Meet')
                    : customLaunch('tel:$title');
              }
            : null,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(
              width: 10,
            ),
            title != null
                ? Text(title!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: isClickable == true ? Colors.blue : Colors.black,
                        fontSize: 15))
                : Text("")
          ],
        ),
      ),
    );
  }
}

class ProfileHeaderCard extends StatelessWidget {
  String? url, phone, photoURL;
  final String name, email, userId;
  bool? isCurrentUser;

  ProfileHeaderCard(
      {Key? key,
      required this.email,
      this.phone,
      required this.name,
      this.url,
      this.isCurrentUser,
      required this.userId,
      this.photoURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PhotoWidget(url: photoURL, name: name),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              InkwellWithIconClickable(
                                  iconData: Icons.person,
                                  title: name.toUpperCase()),
                              InkwellWithIconClickable(
                                iconData: Icons.email,
                                title: email,
                                isClickable:
                                    isCurrentUser == true ? false : true,
                              ),
                              InkwellWithIconClickable(
                                iconData: Icons.phone,
                                title: phone,
                                isClickable:
                                    isCurrentUser == true ? false : true,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  url != null
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  child: Text(url!,
                                      style: TextStyle(color: Colors.blue),
                                      overflow: TextOverflow.ellipsis),
                                  onTap: () {
                                    customLaunch(url);
                                  }),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            )),
        isCurrentUser == true
            ? Positioned(
                right: 8.0,
                top: 8.0,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactInfoForm(
                                    name: name,
                                    email: email,
                                    phone: phone,
                                    link: url,
                                    userId: userId,
                                  )));
                    },
                    icon: Icon(Icons.edit)))
            : Container()
      ],
    );
  }
}

class ProfessionalDetails extends StatelessWidget {
  final String? title, org, city, designation, start, complete;
  final String userId;
  final bool isCurrentUser, isPresent, isProfessional;

  const ProfessionalDetails(
      {Key? key,
      this.title,
      this.org,
      this.designation,
      this.start,
      this.complete,
      this.city,
      required this.isCurrentUser,
      required this.userId,
      required this.isPresent,
      required this.isProfessional})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4),
                          child: org != null ? Text('$org, $city') : Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4),
                          child: designation != null
                              ? Text(designation!)
                              : Text(""),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4),
                            child: start != null
                                ? isPresent
                                    ? Text('$start -Present')
                                    : Text('$start -$complete')
                                : Text(""))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isCurrentUser == true
            ? Positioned(
                right: 8.0,
                top: 8.0,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkInfoForm(
                                    userId: userId,
                                    org: org,
                                    city: city,
                                    title: designation,
                                    start: start,
                                    end: complete,
                                    isPresent: isPresent,
                                    isProfessional: isProfessional,
                                  )));
                    },
                    icon: Icon(Icons.edit)))
            : Container()
      ],
    );
  }
}

class PersonalDetails extends StatelessWidget {
  final String? birthday, city;
  final String userId;
  final bool isCurrentUser;
  final double? lat, lng;

  const PersonalDetails(
      {Key? key,
      this.birthday,
      this.city,
      required this.isCurrentUser,
      this.lat,
      this.lng,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  InkwellWithIconClickable(
                      iconData: Icons.card_giftcard, title: birthday),
                  Row(
                    children: [
                      InkwellWithIconClickable(
                          iconData: Icons.location_city, title: city),
                      new Spacer(),
                      isCurrentUser == true
                          ? TextButton(
                              onPressed: () {
                                determinePosition(context, userId);
                              },
                              child: Text("Set Location",
                                  style: TextStyle(color: Colors.blue)))
                          : TextButton(
                              onPressed: () {
                                lat != null && lng != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MapPage(
                                                  userId: userId,
                                                  lng: lng!,
                                                  lat: lat!,
                                                )))
                                    : showSnackBar(context,
                                        "No Location found for this user");
                              },
                              child: Text("View on Map",
                                  style: TextStyle(color: Colors.blue)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        isCurrentUser == true
            ? Positioned(
                right: 8.0,
                top: 8.0,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonalInfoForm(
                                    userId: userId,
                                    homeTown: city,
                                    dob: birthday,
                                  )));
                    },
                    icon: Icon(Icons.edit)))
            : Container()
      ],
    );
  }
}
