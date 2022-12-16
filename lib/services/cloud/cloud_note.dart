import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final bool isChecked;
  final String heading;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.heading,
    required this.text,
    required this.isChecked,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        heading = snapshot.data()[headingFieldName] as String,
        text = snapshot.data()[textFieldName] as String,
        isChecked = snapshot.data()[isCheckedName] as bool;
}
