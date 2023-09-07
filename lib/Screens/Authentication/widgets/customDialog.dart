import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final primaryColor = const Color(0xFFffbf00);
  final grayColor = const Color(0xFF939393);

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
                    color: Colors.amberAccent,
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
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: grayColor,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    showSecondaryButton(context),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      child: AutoSizeText(
                        primaryButtonText,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
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
        style: TextStyle(
          fontSize: 18,
          color: primaryColor,
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
