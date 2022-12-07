import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart' as getx;

// google signin variable;

final googleSignIn = GoogleSignIn();
final dredColor = Colors.amber.shade700;
final grey = Colors.grey[400];
// Color.fromARGB(248, 255, 233, 33);
// firebase variables

final authentication = FirebaseAuth.instance;
final datatbase = FirebaseDatabase.instance;
final firestore = FirebaseFirestore.instance;

final police = GoogleFonts.poppins(fontSize: 14);
// les variables pour l'OTP
var smsCode = "";
// const
const etatReservation = {0: "en attente", 1: "accepté", -1: "Annuleé"};
const etatTransaction = {
  0: 'initier',
  1: "terminer",
  -1: "Annulé",
  2: "en cours"
};

// la snackbar des infos
getsnac(
        {required String title,
        required String msg,
        bool error = true,
        Widget? icons,
        Duration? duration}) =>
    getx.Get.snackbar(
      title,
      msg,
      titleText:
          Text(title, style: police.copyWith(fontWeight: FontWeight.w800)),
      messageText: Text(msg, style: police),
      icon: icons ??
          FaIcon(
            error ? Icons.error : Icons.check,
            color: error ? Colors.red : Colors.greenAccent,
            size: 30,
          ),
      backgroundColor: Colors.grey.shade200,
      duration: duration ?? const Duration(milliseconds: 3750),
      snackPosition: getx.SnackPosition.TOP,
      maxWidth: double.infinity,
      borderWidth: 1.5,
      borderColor: error ? Colors.red : Colors.greenAccent,
      borderRadius: 15,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
// les type de bouton à utiliser dans l'application
Widget boutonText(
        {required BuildContext context,
        required void Function()? action,
        required String text}) =>
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: dredColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: police.copyWith(fontWeight: FontWeight.w600, color: noire),
        ),
      ),
    );
TextFormField champsdeRecherche(
        {required void Function(String value)? changement,
        required String hintext,
        void Function()? onTap,
        TextEditingController? controller,
        IconData? iconData}) =>
    TextFormField(
      onTap: onTap,
      controller: controller,
      style: police,
      onChanged: changement,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        hintText: hintext,
        hintStyle: police,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blanc),
          borderRadius: BorderRadius.circular(15),
        ),
        icon: FaIcon(
          iconData ?? Icons.location_on_outlined,
          size: 30,
        ),
        fillColor: Colors.grey.shade200.withOpacity(0.7),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

// la variable qui servira de hauteur dans l'Application
spacerHeight(double hauteur) => SizedBox(height: hauteur);
Color blanc = Colors.white;
Color vert = Colors.greenAccent;
Color noire = Colors.black;
const mapApiKey = "AIzaSyDRiuLYKs1ymgiW97p3ybAuQLOQcBDqUvg";
const younde = LatLng(3.866667, 11.516667);
const String idServiceClient = "taxisChronoInccCenter";

// les fonctions

Size taille(BuildContext context) => MediaQuery.of(context).size;

// adresse de la console google : https://console.cloud.google.com
