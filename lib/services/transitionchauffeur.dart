import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxischronodriver/controllers/useapp_controller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/car_register.dart';
import 'package:taxischronodriver/screens/homepage.dart';
import 'package:taxischronodriver/services/mapservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../controllers/vehiculecontroller.dart';

class TransitionChauffeurVehicule extends StatefulWidget {
  final ApplicationUser applicationUser;
  const TransitionChauffeurVehicule({super.key, required this.applicationUser});

  @override
  State<TransitionChauffeurVehicule> createState() =>
      _TransitionChauffeurVehiculeState();
}

class _TransitionChauffeurVehiculeState
    extends State<TransitionChauffeurVehicule> {
  bool haveVehicule = false;
  bool isEmailVerified = authentication.currentUser!.emailVerified;
  haveCar() async {
    await Chauffeur.havehicule(authentication.currentUser!.uid).then((value) {
      if (value != null) {
        print(value.toMap());
        setState(() => haveVehicule = true);
      }
      {
        print('don\'t have car');
      }
    });
  }

  Timer? timer;
  @override
  void initState() {
    haveCar();
    Get.put<VehiculeController>(VehiculeController());
    Get.put<ChauffeurController>(ChauffeurController());
    GooGleMapServices.requestLocation();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return haveVehicule ? const HomePage() : const RequestCar();
  }

  sendVerificationEmail() async {
    if (authentication.currentUser != null) {
      try {
        await authentication.currentUser!.sendEmailVerification().then((value) {
          getsnac(
              title: "Vérification d'email",
              msg:
                  "Un mail de vérification a été envoyé à l'adresse ${authentication.currentUser!.email}");
        });
      } catch (e) {
        getsnac(msg: "$e", title: "Erreur d'envoie de mail de vérification");
      }
    }
  }

  checkVerificationEmail() async {
    await authentication.currentUser!.reload();
    setState(() {
      isEmailVerified = authentication.currentUser!.emailVerified;
    });
  }
}
