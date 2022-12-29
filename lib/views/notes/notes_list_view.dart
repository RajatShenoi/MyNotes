import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final NoteCallback onCheckValueChanged;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    required this.onCheckValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final notesListPageSnackbarActionText =
        remoteConfig.getString("notes_list_page_snackbar_action_text");

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(
              (DefaultFirebaseOptions.currentPlatform ==
                      DefaultFirebaseOptions.web)
                  ? 15
                  : 0,
              0,
              0,
              0),
          leading: Checkbox(
            value: note.isChecked,
            onChanged: (bool? value) async {
              onCheckValueChanged(note);
              final snackBar = SnackBar(
                content: Text(
                    "\"${(note.heading.trim() == '' ? 'Note' : note.heading.trim())}\" moved to ${note.isChecked ? "Home Page" : "Checked Notes"}."),
                action: SnackBarAction(
                  label: notesListPageSnackbarActionText,
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          onTap: () {
            onTap(note);
          },
          title: Text(
            (note.heading.trim() != "") ? note.heading : "Note",
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
