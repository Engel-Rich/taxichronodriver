import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/varibles/variables.dart';

// import 'package:taxischrono/varibles/variables.dart';

class Chauffeur extends ApplicationUser {
  final String numeroPermi;
  final DateTime expirePermiDate;
  String idVehicule;

  Chauffeur({
    required super.userAdresse,
    required super.userEmail,
    required super.userName,
    required super.userTelephone,
    required super.userCni,
    super.motDePasse,
    super.userDescription,
    super.userid,
    super.userProfile,
    required super.expireCniDate,
    required this.idVehicule,
    required this.numeroPermi,
    required this.expirePermiDate,
  });

  static DocumentReference<Map<String, dynamic>> chauffeurCollection(
          String userId) =>
      firestore.collection("Chauffeur").doc(userId);
  // les fonxtions de mapage du chauffeur

  Map<String, dynamic> toMap() => {
        'userid': userid,
        "numeroPermi": numeroPermi,
        'expirePermiDate': Timestamp.fromDate(expirePermiDate),
        'idVehicule': idVehicule
      };

  factory Chauffeur.fromJson(
          {required Map<String, dynamic> userMap,
          required Map<String, dynamic> chauffeurMap}) =>
      Chauffeur(
        userAdresse: userMap['userAdresse'],
        userEmail: userMap['userEmail'],
        userName: userMap['userName'],
        userTelephone: userMap['userTelephone'],
        userCni: userMap["userCni"],
        userDescription: userMap['userDescription'],
        userProfile: userMap['userProfile'],
        userid: userMap['userid'],
        expireCniDate: (userMap['expireCniDate'] as Timestamp).toDate(),
        idVehicule: chauffeurMap['idVehicule'],
        numeroPermi: chauffeurMap['numeroPermi'],
        expirePermiDate:
            (chauffeurMap['expirePermiDate'] as Timestamp).toDate(),
      );
  // la fonction d'acceptation de la commande

  accepterLaCommande(Reservation reservation) {
    TransactionApp transaction = TransactionApp(
      idTansaction: DateTime.now().millisecondsSinceEpoch.toString(),
      idclient: reservation.idClient,
      dateAcceptation: DateTime.now(),
      idChauffer: userid!,
      idReservation: reservation.idReservation,
      etatTransaction: 0,
    );
    reservation.updateAcceptedState(1);
    transaction.valideTransaction();
  }

// Enrégistrement du chauffeur

  @override
  saveUser() async {
    super.saveUser();
    await chauffeurCollection(userid!).set(toMap());
  }
// crération des informations du chauffeurs.

  static Stream<Chauffeur> chauffeurInfos(idChauffeur) {
    late Map<String, dynamic> userMap;
    late Map<String, dynamic> chauffeurMap;
    return firestore
        .collection('Utilisateur')
        .doc(idChauffeur)
        .snapshots()
        .map((user) {
      userMap = user.data()!;
      debugPrint(
          "Les informations provenant de la table Utilisateur sont : $userMap");
      chauffeurCollection(idChauffeur).snapshots().map((event) {
        chauffeurMap = event.data()!;
        debugPrint(
            'Les informations provenant de la table Chauffeur sont : $chauffeurMap');
      });
      return Chauffeur.fromJson(userMap: userMap, chauffeurMap: chauffeurMap);
    });
  }
}
