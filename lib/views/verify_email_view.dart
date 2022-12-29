import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final verifyEmailPageScaffoldTitle =
        remoteConfig.getString('verify_email_page_scaffold_title');
    final verify_email_page_message_1 =
        remoteConfig.getString('verify_email_page_message_1');
    final verify_email_page_message_2 =
        remoteConfig.getString('verify_email_page_message_2');
    final verify_email_page_message_3 =
        remoteConfig.getString('verify_email_page_message_3');
    final verify_email_page_resend_button_text =
        remoteConfig.getString('verify_email_page_resend_button_text');
    final verify_email_page_restart_button_text =
        remoteConfig.getString('verify_email_page_restart_button_text');
    return Scaffold(
      appBar: AppBar(
        title: Text(verifyEmailPageScaffoldTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(verify_email_page_message_1),
              Text(verify_email_page_message_2),
              Text(verify_email_page_message_3),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: Text(verify_email_page_resend_button_text),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: Text(verify_email_page_restart_button_text),
              )
            ],
          ),
        ),
      ),
    );
  }
}
