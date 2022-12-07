import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class Vehicule {
  String numeroDeChassie;
  String imatriculation;
  String assurance;
  DateTime expirationAssurance;
  bool etat;
  LatLng position;

  Vehicule({
    required this.assurance,
    required this.etat,
    required this.expirationAssurance,
    required this.imatriculation,
    required this.numeroDeChassie,
    required this.position,
  });

  Map<String, dynamic> toMap() => {
        "assurance": assurance,
        "etat": etat,
        "expirationAssurance": expirationAssurance,
        "imatriculation": imatriculation,
        "numeroDeChassie": numeroDeChassie,
        "position": {
          "latitude": position.latitude,
          "longitude": position.longitude,
        }
      };
  factory Vehicule.froJson(map) => Vehicule(
        assurance: map['assurance'],
        etat: map['etat'],
        expirationAssurance: map['expirationAssurance'],
        imatriculation: map['imatriculation'],
        numeroDeChassie: map["numeroDeChassie"],
        position:
            LatLng(map['position']['latitude'], map['position']['longitude']),
      );

  setPosition(LatLng positionActuel) async {
    await datatbase.ref("Vehicules").child(numeroDeChassie).update({
      "position": {
        "latitude": positionActuel.latitude,
        "longitude": positionActuel.longitude,
      }
    });
  }

  requestSave() {}
  setStatut(bool etatActuel) async {
    await datatbase
        .ref("Vehicules")
        .child(numeroDeChassie)
        .update({"etat": etatActuel});
  }
  // fin de la classe
}
