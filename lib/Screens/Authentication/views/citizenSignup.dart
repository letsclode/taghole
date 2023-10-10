import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';

import '../../../controllers/user_controller.dart';

class CitizenSignup extends ConsumerStatefulWidget {
  const CitizenSignup({super.key});

  @override
  ConsumerState<CitizenSignup> createState() => _CitizenSignupState();
}

class _CitizenSignupState extends ConsumerState<CitizenSignup> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey key = GlobalKey();

  bool isLoading = false;

  String? _number;
  String? _error;

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
            print('verificationCompleted');
            // auth0
            //     .signInWithCredential(auth)
            //     .then((UserCredential result) async {
            //   String role = "citizen";
            //   await userProvider.storeNewUser(
            //       uid: result.user!.uid, role: role);
            //   Navigator.of(key.currentContext!).pushReplacementNamed("/home");
            // }).catchError((e) {
            //   print(e);
            // });
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
                              auth0
                                  .signInWithCredential(credential)
                                  .then((result) async {
                                String role = "citizen";
                                await userProvider.storeNewUser(
                                    uid: result.user!.uid, role: role);
                                Navigator.of(key.currentContext!)
                                    .pushReplacementNamed("/home");
                              });
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
        setState(() {
          isLoading = true;
        });
        await registerUser(mobile: _number!);

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
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
                isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
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
    headerText = "Sign In";

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
          color: Colors.black12,
          width: 0.0,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    textFields.add(Image.asset('assets/images/logintop.jpg'));
    textFields.add(const SizedBox(
      height: 10,
    ));

    textFields.add(
      TextFormField(
        maxLength: 11,
        keyboardType: TextInputType.number,
        validator: NameValidator.validate,
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

    switchButtonText = "Have an Account? Sign In";
    newFormState = "signin";
    submitButtonText = "Sign In";

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
    ];
  }
}
