import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxischronodriver/modeles/autres/reservation.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';
import 'package:taxischronodriver/modeles/discutions/conversation.dart';
import 'package:taxischronodriver/modeles/discutions/message.dart';
import 'package:taxischronodriver/services/firebaseauthservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class ApplicationUser {
  String? userid;
  final String userEmail;
  final String userName;
  final String? userTelephone;
  final String? userProfile;
  final String? motDePasse;
  final String? userAdresse;
  final String? userDescription;
  final String? userCni;
  final DateTime? expireCniDate;

  ApplicationUser({
    this.userAdresse,
    required this.userEmail,
    required this.userName,
    this.userTelephone,
    this.userCni,
    this.motDePasse,
    this.userDescription,
    this.userid,
    this.userProfile,
    this.expireCniDate,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> mapUser) =>
      ApplicationUser(
          userAdresse: mapUser['userAdresse'],
          userEmail: mapUser['userEmail'],
          userName: mapUser['userName'],
          userTelephone: mapUser['userTelephone'],
          userCni: mapUser['userCni'],
          userDescription: mapUser['userDescription'],
          userid: mapUser['userid'],
          userProfile: mapUser['userProfile'],
          expireCniDate: mapUser['expireCniDate']);

  Map<String, dynamic> toJson() => {
        'userAdresse': userAdresse,
        'userEmail': userEmail,
        'userName': userName,
        'userTelephone': userTelephone,
        'userCni': userCni,
        'userDescription': userDescription,
        'userid': userid,
        'userProfile': userProfile,
        'ExpireCniDate': expireCniDate,
      };

  Future saveUser() async {
    final doc = await firestore.collection('Utilisateur').doc(userid!).get();
    if (doc.exists) {
      updateUser();
    } else {
      await firestore.collection('Utilisateur').doc(userid!).set(toJson());
    }
  }

  Future updateUser() async {
    await firestore.collection('Utilisateur').doc(userid!).update(toJson());
  }

  static Stream<ApplicationUser> appUserInfos(idClient) => firestore
      .collection('Utilisateur')
      .doc(idClient)
      .snapshots()
      .map((user) => ApplicationUser.fromJson(user.data()!));

  static Stream<ApplicationUser?>? currentUser() {
    try {
      return firestore
          .collection('Utilisateur')
          .doc(authentication.currentUser!.uid)
          .snapshots()
          .map((user) => ApplicationUser.fromJson(user.data()!));
    } catch (e) {
      return null;
    }
  }

  static Future<ApplicationUser?> currentUserFuture() async {
    try {
      return firestore
          .collection('Utilisateur')
          .doc(authentication.currentUser!.uid)
          .get()
          .then((user) => ApplicationUser.fromJson(user.data()!));
    } catch (e) {
      return null;
    }
  }

  login() {
    if (authentication.currentUser == null) {
      Authservices().login(userEmail, motDePasse);
    }
  }

  envoyerUnMessage(Message message) async {
    Conversation conversation = Conversation(lastMessage: message);
    await conversation.sendMessage();
  }

  singalerUrgence({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'urgence',
      isRead: false,
    );
    Message reponse = Message(
      senderUserId: idServiceClient,
      destinationUserId: userid!,
      libelle:
          "Merci de bien vouloir nous signaler votre urgence S'il-vous-plait",
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'reponse',
      isRead: false,
    );
    envoyerUnMessage(msg);
    envoyerUnMessage(reponse);
  }

  contacterLeServiceClient({required String message}) {
    final Message msg = Message(
      senderUserId: userid!,
      destinationUserId: idServiceClient,
      libelle: message,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'contacter',
      isRead: false,
    );
    envoyerUnMessage(msg);
  }

  static signalerDepart({required TransactionApp transaction}) {
    transaction.modifierEtat(2);
  }

  static signalerArriver({required TransactionApp transaction}) {
    transaction.modifierEtat(1);
  }

  static annulerUneRservation(Reservation reservation) async {
    await reservation.annuletReservation();
  }

  static noterLechauffeur(
      {required TransactionApp transaction, required int note}) {
    transaction.noterChauffeur(note);
  }

  register() async {
    String error = "";
    if (authentication.currentUser == null) {
      Authservices().register(userEmail, motDePasse);
    }
    if (authentication.currentUser != null) {
      final user = authentication.currentUser!;
      await authentication.verifyPhoneNumber(
        timeout: const Duration(seconds: 90),
        phoneNumber: userTelephone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await user.updatePhoneNumber(credential).then((value) {
            saveUser();
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          error = exception.code;
          debugPrint(error);
        },
        codeSent: (String verificationId, int? resentokent) async {
          // notons que la variable smsCode sera modifier par lors de la connexion à
          //l'interface utilisateur

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          await authentication.currentUser!
              .updatePhoneNumber(credential)
              .then((value) {
            saveUser();
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    }
  }
}
