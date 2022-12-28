import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxischronodriver/controllers/requestcontrollers.dart';
import 'package:taxischronodriver/controllers/vehiculecontroller.dart';
import 'package:taxischronodriver/modeles/applicationuser/appliactionuser.dart';
import 'package:taxischronodriver/modeles/applicationuser/chauffeur.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/modeles/autres/vehicule.dart';
import 'package:taxischronodriver/screens/component/infocard.dart';
// import 'package:taxischronodriver/screens/etineraires.dart';

import 'package:taxischronodriver/screens/sidebar.dart';
import 'package:taxischronodriver/services/mapservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';

import '../controllers/useapp_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///////////////////
  ///les variables
  ///////////////.
  Completer controllerMap = Completer<GoogleMapController>();
  ScrollController controllerSlide = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool voirs = false;
  LatLng? location;
  Set<Marker> markersSets = {};

  setMrkers() {
    markersSets.add(
      Marker(
        markerId: MarkerId(authentication.currentUser!.uid),
        position: location!,
        infoWindow: const InfoWindow(
          title: "Votre Positions actuelle",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  // Location? userCurrentLocation;
  fromCurrentPosition() async {
    var permissison = await GooGleMapServices.handleLocationPermission();
    if (permissison) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        setState(() {
          location = LatLng(value.latitude, value.longitude);
          setMrkers();
          print(location!.latitude);
        });
      });
    }

    Geolocator.getPositionStream().listen((event) async {
      location = LatLng(event.latitude, event.longitude);
      await Vehicule.setPosition(location!, authentication.currentUser!.uid);
      setMrkers();
      setState(() {});
    });
  }

  voirMaPosition() async {
    GoogleMapController googleMapController = await controllerMap.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location!,
          zoom: 16,
        ),
      ),
    );
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylinesSets = {};

  var valueconut = 10;

  ///////////////////
  ///les fonctions
  ///////////////.

  @override
  void initState() {
    Get.put<ChauffeurController>(ChauffeurController());
    fromCurrentPosition();
    // Timer.periodic(
    //   Duration(seconds: 30),
    //   (timer) {
    //     setState(() {
    //       markersSets.add(
    //         const Marker(
    //             markerId: MarkerId("yaounde"),
    //             infoWindow: InfoWindow(title: "Yaounde"),
    //             position: younde),
    //       );
    //       getPolilineLines(younde, location!, polylinePoints, polylinesSets);
    //     });
    //     timer.cancel();
    //   },
    // );
    transactionEncour();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const SafeArea(child: SideBar()),
      body: SafeArea(
        child: Stack(
          children: [
            SlidingUpPanel(
                parallaxEnabled: true,
                minHeight: taille(context).height * 0.15,
                maxHeight: taille(context).height * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                body: location == null
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Recherche de position...",
                                    style: police,
                                  ),
                                ),
                              ),
                              spacerHeight(20),
                              const LoadingComponen(),
                              spacerHeight(10),
                              Text(
                                "Vérification des services de localisation ...",
                                textAlign: TextAlign.center,
                                style: police.copyWith(
                                    letterSpacing: 3, fontSize: 16),
                              ),
                              spacerHeight(20),
                              boutonText(
                                  context: context,
                                  action: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                        (route) => false);
                                  },
                                  text: 'Recharger'),
                            ],
                          ),
                        ),
                      )
                    : GoogleMap(
                        myLocationEnabled: true,
                        initialCameraPosition:
                            CameraPosition(target: location!, zoom: 14),
                        onMapCreated: (control) {
                          controllerMap.complete(control);
                        },
                        markers: markersSets,
                        polylines: Set<Polyline>.of(polylinesSets.values),
                      ),
                panelBuilder: (controller) {
                  return SafeArea(
                    child: ListView(
                      controller: controller,
                      children: [
                        Center(
                          child: SizedBox(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 10,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        boutonText(
                            context: context,
                            text: 'Voir ma position',
                            action: () {
                              voirMaPosition();
                              // Navigator.of(context).push(PageTransition(
                              //     child: const SearchDestinaitionPage(),
                              //     type: PageTransitionType.bottomToTop));
                            })
                      ],
                    ),
                  );
                }),
            Positioned(
              top: 10,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: dredColor, shape: BoxShape.circle),
                        child: const FaIcon(
                          Icons.menu,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: GetX<VehiculeController>(
                    init: Get.put<VehiculeController>(VehiculeController()),
                    builder: (_) {
                      if (_.currentCar.chauffeurId.trim().isNotEmpty) {
                        return FlutterSwitch(
                          width: 100.0,
                          height: 45.0,
                          toggleSize: 43,
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey.shade500,
                          activeToggleColor: dredColor,
                          activeText: "Online",
                          inactiveText: "Ofline",
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.black,
                          activeIcon: const Icon(Icons.online_prediction),
                          inactiveIcon: const Icon(Icons.offline_bolt),
                          switchBorder: Border.all(color: dredColor),
                          value: _.currentCar.statut,
                          onToggle: (value) async {
                            print(value);
                            if (value == false) {
                              await _.currentCar.setStatut(value);
                            } else {
                              if (_.currentCar.isActive) {
                                await _.currentCar.setStatut(value);
                              } else {
                                boobtomshet(
                                  keys: scaffoldKey,
                                  hei: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      spacerHeight(20),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "$value Votre Compte n'est plus actif veillez le réactiver pour continuer à recevoir les commandes des clients",
                                          style: police.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      spacerHeight(30),
                                      boutonText(
                                        couleur: Colors.green.shade400,
                                        context: context,
                                        action: () {
                                          activerMoncompte();
                                        },
                                        text: "Activer mon compte",
                                      ),
                                      spacerHeight(15),
                                      boutonText(
                                        context: context,
                                        action: () {
                                          Navigator.of(context).pop();
                                        },
                                        text: "Annuler",
                                      ),
                                      spacerHeight(30),
                                    ],
                                  ),
                                );
                              }
                            }

                            setState(() {});
                          },
                        );
                      } else {
                        return Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text('chargement ...', style: police),
                        ));
                      }
                    }),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: GetX<ResquestController>(
                  init: Get.put<ResquestController>(ResquestController()),
                  builder: (control) {
                    if (control.reservations != null &&
                        control.reservations.isNotEmpty) {
                      // setState(() {
                      //   getPolilineLines(
                      //       control.reservations[0].pointDepart.adresseposition,
                      //       control.reservations[0].pointArrive.adresseposition,
                      //       polylinePoints,
                      //       polylinesSets);
                      // });
                      // Chauffeur.havehicule(authentication.currentUser!.uid)
                      //     .then((val) async {
                      //   if (val != null) await val.setStatut(false);
                      // });
                      Timer.periodic(const Duration(seconds: 9), (timer) {
                        setState(() {
                          polylinesSets = {};
                        });
                      });
                      return RequestCard(
                        reservation: control.reservations[0],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
// fontionc activant le compte

  activerMoncompte() async {
    Navigator.of(context).pop();

    boobtomshet(
      keys: scaffoldKey,
      hei: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Choisissez votre plan de souscription',
                textAlign: TextAlign.center,
                style: police.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4)),
          ),
          spacerHeight(30),
          ListTile(
            onTap: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: dredColor,
                )),
            title: Text(
              "2500 FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 8 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: dredColor,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          ListTile(
            onTap: () {
              print(5000);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.blue.shade400,
                )),
            title: Text(
              "5OOO FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 16 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade400,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          ListTile(
            onTap: () {
              print(10000);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.green.shade400,
                )),
            title: Text(
              "10 000 FCFA",
              style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text("Valide 16 jours", style: police),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade400,
              child: Icon(Icons.local_taxi, color: blanc),
            ),
          ),
          spacerHeight(7.5),
          const Divider(),
          spacerHeight(7.5),
          boutonText(
              context: context,
              action: () {
                Navigator.of(context).pop();
              },
              text: 'Annuler'),
          spacerHeight(30),
        ],
      ),
    );
  }

// pour les transactions en cours

  transactionEncour() async {
    TransactionApp.currentTransaction(authentication.currentUser!.uid)
        .listen((event) {
      for (var elemnt in event) {
        // print(elemnt.tomap());
        if (elemnt.etatTransaction != 2 && elemnt.etatTransaction != -1) {
          Reservation.reservationStream(elemnt.idReservation).listen((event) {
            setState(() {
              markersSets.add(
                Marker(
                  markerId: MarkerId(event.idClient),
                  infoWindow: InfoWindow(
                    title: elemnt.etatTransaction == 0
                        ? event.pointDepart.adresseName
                        : event.pointArrive.adresseName,
                  ),
                  position: elemnt.etatTransaction == 0
                      ? event.pointDepart.adresseposition
                      : event.pointArrive.adresseposition,
                  onTap: () {
                    scaffoldKey.currentState!.showBottomSheet((context) {
                      return Container(
                        height: 500,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InfosCard(reservation: event),
                              spacerHeight(15),
                              boutonText(
                                context: context,
                                action: () {
                                  Navigator.of(context).pop();
                                },
                                text: "Okey",
                              ),
                              spacerHeight(15),
                              boutonText(
                                context: context,
                                action: () async {
                                  await event
                                      .annuletReservation()
                                      .then((value) {
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                            child: const HomePage(),
                                            type:
                                                PageTransitionType.leftToRight),
                                        (route) => false);
                                  });
                                },
                                text: "Annuler la course",
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            });
          });
        }
      }
    });
  }
}

class RequestCard extends StatefulWidget {
  const RequestCard({
    Key? key,
    required this.reservation,
    this.isView,
  }) : super(key: key);

  final Reservation reservation;
  final bool? isView;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  int valueconut = 10;
  conterSet() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (valueconut > 0) {
        setState(() {
          valueconut--;
        });
      } else {
        timer.cancel();
        Reservation.rejectByChauffeur(
            authentication.currentUser!.uid, widget.reservation);
      }
    });
  }

//
  @override
  void initState() {
    if (widget.isView == null) conterSet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prix = widget.reservation.prixReservation;
    final depart = widget.reservation.pointDepart;
    final arrive = widget.reservation.pointArrive;
    final type = widget.reservation.typeReservation;
    return SizedBox(
      height: widget.isView == null ? 450 : 320,
      width: taille(context).width - 20,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_taxi,
                    size: 30,
                    color: dredColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(type,
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const Expanded(child: SizedBox()),
                  Text("$prix XFA",
                      style: police.copyWith(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
              spacerHeight(8),
              FutureBuilder<ApplicationUser>(
                  future: ApplicationUser.infos(widget.reservation.idClient),
                  builder: (context, snapshot) {
                    return (!snapshot.hasError && snapshot.hasData)
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              snapshot.data!.userName,
                              maxLines: 1,
                              style: police.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 0.0),
                            ),
                            horizontalTitleGap: 5,
                            subtitle: Text(
                              snapshot.data!.userTelephone ??
                                  snapshot.data!.userEmail,
                              style: police.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: dredColor,
                                  letterSpacing: 3),
                            ),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "images/user.png",
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                            trailing: FutureBuilder<RouteModel?>(
                                future: GooGleMapServices().getRoute(
                                    start: depart.adresseposition,
                                    end: arrive.adresseposition),
                                builder: (context, snapshot) {
                                  return (!snapshot.hasError &&
                                          snapshot.hasData)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.distance.text,
                                              style: police,
                                            ),
                                            Text(
                                              snapshot
                                                  .data!.tempsNecessaire.text,
                                              style: police,
                                            ),
                                          ],
                                        )
                                      : shimmer(50.0, 60.0);
                                }),
                          )
                        : shimmer(60.0, double.infinity);
                  }),
              spacerHeight(12),
              ListTile(
                leading: Icon(Icons.pin_drop, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'Point de départ',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  depart.adresseName,
                  maxLines: 2,
                  style: police.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              widget.isView == null
                  ? ListTile(
                      leading: Icon(
                        Icons.watch_later_outlined,
                        color: Colors.red.shade200,
                      ),
                      title: Text(
                        "Il vous reste : $valueconut s",
                        style: police.copyWith(
                            color: valueconut > 5 ? Colors.black : dredColor,
                            fontSize: 13,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(),
              ListTile(
                leading:
                    Icon(Icons.location_history, color: dredColor, size: 30),
                horizontalTitleGap: 8,
                title: Text(
                  'point d\'arrivé',
                  style: police.copyWith(fontSize: 12),
                ),
                subtitle: Text(
                  arrive.adresseName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: police.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.0),
                ),
              ),
              spacerHeight(15),
              if (widget.isView == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(Icons.close, size: 30.0),
                        onPressed: () async {
                          await Chauffeur.refuserserunCommande(
                              widget.reservation,
                              authentication.currentUser!.uid);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: dredColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            )),
                        label: Text('Annuler', style: police)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check, size: 30.0),
                      onPressed: () async {
                        Chauffeur.accepterLaCommande(widget.reservation,
                                authentication.currentUser!.uid)
                            .then((value) async {
                          await Chauffeur.havehicule(
                                  authentication.currentUser!.uid)
                              .then((value) async {
                            if (value != null) await value.setStatut(true);
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          )),
                      label: Text('Accepter', style: police),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
