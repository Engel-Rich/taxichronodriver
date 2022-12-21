import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taxischronodriver/screens/login_page.dart';
import 'package:taxischronodriver/screens/paquage.dart';
import 'package:taxischronodriver/services/firebaseauthservice.dart';
import 'package:taxischronodriver/varibles/variables.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isConnected = authentication.currentUser != null;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(30), left: Radius.circular(8))),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: isConnected
                ? Text(
                    authentication.currentUser!.displayName!,
                    style: police.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text("Veillez vous connecter",
                    style: police.copyWith(fontWeight: FontWeight.bold)),
            accountEmail:
                !isConnected ? null : Text(authentication.currentUser!.email!),

            currentAccountPicture: CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://png.pngtree.com/png-clipart/20190924/original/pngtree-business-people-avatar-icon-user-profile-free-vector-png-image_4815126.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 90,
                ),
              ),
            ),
            // decoration: const BoxDecoration(
            //   color: Colors.blue,
            //   image: DecorationImage(
            //       fit: BoxFit.fill,
            //       image: NetworkImage(
            //           'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')),
            // ),
          ),
          isConnected
              ? ListTile(
                  leading: const Icon(Icons.person_pin),
                  title: Text('Mon compte', style: police),
                  onTap: () {},
                )
              : const SizedBox.shrink(),
          !isConnected
              ? ListTile(
                  leading: const FaIcon(Icons.person_pin),
                  title: Text('Connextion', style: police),
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                      child: const LoginPage(),
                      type: PageTransitionType.fade,
                    ));
                  },
                )
              : const SizedBox.shrink(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('Mes Courses', style: police),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.panorama_fish_eye_rounded),
            title: Text('Statistiques', style: police),
            onTap: () {
              if (isConnected) {
                Navigator.of(context).push(PageTransition(
                    child: const PackageUi(), type: PageTransitionType.fade));
              } else {
                getsnac(
                    title: "Connexion",
                    icons: Icon(Icons.info_outline, color: dredColor),
                    msg:
                        "Veillez vous connecter avant de souscrire à un package");
                connexion();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text('A propos de Taxis chrono', style: police),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('Partager l\'appli', style: police),
            // ignore: avoid_returning_null_for_void
            onTap: () => null,
          ),
          isConnected
              ? ListTile(
                  title: Text('Déconexion', style: police),
                  leading: const Icon(Icons.exit_to_app),
                  // ignore: avoid_returning_null_for_void
                  onTap: () async => isConnected
                      ? Authservices().logOut().then((value) {
                          print("deconnexion");
                          Navigator.of(context).pop();
                          setState(() {});
                        })
                      : getsnac(
                          title: "DÉCONNEXION", msg: "Aucun compte connecté"),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  // fontion de navigation vers la page d'authentification
  connexion() => Navigator.of(context).push(PageTransition(
        child: const LoginPage(),
        type: PageTransitionType.fade,
      ));
}
