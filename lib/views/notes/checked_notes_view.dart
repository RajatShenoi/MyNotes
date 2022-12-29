import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/notification_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:mynotes/widgets/nav_drawer.dart';
import 'dart:developer' as devtools show log;

class CheckedNotesView extends StatefulWidget {
  const CheckedNotesView({Key? key}) : super(key: key);

  @override
  _CheckedNotesViewState createState() => _CheckedNotesViewState();
}

class _CheckedNotesViewState extends State<CheckedNotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final checkedNotesPageScaffoldTitle =
        remoteConfig.getString("checked_notes_page_scaffold_title");
    try {
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          devtools.log(
              "A notification with ${message.messageId} was opened when the app was terminated.");
          showNotificationDialog(
            context,
            message.notification!.title!,
            message.notification!.body!,
          );
        },
      );
    } catch (e) {
      devtools
          .log("There was an error in setting up the notifications system.");
    }
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Your Checked Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allCheckedNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                  onCheckValueChanged: (note) async {
                    await _notesService.updateCheck(
                        documentId: note.documentId,
                        newCheckedValue: !note.isChecked);
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
