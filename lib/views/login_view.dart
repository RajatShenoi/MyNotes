import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    final loginPageScaffoldTitle =
        remoteConfig.getString('login_page_scaffold_title');
    final loginPageMessage = remoteConfig.getString('login_page_message');
    final loginPageEmailHint = remoteConfig.getString('login_page_email_hint');
    final loginPagePasswordHint =
        remoteConfig.getString('login_page_password_hint');
    final loginPageLoginButtonText =
        remoteConfig.getString('login_page_login_button_text');
    final loginPageRegisterButtonText =
        remoteConfig.getString('login_page_register_button_text');
    final loginPageForgotPasswordButtonText =
        remoteConfig.getString('login_page_forgot_password_button_text');
    final loginPageUserNotFoundErrorMessage =
        remoteConfig.getString('login_page_user_not_found_error_message');
    final loginPageWrongPasswordErrorMessage =
        remoteConfig.getString('login_page_wrong_password_error_message');
    final loginPageGenericErrorMessage =
        remoteConfig.getString('login_page_generic_error_message');

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              loginPageUserNotFoundErrorMessage,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, loginPageWrongPasswordErrorMessage);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, loginPageGenericErrorMessage);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loginPageScaffoldTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(loginPageMessage),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: loginPageEmailHint,
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: loginPagePasswordHint,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = _email.text.trim();
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventLogIn(
                            email,
                            password,
                          ),
                        );
                  },
                  child: Text(loginPageLoginButtonText),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: Text(loginPageForgotPasswordButtonText),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: Text(loginPageRegisterButtonText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
