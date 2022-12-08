import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as devtools show log;

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/cover.png"),
                  )),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.get_app),
              title: const Text("Android App"),
              onTap: () async {
                final url = Uri.parse(
                    "https://play.google.com/store/apps/details?id=com.RajatShenoi.mynotes");
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  devtools.log("Couldn't open URL");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () async {
                final url = Uri.parse(
                    "https://docs.google.com/forms/d/e/1FAIpQLSe4AGFAF7RFtLjnnTrmr9ZYmda1DaI1E3Jo-MsGyGt1xbEe2A/viewform?usp=sf_link");
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Contact Us"),
              onTap: () async {
                final url =
                    Uri.parse("mailto:developer.rajat.shenoi@gmail.com");
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/cover.png"),
                  )),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Feedback"),
              onTap: () async {
                final url = Uri.parse(
                    "https://docs.google.com/forms/d/e/1FAIpQLSe4AGFAF7RFtLjnnTrmr9ZYmda1DaI1E3Jo-MsGyGt1xbEe2A/viewform?usp=sf_link");
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Contact Us"),
              onTap: () async {
                final url =
                    Uri.parse("mailto:developer.rajat.shenoi@gmail.com");
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                }
              },
            ),
          ],
        ),
      );
    }
  }
}
