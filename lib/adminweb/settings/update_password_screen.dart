import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePasswordForm extends StatefulWidget {
  const UpdatePasswordForm({super.key});

  @override
  _UpdatePasswordFormState createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? currentUser = firebaseAuth.currentUser;

// you should check here that email is not empty
      final credential = EmailAuthProvider.credential(
          email: currentUser!.email!, password: _oldPasswordController.text);
      try {
        await currentUser.reauthenticateWithCredential(credential);
        currentUser.updatePassword(_newPasswordController.text).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully')),
          );

          _oldPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          // Password has been updated.
        }).catchError((err) {
          // An error has occured.
        });
      } on FirebaseAuthException {
        // handle if reauthenticatation was not successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password not valid')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Add padding for spacing
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(), // Add border for visual appeal
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your old password';
                }
                return null;
              },
            ),
            const SizedBox(height: 12), // Add vertical space between fields
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your new password';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'Update Password',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
