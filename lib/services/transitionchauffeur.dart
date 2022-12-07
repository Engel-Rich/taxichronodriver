import 'package:flutter/material.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/screens/car_register.dart';
import 'package:taxischronodriver/screens/homepage.dart';

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
  haveCar() async {
    final curentChauffeur =
        await Chauffeur.chauffeurInfos(widget.applicationUser.userid);
    if (curentChauffeur.idVehicule != null) setState(() => haveVehicule = true);
  }

  @override
  void initState() {
    haveCar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return haveVehicule ? const HomePage() : const RequestCar();
  }
}
