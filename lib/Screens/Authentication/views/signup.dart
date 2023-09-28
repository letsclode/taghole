import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/user_controller.dart';

enum AuthFormType { signin, signup, reset }

class Signup extends ConsumerStatefulWidget {
  AuthFormType? authFormType;
  Signup({super.key, required this.authFormType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _name;
  String? _error;

  void switchFormState(String state) {
    formKey.currentState!.reset();
    if (state == "signup") {
      setState(() {
        widget.authFormType = AuthFormType.signup;
      });
    } else {
      setState(() {
        widget.authFormType = AuthFormType.signin;
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

  void submit() async {
    final authProvider = ref.watch(authControllerProvider.notifier);
    final userProvider = ref.watch(userControllerProvider.notifier);
    if (validate()) {
      try {
        if (widget.authFormType == AuthFormType.signin) {
          String uid = await authProvider.signInWithEmailAndPassword(
              email: _email!, password: _password!);
          print("Signed in with ID $uid");
        } else if (widget.authFormType == AuthFormType.reset) {
          await authProvider.sendPasswordResetEmail(email: _email!);
          setState(() {
            widget.authFormType = AuthFormType.signin;
          });
        } else {
          String uid = await authProvider.createUserWithEmailAndPassword(
              email: _email!, password: _password!, name: _name!);
          print("Signed up with new ID $uid");
          String role = "Municpal";
          await userProvider.storeNewUser(uid: uid, role: role);
        }
        if (!context.mounted) return;
        Navigator.of(context).pushReplacementNamed("/home");
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: secondaryColor,
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
              buildHeaderText(),
              SizedBox(
                height: height * .05,
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
    if (widget.authFormType == AuthFormType.signup) {
      headerText = "Create New Account";
    } else if (widget.authFormType == AuthFormType.reset) {
      headerText = "Reset Password";
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

    if (widget.authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: const TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) {
            _email = value;
          },
        ),
      );

      textFields.add(const SizedBox(height: 20));
      return textFields;
    }

    if (widget.authFormType == AuthFormType.signup) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: const TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Name"),
          onSaved: (value) {
            _name = value;
          },
        ),
      );

      textFields.add(const SizedBox(height: 20));
    }
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: const TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) {
          _email = value;
        },
      ),
    );

    textFields.add(const SizedBox(height: 20));

    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: const TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) {
          _password = value;
        },
      ),
    );

    textFields.add(SizedBox(height: MediaQuery.of(context).size.height * 0.3));

    return textFields;
  }

  List<Widget> buildButtons() {
    String switchButtonText;
    String newFormState;
    String submitButtonText;

    if (widget.authFormType == AuthFormType.signin) {
      switchButtonText = "Create Account";
      newFormState = "signup";
      submitButtonText = "Sign In";
    } else {
      switchButtonText = "Have an Account? Sign In";
      newFormState = "signin";
      submitButtonText = "Sign Up";
    }

    return [
      MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: submit,
        child: Text(
          submitButtonText,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
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
}
