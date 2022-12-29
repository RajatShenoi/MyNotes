import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final registerPageScaffoldTitle =
        remoteConfig.getString('register_page_scaffold_title');
    final registerPageMessage = remoteConfig.getString('register_page_message');
    final registerPageEmailHint =
        remoteConfig.getString('register_page_email_hint');
    final registerPagePasswordHint =
        remoteConfig.getString('register_page_password_hint');
    final registerPageRegisterButtonText =
        remoteConfig.getString('register_page_register_button_text');
    final registerPageLoginButtonText =
        remoteConfig.getString('register_page_login_button_text');
    final registerPageWeakPasswordErrorMessage =
        remoteConfig.getString('register_page_weak_password_error_message');
    final registerPageEmailAlreadyInUseErrorMessage = remoteConfig
        .getString('register_page_email_already_in_use_error_message');
    final registerPageGenericErrorMessage =
        remoteConfig.getString('register_page_generic_error_message');
    final registerPageInvalidEmailErrorMessage =
        remoteConfig.getString('register_page_invalid_email_error_message');

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context, registerPageWeakPasswordErrorMessage);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, registerPageEmailAlreadyInUseErrorMessage);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, registerPageGenericErrorMessage);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, registerPageInvalidEmailErrorMessage);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(registerPageScaffoldTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(registerPageMessage),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: registerPageEmailHint,
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: registerPagePasswordHint,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
                        },
                        child: Text(registerPageRegisterButtonText),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: Text(registerPageLoginButtonText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
