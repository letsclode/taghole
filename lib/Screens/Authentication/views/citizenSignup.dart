import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/constant/size.dart';

import '../../../controllers/auth_controller.dart';
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
  bool isSigningUp = false;

  String? _number;
  String? _email;
  String? _password;
  String? _error;

  bool _obscure = true;

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

  Future login() async {
    setState(() {
      isLoading = true;
    });
    final authProvider = ref.watch(authControllerProvider.notifier);

    try {
      await authProvider
          .signInWithEmailAndPassword(email: _email!, password: _password!)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future registerUser({required String mobile}) async {
    FirebaseAuth auth0 = FirebaseAuth.instance;
    final authProvider = ref.watch(authControllerProvider.notifier);
    final userProvider = ref.read(userControllerProvider.notifier);

    setState(() {
      isLoading = true;
    });

    try {
      await auth0.verifyPhoneNumber(
          // phoneNumber: "+44 $mobile",
          //7444 555666  code: 123456
          phoneNumber: "+63 $mobile",
          forceResendingToken: 2,
          verificationCompleted: (AuthCredential auth) {
            print('verificationCompleted');
          },
          verificationFailed: (FirebaseAuthException authException) {
            print(authException.message);
            setState(() {
              isLoading = false;
              _error = authException.message;
            });
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
                                try {
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: smsCode);

                                  // Sign the user in (or link) with the credential
                                  auth0
                                      .signInWithCredential(credential)
                                      .then((result) async {
                                    await authProvider
                                        .createUserWithEmailAndPassword(
                                            email: _email!,
                                            password: _password!)
                                        .then((value) async {
                                      String role = "citizen";
                                      await userProvider.storeNewUser(
                                          email: _email,
                                          uid: value!,
                                          number: result.user!.phoneNumber,
                                          role: role);
                                      print('user created');
                                      Navigator.pop(context);
                                      Navigator.of(key.currentContext!)
                                          .pushReplacementNamed("/home");
                                    });
                                  });
                                } catch (e) {
                                  setState(() {
                                    print('credential');
                                    isLoading = false;
                                    _error = e.toString();
                                  });
                                }
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
    } catch (e) {
      setState(() {
        isLoading = false;
        _error = e.toString();
      });
    }
  }

  void submit() async {
    if (validate()) {
      try {
        if (isSigningUp) {
          await registerUser(mobile: _number!);
        } else {
          await login();
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          _error = e.toString();
        });
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: <Widget>[
                      showAlert(),
                      SizedBox(
                        height: height * .025,
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

  InputDecoration buildSignUpInputDecoration(String hint,
      {bool isPassword = false}) {
    return InputDecoration(
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
              icon: const Icon(Icons.visibility_off))
          : null,
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

    final height = MediaQuery.of(context).size.height / 3.8;

    textFields.add(Image.asset(
      'assets/images/logintop.jpg',
      height: height,
    ));

    textFields.add(const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: AutoSizeText(
            "Welcome to Taghole",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));

    textFields.add(
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: EmailValidator.validate,
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) {
          _email = value;
        },
      ),
    );
    textFields.add(const SizedBox(
      height: KXFontSize.small,
    ));

    textFields.add(
      TextFormField(
        keyboardType: TextInputType.visiblePassword,
        validator: PasswordValidator.validate,
        decoration: buildSignUpInputDecoration("Password", isPassword: true),
        obscureText: _obscure,
        onSaved: (value) {
          _password = value;
        },
      ),
    );
    textFields.add(const SizedBox(
      height: KXFontSize.small,
    ));
    if (isSigningUp) {
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
    }

    return textFields;
  }

  List<Widget> buildButtons() {
    String switchButtonText;
    String submitButtonText;
    if (isSigningUp) {
      switchButtonText = "Already have account? Login";
      submitButtonText = "Register";
    } else {
      switchButtonText = "No account yet? Register";
      submitButtonText = "Login";
    }

    return [
      TextButton(
          onPressed: () {
            setState(() {
              isSigningUp = !isSigningUp;
            });
          },
          child: Text(switchButtonText)),
      const SizedBox(
        height: KXFontSize.medium,
      ),
      SizedBox(
        width: double.infinity,
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
      Consumer(
        builder: (context, ref, child) {
          final authProvider = ref.watch(authControllerProvider.notifier);
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              child: const Text('Skip'),
              onPressed: () async {
                await authProvider.userVisit();
              },
            ),
          );
        },
      ),
    ];
  }
}
