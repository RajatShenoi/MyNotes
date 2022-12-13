import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final bool isChecked;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.isChecked,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        // The below cast is required even though it asks us to remove the cast
        isChecked = snapshot.data()[isCheckedName] as bool;
}
