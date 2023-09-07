import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../constant/color.dart';

class CustomDialog extends StatelessWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  const CustomDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.primaryButtonText,
      required this.primaryButtonRoute,
      required this.secondaryButtonText,
      required this.secondaryButtonRoute});

  static const double padding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: const [
                  BoxShadow(
                    color: backShadowColor,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 24.0),
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    //skip
                    showSecondaryButton(context),
                    const SizedBox(width: 10.0),
                    //register
                    ElevatedButton(
                      child: AutoSizeText(
                        primaryButtonText,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(primaryButtonRoute);
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    return OutlinedButton(
      child: AutoSizeText(
        secondaryButtonText,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 18,
          color: secondaryColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
      },
    );
  }
}
