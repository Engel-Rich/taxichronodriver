import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class Vehicule {
  String numeroDeChassie;
  String imatriculation;
  String assurance;
  DateTime expirationAssurance;
  String chauffeurId;
  bool statut;
  LatLng? position;

  Vehicule({
    required this.assurance,
    required this.expirationAssurance,
    required this.imatriculation,
    required this.numeroDeChassie,
    this.position,
    required this.chauffeurId,
    required this.statut,
  });

  Map<String, dynamic> toMap() => {
        "assurance": assurance,
        "expirationAssurance": expirationAssurance,
        "imatriculation": imatriculation,
        "numeroDeChassie": numeroDeChassie,
        if (position != null)
          "position": {
            "latitude": position!.latitude,
            "longitude": position!.longitude,
          },
        "statut": statut
      };
  factory Vehicule.froJson(map) => Vehicule(
        chauffeurId: map['chauffeurId'],
        assurance: map['assurance'],
        expirationAssurance: map['expirationAssurance'],
        imatriculation: map['imatriculation'],
        numeroDeChassie: map["numeroDeChassie"],
        position:
            LatLng(map['position']['latitude'], map['position']['longitude']),
        statut: map['statut'],
      );

// demande d'enrégistrement du véhicule
  Future requestSave() async {
    await datatbase
        .ref("Vehicules")
        .child(chauffeurId)
        .get()
        .then((value) async {
      if (value.exists) {
        return "véhicule déja existant";
      } else {
        await datatbase.ref("Vehicules").child(chauffeurId).set(toMap());
        return true;
      }
    });
  }

// fonction de miseAjour de la position du chauffeur et ou du véhicule
  static Future setPosition(LatLng positionActuel, String userId) async {
    await datatbase.ref("Vehicules").child(userId).update({
      "position": {
        "latitude": positionActuel.latitude,
        "longitude": positionActuel.longitude,
      }
    });
  }

  //  actuellement en ligne ou or ligne
  setStatut(bool etatActuel) async {
    await datatbase
        .ref("Vehicules")
        .child(chauffeurId)
        .update({"statut": etatActuel});
  }

  // fin de la classe
}
