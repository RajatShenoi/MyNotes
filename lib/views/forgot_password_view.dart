import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final forgotPasswordPageScaffoldTitle =
        remoteConfig.getString('forgot_password_page_scaffold_title');
    final forgotPasswordPageMessage =
        remoteConfig.getString('forgot_password_page_message');
    final forgotPasswordPageEmailHint =
        remoteConfig.getString('forgot_password_page_email_hint');
    final forgotPasswordPageSendButtonText =
        remoteConfig.getString('forgot_password_page_send_button_text');
    final forgotPasswordLoginButtonText =
        remoteConfig.getString('forgot_password_page_login_button_text');
    final forgotPasswordGenericErrorMessage =
        remoteConfig.getString('forgot_password_page_generic_error_message');
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context, forgotPasswordGenericErrorMessage);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(forgotPasswordPageScaffoldTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(forgotPasswordPageMessage),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: forgotPasswordPageEmailHint,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: Text(forgotPasswordPageSendButtonText),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text(forgotPasswordLoginButtonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
