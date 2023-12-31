import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_delivery/main/utils/Colors.dart';
import 'package:mighty_delivery/main/utils/Common.dart';
import 'package:mighty_delivery/main/utils/Constants.dart';
import 'package:mighty_delivery/main/utils/Widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../network/RestApis.dart';
import '../Services/AuthSertvices.dart';

class RegisterScreen extends StatefulWidget {
  final String? userType;
  static String tag = '/RegisterScreen';

  RegisterScreen({this.userType});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();

  String carOrMotor = "Car";
  String countryCode = defaultPhoneCode;
  TextEditingController idNumber = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController instituionController = TextEditingController();
  TextEditingController taxOfficeController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  bool isAcceptedTc = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    print("userrrrrrrr");
    log(widget.userType);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> registerApiCallDriver() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isAcceptedTc) {
      appStore.setLoading(true);
      var request = {
          "name": nameController.text,
          "username": userNameController.text,
          "idNumber": idNumber.text.trim(),
          "carOrMotor": carOrMotor,
          "user_type": widget.userType,
          "contact_number": '$countryCode ${phoneController.text.trim()}',
          "email": emailController.text.trim(),
          "password": passController.text.trim(),
          "player_id": getStringAsync(PLAYER_ID).validate(),
        };
        await signUpApi(request).then((res) async {
          authService
          .signUpWithEmailPasswordDriver(context,
              lName: res.data!.name,
              userName: res.data!.username,
              idNumber: idNumber.text.trim(),
              carOrMotor: carOrMotor,
              name: res.data!.name,
              email: res.data!.email,
              password: passController.text.trim(),
              mobileNumber: res.data!.contactNumber,
              userType: res.data!.userType,
              plateNumber: plateNumberController.text.trim(),
              userData: res
          )
              .then((res) async {

      appStore.setLoading(true);

    /*  authService
          .signUpWithEmailPasswordDriver(context,
              lName: nameController.text,
              userName: userNameController.text,
              idNumber: idNumber.text.trim(),
              carOrMotor: carOrMotor,
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passController.text.trim(),
              mobileNumber: '$countryCode ${phoneController.text.trim()}',
              userType: widget.userType,
              plateNumber: plateNumberController.text.trim(),
          userData: res)
          .then((res) async {
        print("Errorrrrrrrrrrrrrrrrr");
        appStore.setLoading(true);*/
        }).catchError((e) {
            appStore.setLoading(false);
            print("Error1");
            log(e.toString());
            toast(e.toString());
          });
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
        print("Error2");
        log(e.toString());
          return;
      });
      } else {
        toast(language.acceptTermService);
        print("Error3");
      }
    }
  }

  Future<void> registerApiCall() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      appStore.setLoading(true);

      appStore.setLoading(true);
      selectedIndex == 0
          ? authService
              .signUpWithEmailPassword(context,
                  lName: nameController.text,
                  userName: userNameController.text,
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  password: passController.text.trim(),
                  mobileNumber: '$countryCode ${phoneController.text.trim()}',
                  userType: widget.userType)
              .then((res) async {
              appStore.setLoading(false);
              //
            }).catchError((e) {
              appStore.setLoading(false);
              toast(e.toString());
            })
          : authService
              .signUpWithEmailPasswordCorporate(context,
                  lName: nameController.text,
                  //------------------------------------ Changed by noah

                  institution: instituionController.text,
                  taxNumber: taxNumberController.text,
                  taxOffice: taxOfficeController.text,

                  //------------------------------------ Changed by noah

                  email: emailController.text.trim(),
                  password: passController.text.trim(),
                  mobileNumber: '$countryCode ${phoneController.text.trim()}',
                  userType: "corporate")
              .then((res) async {
              appStore.setLoading(false);
              //
            }).catchError((e) {
              appStore.setLoading(false);
              toast(e.toString());
            });
    }
  }
  // Future<void> registerApiCall() async {
  //   if (formKey.currentState != null && formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     appStore.setLoading(true);
  //
  //     if (selectedIndex == 0) {
  //       authService
  //           .signUpWithEmailPassword(
  //         context,
  //         lName: nameController.text,
  //         userName: userNameController.text,
  //         name: nameController.text.trim(),
  //         email: emailController.text.trim(),
  //         password: passController.text.trim(),
  //         mobileNumber: '$countryCode ${phoneController.text.trim()}',
  //         userType: widget.userType,
  //       )
  //           .then((res) async {
  //         print("eror3");
  //         appStore.setLoading(false);
  //         // Handle successful sign up
  //       }).catchError((e) {
  //         print("eror4");
  //         appStore.setLoading(false);
  //         toast(e.toString());
  //       });
  //     } else {
  //
  //       authService
  //           .signUpWithEmailPasswordCorporate(
  //         context,
  //         lName: nameController.text,
  //         //------------------------------------ Changed by noah
  //
  //         institution: instituionController.text,
  //         taxNumber: taxNumberController.text,
  //         taxOffice: taxOfficeController.text,
  //
  //         //------------------------------------ Changed by noah
  //
  //         email: emailController.text.trim(),
  //         password: passController.text.trim(),
  //         mobileNumber: '$countryCode ${phoneController.text.trim()}',
  //         userType: "corporate",
  //       )
  //           .then((res) async {
  //         appStore.setLoading(false);
  //         // Handle successful sign up
  //       }).catchError((e) {
  //         print("eror2");
  //         appStore.setLoading(false);
  //         toast(e.toString());
  //       });
  //     }
  //   }
  // }


  int selectedIndex = 0;

  List<String> _buttons = ["User", "Corporate"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          appStore.isDarkMode ? scaffoldSecondaryDark : colorPrimary,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 90,
                        width: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/app_logo_primary.png',
                            height: 70, width: 70)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 16),
                    child:
                        Icon(Icons.arrow_back, color: Colors.white).onTap(() {
                      finish(context);
                    }),
                  ),
                ],
              ).withHeight(
                context.height() * 0.25,
              ),
              widget.userType != DELIVERY_MAN
                  ? Container(
                      width: context.width(),
                      padding: EdgeInsets.only(left: 24, right: 24),
                      decoration: BoxDecoration(
                          color: appStore.isDarkMode
                              ? scaffoldColorDark
                              : Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 70,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  itemBuilder: (ctx, i) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = i;
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: selectedIndex == i
                                                  ? Colors.purple
                                                  : Colors.black,
                                            ),
                                            child: Center(
                                              child: Text(
                                                _buttons[i],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: selectedIndex == i
                                                      ? Colors.white
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              30.height,
                              Text(
                                  language.signUp +
                                      (selectedIndex == 0
                                          ? " (User)"
                                          : " (Corporate)"),
                                  style: boldTextStyle(size: headingSize)),
                              8.height,
                              Text(language.signUpWithYourCredential,
                                  style: secondaryTextStyle(size: 16)),
                              30.height,
                              selectedIndex == 0
                                  ? Text(language.name,
                                      style: primaryTextStyle())
                                  : Text(
                                      "Institution Name",
                                      style: primaryTextStyle(),
                                    ),
                              8.height,
                              AppTextField(
                                controller: selectedIndex == 0
                                    ? nameController
                                    : instituionController,
                                textFieldType: TextFieldType.NAME,
                                focus: nameFocus,
                                nextFocus: userNameFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                              ),
                              16.height,
                              selectedIndex == 0
                                  ? Text(language.username,
                                      style: primaryTextStyle())
                                  : Text(
                                      "Tax Office",
                                      style: primaryTextStyle(),
                                    ),
                              8.height,
                              AppTextField(
                                controller: selectedIndex == 0
                                    ? userNameController
                                    : taxOfficeController,
                                textFieldType: selectedIndex == 0
                                    ? TextFieldType.NAME
                                    : TextFieldType.NUMBER,
                                focus: userNameFocus,
                                nextFocus: emailFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorInvalidUsername: language.usernameInvalid,
                              ),
                              16.height,
                              selectedIndex == 0
                                  ? Text(language.email,
                                      style: primaryTextStyle())
                                  : Text(
                                      "Tax Number",
                                      style: primaryTextStyle(),
                                    ),
                              8.height,
                              selectedIndex == 1
                                  ? AppTextField(
                                      controller: taxNumberController,
                                      textFieldType: TextFieldType.NAME,
                                      nextFocus: phoneFocus,
                                      decoration: commonInputDecoration(),
                                      errorThisFieldRequired:
                                          language.fieldRequiredMsg,
                                      errorInvalidEmail: language.emailInvalid,
                                    )
                                  : Container(),
                              8.height,
                              selectedIndex == 0
                                  ? Container()
                                  : Text(
                                      "Email",
                                      style: primaryTextStyle(),
                                    ),
                              8.height,
                              AppTextField(
                                controller: emailController,
                                textFieldType: TextFieldType.EMAIL,
                                focus: emailFocus,
                                nextFocus: phoneFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorInvalidEmail: language.emailInvalid,
                              ),
                              16.height,
                              Text(language.contactNumber,
                                  style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: phoneController,
                                textFieldType: TextFieldType.PHONE,
                                focus: phoneFocus,
                                nextFocus: passFocus,
                                decoration: commonInputDecoration(
                                  prefixIcon: IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CountryCodePicker(
                                          initialSelection: countryCode,
                                          showCountryOnly: false,
                                          dialogSize: Size(context.width() - 60,
                                              context.height() * 0.6),
                                          showFlag: true,
                                          showFlagDialog: true,
                                          showOnlyCountryWhenClosed: false,
                                          alignLeft: false,
                                          textStyle: primaryTextStyle(),
                                          dialogBackgroundColor:
                                              Theme.of(context).cardColor,
                                          barrierColor: Colors.black12,
                                          dialogTextStyle: primaryTextStyle(),
                                          searchDecoration: InputDecoration(
                                            iconColor:
                                                Theme.of(context).dividerColor,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorPrimary)),
                                          ),
                                          searchStyle: primaryTextStyle(),
                                          onInit: (c) {
                                            countryCode = c!.dialCode!;
                                          },
                                          onChanged: (c) {
                                            countryCode = c.dialCode!;
                                          },
                                        ),
                                        VerticalDivider(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      ],
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return language.fieldRequiredMsg;
                                  if (value.trim().length < minContactLength ||
                                      value.trim().length > maxContactLength)
                                    return language.contactLength;
                                  return null;
                                },
                                inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                              ),
                              16.height,
                              Text(language.password,
                                  style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: passController,
                                textFieldType: TextFieldType.PASSWORD,
                                focus: passFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorMinimumPasswordLength:
                                    language.passwordInvalid,
                              ),
                              8.height,
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: colorPrimary,
                          title: RichTextWidget(
                            list: [
                              TextSpan(text: '${language.iAgreeToThe}', style: secondaryTextStyle()),
                              TextSpan(
                                text: language.termOfService,
                                style: boldTextStyle(color: colorPrimary, size: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    commonLaunchUrl(mTermAndCondition);
                                  },
                              ),
                              TextSpan(text: ' & ', style: secondaryTextStyle()),
                              TextSpan(
                                text: language.privacyPolicy,
                                style: boldTextStyle(color: colorPrimary, size: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    commonLaunchUrl(mPrivacyPolicy);
                                  },
                              ),
                            ],
                          ),
                          value: isAcceptedTc,
                          onChanged: (val) async {
                            isAcceptedTc = val!;
                            setState(() {});
                          },
                        ),
                              30.height,
                              commonButton(
                                  language.signUp, () {
                                registerApiCall();
                              }, width: context.width()),
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(language.alreadyHaveAnAccount,
                                      style: primaryTextStyle()),
                                  4.width,
                                  Text(language.signIn,
                                          style: boldTextStyle(
                                              color: colorPrimary))
                                      .onTap(() {
                                    finish(context);
                                  }),
                                ],
                              ),
                              16.height,
                            ],
                          ),
                        ),
                      ),
                    ).expand()
                  : Container(
                      width: context.width(),
                      padding: EdgeInsets.only(left: 24, right: 24),
                      decoration: BoxDecoration(
                          color: appStore.isDarkMode
                              ? scaffoldColorDark
                              : Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              30.height,
                              Text(language.signUp,
                                  style: boldTextStyle(size: headingSize)),
                              8.height,
                              Text(language.signUpWithYourCredential,
                                  style: secondaryTextStyle(size: 16)),
                              30.height,
                              Text("ID NO", style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[1-9]')),
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                validator: (v) {
                                  if (v!.length > 11 || v!.length < 11) {
                                    return "Kimlik numarası 11 karakter olmalıdır!";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: idNumber,
                                textFieldType: TextFieldType.NUMBER,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                              ),
                              16.height,
                              Text(language.name, style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: nameController,
                                textFieldType: TextFieldType.NAME,
                                focus: nameFocus,
                                nextFocus: userNameFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                              ),
                              16.height,
                              Text(language.username,
                                  style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: userNameController,
                                textFieldType: TextFieldType.USERNAME,
                                focus: userNameFocus,
                                nextFocus: emailFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorInvalidUsername: language.usernameInvalid,
                              ),
                              16.height,
                              Text("Choose your truck",
                                  style: primaryTextStyle()),
                              8.height,
                              Container(
                                height: 80,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      value: carOrMotor.isEmpty
                                          ? "Car"
                                          : carOrMotor,
                                      items: <String>["Car", "Motor"]
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          carOrMotor = v!;
                                        });
                                        print(carOrMotor);
                                      },
                                    ),
                                    Container(
                                      height: 100,
                                      width: 140,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text("Plate Number",
                                                style: primaryTextStyle()),
                                            //style: TextStyle(fontSize: 10)
                                          ),
                                          AppTextField(
                                            controller: plateNumberController,
                                            textFieldType: TextFieldType.NAME,
                                            decoration: commonInputDecoration(),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              16.height,
                              Text(language.email, style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: emailController,
                                textFieldType: TextFieldType.EMAIL,
                                focus: emailFocus,
                                nextFocus: phoneFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorInvalidEmail: language.emailInvalid,
                              ),
                              16.height,
                              Text(language.contactNumber,
                                  style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: phoneController,
                                textFieldType: TextFieldType.PHONE,
                                focus: phoneFocus,
                                nextFocus: passFocus,
                                decoration: commonInputDecoration(
                                  prefixIcon: IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CountryCodePicker(
                                          initialSelection: countryCode,
                                          showCountryOnly: false,
                                          dialogSize: Size(context.width() - 60,
                                              context.height() * 0.6),
                                          showFlag: true,
                                          showFlagDialog: true,
                                          showOnlyCountryWhenClosed: false,
                                          alignLeft: false,
                                          textStyle: primaryTextStyle(),
                                          dialogBackgroundColor:
                                              Theme.of(context).cardColor,
                                          barrierColor: Colors.black12,
                                          dialogTextStyle: primaryTextStyle(),
                                          searchDecoration: InputDecoration(
                                            iconColor:
                                                Theme.of(context).dividerColor,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: colorPrimary)),
                                          ),
                                          searchStyle: primaryTextStyle(),
                                          onInit: (c) {
                                            countryCode = c!.dialCode!;
                                          },
                                          onChanged: (c) {
                                            countryCode = c.dialCode!;
                                          },
                                        ),
                                        VerticalDivider(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                      ],
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return language.fieldRequiredMsg;
                                  if (value.trim().length < minContactLength ||
                                      value.trim().length > maxContactLength)
                                    return language.contactLength;
                                  return null;
                                },
                              ),
                              16.height,
                              Text(language.password,
                                  style: primaryTextStyle()),
                              8.height,
                              AppTextField(
                                controller: passController,
                                textFieldType: TextFieldType.PASSWORD,
                                focus: passFocus,
                                decoration: commonInputDecoration(),
                                errorThisFieldRequired:
                                    language.fieldRequiredMsg,
                                errorMinimumPasswordLength:
                                    language.passwordInvalid,
                              ),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: colorPrimary,
                                title: RichTextWidget(
                                  list: [
                                    TextSpan(text: '${language.iAgreeToThe}', style: secondaryTextStyle()),
                                    TextSpan(
                                      text: language.termOfService,
                                      style: boldTextStyle(color: colorPrimary, size: 14),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          commonLaunchUrl(mTermAndCondition);
                                        },
                                    ),
                                    TextSpan(text: ' & ', style: secondaryTextStyle()),
                                    TextSpan(
                                      text: language.privacyPolicy,
                                      style: boldTextStyle(color: colorPrimary, size: 14),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          commonLaunchUrl(mPrivacyPolicy);
                                        },
                                    ),
                                  ],
                                ),
                                value: isAcceptedTc,
                                onChanged: (val) async {
                                  isAcceptedTc = val!;
                                  setState(() {});
                                },
                              ),
                              30.height,
                              commonButton(language.signUp, () {
                                registerApiCallDriver();
                              }, width: context.width()),
                              16.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(language.alreadyHaveAnAccount,
                                      style: primaryTextStyle()),
                                  4.width,
                                  Text(language.signIn,
                                          style: boldTextStyle(
                                              color: colorPrimary))
                                      .onTap(() {
                                    finish(context);
                                  }),
                                ],
                              ),
                              16.height,
                            ],
                          ),
                        ),
                      ),
                    ).expand(),
            ],
          ),
          Observer(
              builder: (context) => loaderWidget().visible(appStore.isLoading)),
        ],
      ).withHeight(context.height()),
    );
  }
}
