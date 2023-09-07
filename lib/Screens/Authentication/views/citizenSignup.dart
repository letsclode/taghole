import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/providerWidget.dart';

const primaryColor = Colors.amber;

enum AuthForm { signin, signup }

//TODO: fix redirects
class CitizenSignup extends StatefulWidget {
  AuthForm authFormType;
  CitizenSignup({super.key, required this.authFormType});

  @override
  State<CitizenSignup> createState() => _CitizenSignupState();
}

class _CitizenSignupState extends State<CitizenSignup> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey key = GlobalKey();

  String? _number;
  String? _error;

  void switchFormState(String state) {
    formKey.currentState!.reset();
    if (state == "signup") {
      setState(() {
        widget.authFormType = AuthForm.signup;
      });
    } else {
      setState(() {
        widget.authFormType = AuthForm.signin;
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

  Future registerUser(String mobile) async {
    FirebaseAuth auth0 = FirebaseAuth.instance;
    TextEditingController codeController = TextEditingController();
    String smsCode;
    AuthCredential credential;

    auth0.verifyPhoneNumber(
        phoneNumber: "+63 $mobile",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) {
          try {
            auth0.signInWithCredential(auth).then((UserCredential result) {
              print("Verified");
              String role = "Citizen";
              UserManagement().storeNewUser(
                  "clode@gmail.com", result.user!.uid, role, context);
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
        codeSent: (String verificationId, int? forceResendingToken) {
          //TODO: navigate and pass verificationId and forceResindingToken
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
        final auth = Provider.of(context).auth;
        if (widget.authFormType == AuthForm.signin) {
          // String uid =
          //     await auth.signInWithEmailAndPassword(_email!, _password!);

          //TODO: SignIn
        } else {
          // String uid = await auth.createUserWithEmailAndPassword(
          //     _email!, _password!, _name!);
          //TODO: create user

          await registerUser(_number!);
        }
        Navigator.of(key.currentContext!).pushReplacementNamed("/home");
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
      body: Container(
        color: primaryColor,
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
        color: Colors.amberAccent,
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
    if (widget.authFormType == AuthForm.signup) {
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

    // if (widget.authFormType == AuthForm.reset) {
    //   textFields.add(
    //     TextFormField(
    //       validator: EmailValidator.validate,
    //       style: TextStyle(fontSize: 22),
    //       decoration: buildSignUpInputDecoration("Email"),
    //       onSaved: (value) {
    //         _email = value;
    //       },
    //     ),
    //   );

    //   textFields.add(SizedBox(height: 20));
    //   return textFields;
    // }

    if (widget.authFormType == AuthForm.signup) {
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
    }
    // textFields.add(
    //   TextFormField(
    //     validator: EmailValidator.validate,
    //     style: TextStyle(fontSize: 22),
    //     decoration: buildSignUpInputDecoration("Email"),
    //     onSaved: (value) {
    //       _email = value;
    //     },
    //   ),
    // );

    // textFields.add(SizedBox(height: 20));

    // textFields.add(
    //   TextFormField(
    //     validator: PasswordValidator.validate,
    //     style: TextStyle(fontSize: 22),
    //     decoration: buildSignUpInputDecoration("Password"),
    //     obscureText: true,
    //     onSaved: (value) {
    //       _password = value;
    //     },
    //   ),
    // );

    // textFields.add(SizedBox(height: MediaQuery.of(context).size.height * 0.3));

    return textFields;
  }

  List<Widget> buildButtons() {
    String switchButtonText;
    String newFormState;
    String submitButtonText;
    bool showForgotPassword = false;

    if (widget.authFormType == AuthForm.signin) {
      switchButtonText = "Create Account";
      newFormState = "signup";
      submitButtonText = "Sign In";
      showForgotPassword = true;
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
          color: Colors.white,
          onPressed: submit,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              submitButtonText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      // showForgotPassword(_showForgotPassword),
      ElevatedButton(
        child: Text(
          switchButtonText,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(newFormState);
        },
      )
    ];
  }

  // Widget showForgotPassword(bool visible) {
  //   return Visibility(
  //     child: ElevatedButton(
  //       child: Text(
  //         "Forgot Password??",
  //         style: TextStyle(
  //           color: Colors.white,
  //         ),
  //       ),
  //       onPressed: () {
  //         setState(() {
  //           widget.authFormType = AuthForm.reset;
  //         });
  //       },
  //     ),
  //     visible: visible,
  //   );
  // }
}
