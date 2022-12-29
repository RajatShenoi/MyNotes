import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as devtools show log;

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final navDrawerWidgetTitleWeb =
        remoteConfig.getString("nav_drawer_widget_title_web");
    final navDrawerWidgetTile1TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_1_title_web");
    final navDrawerWidgetTile2TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_2_title_web");
    final navDrawerWidgetTile3TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_3_title_web");
    final navDrawerWidgetTile4TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_4_title_web");
    final navDrawerWidgetTile5TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_5_title_web");
    final navDrawerWidgetTile6TitleWeb =
        remoteConfig.getString("nav_drawer_widget_tile_6_title_web");
    final navDrawerWidgetTile3OntapUriWeb =
        remoteConfig.getString("nav_drawer_widget_tile_3_ontap_uri_web");
    final navDrawerWidgetTile4OntapUriWeb =
        remoteConfig.getString("nav_drawer_widget_tile_4_ontap_uri_web");
    final navDrawerWidgetTile5OntapUriWeb =
        remoteConfig.getString("nav_drawer_widget_tile_5_ontap_uri_web");
    final navDrawerWidgetTitleAndroid =
        remoteConfig.getString("nav_drawer_widget_title_android");
    final navDrawerWidgetTile1TitleAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_1_title_android");
    final navDrawerWidgetTile2TitleAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_2_title_android");
    final navDrawerWidgetTile3TitleAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_3_title_android");
    final navDrawerWidgetTile4TitleAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_4_title_android");
    final navDrawerWidgetTile5TitleAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_5_title_android");
    final navDrawerWidgetTile3OntapUriAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_3_ontap_uri_android");
    final navDrawerWidgetTile4OntapUriAndroid =
        remoteConfig.getString("nav_drawer_widget_tile_4_ontap_uri_android");
    if (kIsWeb) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/cover.png"),
                  )),
              child: Text(
                navDrawerWidgetTitleWeb,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(navDrawerWidgetTile1TitleWeb),
              onTap: (() {
                Navigator.pushNamed(context, '/');
              }),
            ),
            ListTile(
              leading: const Icon(Icons.library_add_check),
              title: Text(navDrawerWidgetTile2TitleWeb),
              onTap: () {
                Navigator.pushNamed(context, checkedNotesRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.get_app),
              title: Text(navDrawerWidgetTile3TitleWeb),
              onTap: () async {
                final url = Uri.parse(navDrawerWidgetTile3OntapUriWeb);
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                } else {
                  devtools.log("Couldn't open URL");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: Text(navDrawerWidgetTile4TitleWeb),
              onTap: () async {
                final url = Uri.parse(navDrawerWidgetTile4OntapUriWeb);
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(navDrawerWidgetTile5TitleWeb),
              onTap: () async {
                final url = Uri.parse(navDrawerWidgetTile5OntapUriWeb);
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(navDrawerWidgetTile6TitleWeb),
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
      // If the platform is not Web
      return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/cover.png"),
                  )),
              child: Text(
                navDrawerWidgetTitleAndroid,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(navDrawerWidgetTile1TitleAndroid),
              onTap: (() {
                Navigator.pushNamed(context, '/');
              }),
            ),
            ListTile(
              leading: const Icon(Icons.library_add_check),
              title: Text(navDrawerWidgetTile2TitleAndroid),
              onTap: () {
                Navigator.pushNamed(context, checkedNotesRoute);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: Text(navDrawerWidgetTile3TitleAndroid),
              onTap: () async {
                final url = Uri.parse(navDrawerWidgetTile3OntapUriAndroid);
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(navDrawerWidgetTile4TitleAndroid),
              onTap: () async {
                final url = Uri.parse(navDrawerWidgetTile4OntapUriAndroid);
                launchUrl(url);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(navDrawerWidgetTile5TitleAndroid),
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
