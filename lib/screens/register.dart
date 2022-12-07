import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController controllerNom = TextEditingController();
  TextEditingController controlleremail = TextEditingController();
  PhoneNumber? numberSubmited;
  TextEditingController controllerpermi = TextEditingController();
  TextEditingController controllerCNI = TextEditingController();
  TextEditingController controllerAdress = TextEditingController();
  TextEditingController controllerMotdePasse = TextEditingController();
  TextEditingController controllerConfirmMotdePasse = TextEditingController();
  TextEditingController controllerExpirPermi = TextEditingController();
  TextEditingController controllerExpireCni = TextEditingController();
  DateTime? expireCni;
  DateTime? expirePermi;
  final formKey = GlobalKey<FormState>();

  bool _obscureconfirm = true;

  bool _obscureText = true;

  //  le debu du corps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DelayedAnimation(
                        delay: 1500,
                        child: Text(
                          "Formulaire d'enregistrement chauffeur",
                          style: GoogleFonts.poppins(
                            color: dredColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      DelayedAnimation(
                        delay: 2500,
                        child: Text(
                          "Enregistrez vous et commencer a recevoir les demandes de course de nos clients.",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                signupForm(),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: DelayedAnimation(
                    delay: 5500,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            shape: const StadiumBorder(),
                            backgroundColor: dredColor,
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 125,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'INSCRIPTION',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 4),
                          ),
                          onPressed: () {}),
                    ),
                  ),
                ),
                spacerHeight(10),
                DelayedAnimation(
                  delay: 5500,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: dredColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'J\'ai déjà un compte? Connexion',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                DelayedAnimation(
                  delay: 6500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.arrow_back_ios, size: 24),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Retour",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                spacerHeight(15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signupForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                hintStyle: police,
                labelText: 'Entrez votre nom complet',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: InternationalPhoneNumberInput(
              onInputChanged: (number) {
                setState(() {
                  numberSubmited = number;
                });
              },
              hintText: "Votre Numéro de téléphone",
              textStyle: police,
              validator: (val) {},
              inputBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: grey!),
              ),
              maxLength: 13,
              initialValue: PhoneNumber(isoCode: "CM"),
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.email),
                hintStyle: police,
                labelText: 'Votre e-mail',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.local_taxi),
                hintStyle: police,
                labelText: 'Votre Numero de Permis',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              onTap: () {
                DatePicker.showDatePicker(context, onConfirm: (date) {
                  setState(() {
                    expirePermi = date;
                  });
                });
                // DatePicker.showDatePicker (
                //   context: context,
                //   initialDate: DateTime.now(),
                //   firstDate: DateTime.now(),
                //   lastDate: DateTime.now().add(
                //     const Duration(days: 365 * 5),
                //   ),
                // );
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.date_range),
                hintStyle: police,
                labelText: 'La date d\'expiration du permi.',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                hintStyle: police,
                labelText: 'Votre Numero de CNI',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365 * 5),
                  ),
                );
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.date_range),
                hintStyle: police,
                labelText: 'La date d\'expiration de la CNI.',
                labelStyle: TextStyle(
                  color: grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.person_pin_circle),
                hintStyle: police,
                labelText: 'Votre Adresse',
                labelStyle: police.copyWith(color: grey),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 4500,
            child: TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                icon: const Icon(Icons.security),
                labelStyle: police.copyWith(color: grey),
                labelText: 'Mot de passe',
                suffix: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DelayedAnimation(
            delay: 4500,
            child: TextFormField(
              obscureText: _obscureconfirm,
              style: police,
              decoration: InputDecoration(
                icon: const Icon(Icons.security),
                hintStyle: police,
                labelStyle: police.copyWith(color: grey),
                labelText: 'Confirmer Mot de passe',
                suffix: IconButton(
                  icon: Icon(
                    _obscureconfirm ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureconfirm = !_obscureconfirm;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// fin de la classe principale
}
