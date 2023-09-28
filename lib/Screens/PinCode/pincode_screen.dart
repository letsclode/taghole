import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PinCodeScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final int? forceResendingToken;
  const PinCodeScreen({
    super.key,
    required this.verificationId,
    this.forceResendingToken,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends ConsumerState<PinCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP Code'),
      ),
      body: Column(
        children: [
          const Text(
              'OTP code has been sent to +6281221447884 enter the code below to continue.'),
          OtpTextField(
            numberOfFields: 5,
            borderColor: const Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {}, // end onSubmit
          ),
        ],
      ),
    );
  }
}
