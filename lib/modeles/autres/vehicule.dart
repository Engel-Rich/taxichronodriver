import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxischronodriver/controllers/vehiculecontroller.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class Vehicule {
  String numeroDeChassie;
  String imatriculation;
  String assurance;
  DateTime expirationAssurance;
  String chauffeurId;
  bool
      statut; // permet de verifier que le vehicule est soit en ligne soit hors ligne.
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
        "expirationAssurance": expirationAssurance.millisecondsSinceEpoch,
        "imatriculation": imatriculation,
        "numeroDeChassie": numeroDeChassie,
        if (position != null)
          "position": {
            "latitude": position!.latitude,
            "longitude": position!.longitude,
          },
        "statut": statut,
        'chauffeurId': chauffeurId,
      };
  factory Vehicule.froJson(map) => Vehicule(
        chauffeurId: map['chauffeurId'],
        assurance: map['assurance'],
        expirationAssurance:
            DateTime.fromMicrosecondsSinceEpoch(map['expirationAssurance']),
        imatriculation: map['imatriculation'],
        numeroDeChassie: map["numeroDeChassie"],
        position:
            LatLng(map['position']['latitude'], map['position']['longitude']),
        statut: map['statut'],
      );

// demande d'enrégistrement du véhicule
  Future requestSave() async {
    print(toMap());
    await datatbase
        .ref("Vehicules")
        .child(chauffeurId)
        .get()
        .then((value) async {
      if (value.exists) {
        return "véhicule déja existant ce véhicule existe déjà";
      } else {
        return await datatbase
            .ref("Vehicules")
            .child(chauffeurId)
            .set(toMap())
            .then((value) {
          Get.find<VehiculeController>().currentVehicul.value = this;
          return true;
        });
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

  static Stream<Vehicule> vehiculeStrem(idchau) =>
      datatbase.ref("Vehicules").child(idchau).onValue.map((event) {
        return Vehicule.froJson(event.snapshot.value);
      });
  static Future<Vehicule> vehiculeFuture(idchau) =>
      datatbase.ref("Vehicules").child(idchau).get().then((event) {
        return Vehicule.froJson(event.value);
      });
  // fin de la classe
}
