import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/screens/otppage.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // les variables.

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

  // function de validation du formulaire.

  chauffeurRegister() async {
    if (formKey.currentState!.validate()) {
      Chauffeur chauffeur = Chauffeur(
        userAdresse: controllerAdress.text,
        userEmail: controlleremail.text,
        userName: controllerNom.text,
        active: false,
        userTelephone: numberSubmited!.phoneNumber,
        userCni: controllerCNI.text,
        expireCniDate: expireCni,
        passeword: controllerMotdePasse.text,
        numeroPermi: controllerExpirPermi.text,
        expirePermiDate: expirePermi,
      );
      await Chauffeur.loginNumber(
        chauffeur,
        context: context,
        onCodeSend: (verificationId, forceResendingToken) {
          Navigator.of(context).push(
            PageTransition(
              child:
                  OtpPage(chauffeur: chauffeur, verificationId: verificationId),
              type: PageTransitionType.leftToRight,
            ),
          );
        },
      );
      // await chauffeur.loginChauffeur(controllerMotdePasse.text).then((value) {
      //   if (value == null) {
      //     Navigator.of(context).pushReplacement(
      //       PageTransition(
      //         child: TransitionChauffeurVehicule(
      //           applicationUser: ApplicationUser(
      //               userEmail: authentication.currentUser!.email!,
      //               userid: authentication.currentUser!.uid,
      //               userName: authentication.currentUser!.displayName!),
      //         ),
      //         type: PageTransitionType.leftToRight,
      //       ),
      //     );
      //     setState(() {
      //       formKey.currentState!.reset();
      //     });
      //   } else {
      //     getsnac(
      //       title: "Erreur d'enrégistrement",
      //       msg: value.toString(),
      //     );
      //   }
      // });
    }
  }

  bool loading = false;
  bool isEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  //  le debu du corps
  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: blanc,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(backgroundColor: dredColor),
            ),
          )
        : Scaffold(
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
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  chauffeurRegister();
                                  setState(() {
                                    loading = false;
                                  });
                                  setState(() {});
                                }),
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
          // champ d'entré du nom
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              controller: controllerNom,
              validator: (val) {
                return val == null || val.length < 3 ? "entre votre nom" : null;
              },
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

          // champ d'entré du numéro de téléphone
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
              validator: (val) {
                return val == null || val.length < 13
                    ? "entrez un numéro de téléphone valide"
                    : null;
              },
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

          // champ d'entré l'adresse email
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              controller: controlleremail,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                return val == null || !isEmail(val)
                    ? "entrez votre adresse email"
                    : null;
              },
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

          // numéro permis
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              controller: controllerpermi,
              validator: (val) {
                return val == null || val.length < 4
                    ? "entrez un numéro de permis correct"
                    : null;
              },
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

          // date d'expiration du permi
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              controller: controllerExpirPermi,
              validator: (val) {
                return val == null || expirePermi == null
                    ? "entrezla date d'expiration du permis"
                    : null;
              },
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365 * 5),
                  ),
                ).then((value) {
                  if (value == null) return;
                  setState(() {
                    expirePermi = value;
                    controllerExpirPermi.text =
                        DateFormat("EEE d MM y").format(expirePermi!);
                  });
                  FocusScope.of(context).unfocus();
                });
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

          // numero de CNI
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerCNI,
              validator: (val) {
                return val == null || val.length < 4
                    ? "entrez un numéro de cni correct"
                    : null;
              },
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

          // date d'expiration de la CNI
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              style: police,
              controller: controllerExpireCni,
              validator: (val) {
                return val == null || expireCni == null
                    ? "entrez la date d'expiration de la CNI"
                    : null;
              },
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365 * 5),
                  ),
                ).then((expireCniselected) {
                  if (expireCniselected == null) return;
                  setState(() {
                    expireCni = expireCniselected;
                    controllerExpireCni.text =
                        DateFormat('EEE d MM y').format(expireCni!);
                  });
                  debugPrint(DateFormat('EEE MM y').format(expireCni!));
                  FocusScope.of(context).unfocus();
                });
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

          // adresse au lieu d'abitation
          DelayedAnimation(
            delay: 3500,
            child: TextFormField(
              controller: controllerAdress,
              validator: (val) {
                return val == null || val.length < 3
                    ? "entrez une adresse correct"
                    : null;
              },
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

          // mot de passe
          DelayedAnimation(
            delay: 4500,
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: controllerMotdePasse,
              validator: (val) {
                return val == null || val.length < 6
                    ? "le mot de passe doit avoir au moins 6 caractères "
                    : null;
              },
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

          // confirm mot de passe
          DelayedAnimation(
            delay: 4500,
            child: TextFormField(
              obscureText: _obscureconfirm,
              controller: controllerConfirmMotdePasse,
              keyboardType: TextInputType.visiblePassword,
              validator: (val) {
                return val == null ||
                        val.isEmpty ||
                        val != controllerMotdePasse.text
                    ? "le mot de passe ne correspond pas"
                    : null;
              },
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
