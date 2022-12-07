// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fst;
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/services/mapservice.dart';

import '../../varibles/variables.dart';

class Reservation {
  final String idReservation;
  String idClient;
  Adresse pointDepart;
  Adresse pointArrive;
  Adresse? positionClient;
  double prixReservation;
  int etatReservation;
  DateTime dateReserVation;
  String typeReservation;

  Reservation({
    required this.idReservation,
    required this.idClient,
    required this.pointDepart,
    this.positionClient,
    required this.pointArrive,
    required this.prixReservation,
    required this.dateReserVation,
    required this.typeReservation,
    this.etatReservation = 0,
  });

// Collection

  fst.DocumentReference collection() =>
      firestore.collection("Reservation").doc(idReservation);

// Json
  Map<String, dynamic> tomap() => {
        'idReservation': idReservation,
        "pointDepart": pointDepart.toMap(),
        "pointArrive": pointArrive.toMap(),
        "positionClient":
            positionClient != null ? positionClient!.toMap() : null,
        "prixReservation": prixReservation,
        "typeRservation": typeReservation,
        "dateReservation": fst.Timestamp.fromDate(dateReserVation),
        "etatReservation": etatReservation,
        "idClient": idClient
      };

  factory Reservation.fromJson(Map<String, dynamic> reservation) => Reservation(
        idReservation: reservation["idReservation"],
        pointDepart: Adresse.fromMap(reservation["pointDepart"]),
        positionClient: reservation["positionClient"] != null
            ? Adresse.fromMap(reservation["positionClient"])
            : null,
        pointArrive: Adresse.fromMap(reservation["pointArrive"]),
        prixReservation: reservation["prixReservation"],
        dateReserVation:
            (reservation["dateReservation"] as fst.Timestamp).toDate(),
        typeReservation: reservation["typeRservation"],
        idClient: reservation['idClient'],
        etatReservation: reservation['etatReservation'],
      );

  // validation de la réservation
  valideRservation() async {
    collection().set(tomap());
  }

  updateAcceptedState(int accept) async {
    await collection().update({"etatReservation": accept});
  }

  annuletReservation() async {
    updateAcceptedState(-1);
    // final transactions =
    await firestore.collection("TransactionApp").get().then((value) {
      value.docs.map((tansaction) async {
        final transaction = TransactionApp.fromJson(tansaction.data());
        if (transaction.idReservation == idReservation) {
          await transaction.modifierEtat(-1);
        }
      });
    });
  }

// fin de la classe.
}
