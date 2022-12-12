import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';

import '../varibles/variables.dart';

class OtpPage extends StatefulWidget {
  final Chauffeur chauffeur;
  final String verificationId;
  const OtpPage(
      {super.key, required this.chauffeur, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DelayedAnimation(
                  delay: 1500,
                  child: Text(
                    "Vérification du numéro de téléphone",
                    style: GoogleFonts.poppins(
                      color: dredColor,
                      letterSpacing: 3,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                spacerHeight(30),
                DelayedAnimation(
                  delay: 2000,
                  child: Text(
                    "Un code a été envoyé au numéro",
                    style:
                        police.copyWith(fontWeight: FontWeight.bold, height: 2),
                    textAlign: TextAlign.center,
                  ),
                ),
                spacerHeight(15),
                DelayedAnimation(
                  delay: 2000,
                  child: Text(
                    "${widget.chauffeur.userTelephone}",
                    style: police.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                spacerHeight(30),
                DelayedAnimation(
                  delay: 2500,
                  child: Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme(),
                    submittedPinTheme: submitpinTheme(),
                    onChanged: (val) {
                      setState(() {
                        smsCode = val;
                      });
                    },
                    length: 6,
                    onCompleted: (val) {
                      setState(() {
                        smsCode = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 30),
                DelayedAnimation(
                    delay: 3000,
                    child: boutonText(
                        context: context,
                        action: () {
                          Chauffeur chauffeur = widget.chauffeur;
                          if (smsCode.length == 6) {
                            Chauffeur.validateOPT(
                              chauffeur,
                              context,
                              smsCode: smsCode,
                              verificationId: widget.verificationId,
                            );
                          }
                        },
                        text: 'Valider'.toUpperCase())),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: police,
      decoration: BoxDecoration(
          border: Border.all(color: dredColor),
          borderRadius: BorderRadius.circular(40)));
  PinTheme focusedPinTheme() => defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(12),
      );
  PinTheme submitpinTheme() => defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromARGB(49, 114, 178, 238)),
        borderRadius: BorderRadius.circular(12),
      );
}
