import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxischronodriver/controllers/controllerbuilding.dart';
import 'package:taxischronodriver/firebase_options.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/screens/login_page.dart';
import 'package:taxischronodriver/services/transitionchauffeur.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApplicationUser?>(
        stream: ApplicationUser.currentUser(),
        builder: (context, snapshot) {
          return GetMaterialApp(
            initialBinding: ControllerBinding(),
            title: 'TaxisChrono',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: snapshot.data == null
                ? const LoginPage()
                : TransitionChauffeurVehicule(applicationUser: snapshot.data!),
          );
        });
  }
}
