import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';

import '../../../controllers/user_controller.dart';

enum AuthForm { signin, signup }

class CitizenSignup extends ConsumerStatefulWidget {
  final AuthForm authFormType;
  const CitizenSignup({super.key, required this.authFormType});

  @override
  ConsumerState<CitizenSignup> createState() => _CitizenSignupState();
}

class _CitizenSignupState extends ConsumerState<CitizenSignup> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey key = GlobalKey();

  late AuthForm localAuthFormType;

  String? _number;
  String? _error;

  void switchFormState(String state) {
    print(state);
    if (state == "signup") {
      setState(() {
        localAuthFormType = AuthForm.signup;
      });
    } else {
      setState(() {
        localAuthFormType = AuthForm.signin;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form!.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future registerUser({required String mobile}) async {
    FirebaseAuth auth0 = FirebaseAuth.instance;
    final userProvider = ref.read(userControllerProvider.notifier);

    auth0.verifyPhoneNumber(
        phoneNumber: "+63 $mobile",
        forceResendingToken: 2,
        verificationCompleted: (AuthCredential auth) {
          try {
            auth0
                .signInWithCredential(auth)
                .then((UserCredential result) async {
              print("Verified");
              String role = "Citizen";
              await userProvider.storeNewUser(
                  uid: result.user!.uid, role: role);
              Navigator.of(key.currentContext!).pushReplacementNamed("/home");
            }).catchError((e) {
              print(e);
            });
          } catch (e) {
            print(e);
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          //TODO: navigate and pass verificationId and forceResindingToken
          print('SIGN IN CREDS');
          print(verificationId);
          print('-----');
          print(forceResendingToken);

          showModalBottomSheet<void>(
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            'OTP code has been sent to enter the code below to continue.'),
                      ),
                      Column(
                        children: [
                          OtpTextField(
                            borderWidth: 1,
                            numberOfFields: 6,
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String smsCode) async {
                              print("send");
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: smsCode);

                              // Sign the user in (or link) with the credential
                              await auth0.signInWithCredential(credential);
                              Navigator.pop(context);
                            }, // end onSubmit
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // Create a PhoneAuthCredential with the code
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  void submit() async {
    if (validate()) {
      try {
        if (localAuthFormType == AuthForm.signin) {
          //TODO: SignIn
          // String uid = await auth.createUserWithEmailAndPassword(
          //     _email!, _password!, _name!);
          // Navigator.of(key.currentContext!).pushReplacementNamed("/home");
        } else {
          //TODO: create user
          await registerUser(mobile: _number!);
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
        print(e);
      }
    }
  }

  @override
  void initState() {
    localAuthFormType = widget.authFormType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height * .025,
              ),
              showAlert(),
              SizedBox(
                height: height * .025,
              ),
              Row(
                children: [
                  buildHeaderText(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: secondaryColor,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error!,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox(height: 0);
  }

  AutoSizeText buildHeaderText() {
    String headerText;
    if (localAuthFormType == AuthForm.signup) {
      headerText = "Create New Account";
    } else {
      headerText = "Sign In";
    }

    return AutoSizeText(
      headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.0,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    textFields.add(
      TextFormField(
        validator: NameValidator.validate,
        style: const TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Mobile #"),
        onSaved: (value) {
          _number = value;
        },
      ),
    );
    textFields.add(const SizedBox(height: 20));
    return textFields;
  }

  List<Widget> buildButtons() {
    String switchButtonText;
    String newFormState;
    String submitButtonText;

    if (localAuthFormType == AuthForm.signin) {
      switchButtonText = "Create Account";
      newFormState = "signup";
      submitButtonText = "Sign In";
    } else {
      switchButtonText = "Have an Account? Sign In";
      newFormState = "signin";
      submitButtonText = "Sign Up";
    }

    return [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: MaterialButton(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: secondaryColor,
          onPressed: submit,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              submitButtonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      TextButton(
        child: Text(
          switchButtonText,
        ),
        onPressed: () {
          switchFormState(newFormState);
        },
      ),
    ];
  }
}
