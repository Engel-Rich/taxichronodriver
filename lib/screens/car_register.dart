import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxischronodriver/screens/delayed_animation.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class RequestCar extends StatefulWidget {
  const RequestCar({super.key});

  @override
  State<RequestCar> createState() => _RequestCarState();
}

class _RequestCarState extends State<RequestCar> {
  //  le debu du corps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
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
                        "Formulaire d'enregistrement du véhicule",
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
                        "Pensez à bien verifier les informations saisis afin de faciliter la validation de votre vehicule.",
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
                          'ENREGISTRER',
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
              spacerHeight(15),
            ],
          ),
        ),
      ),
    );
  }

  Widget signupForm() {
    return Column(
      children: [
        DelayedAnimation(
          delay: 3500,
          child: TextFormField(
            style: police,
            decoration: InputDecoration(
              icon: const Icon(Icons.car_rental),
              hintStyle: police,
              labelText: 'Numero De Chassi',
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
              icon: const Icon(Icons.local_taxi_outlined),
              hintStyle: police,
              labelText: 'Model De Vehicule',
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
              icon: const Icon(Icons.card_travel),
              hintStyle: police,
              labelText: 'Votre Numero de Plaque Immatriculation',
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
              icon: const Icon(Icons.assured_workload),
              hintStyle: police,
              labelText: 'Votre Numero Assurance',
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
              icon: const Icon(Icons.color_lens),
              hintStyle: police,
              labelText: 'Couleur du Vehicule',
              labelStyle: TextStyle(
                color: grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}