import 'package:A.N.R/services/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', width: 112),
              const SizedBox(height: 48),
              Text(
                'Bem-vindo!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Faça o login abaixo e aprovei sua leitura!',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 24),
              SignInButton(
                Buttons.Google,
                text: 'Entrar com o Google',
                onPressed: () => Session.signInWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
