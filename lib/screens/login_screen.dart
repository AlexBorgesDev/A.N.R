import 'package:A.N.R/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _signInWithGoogle(Function(String?) call) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        call(null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        call('Essa conta já existe com uma credencial diferente.');
      } else if (e.code == 'invalid-credential') {
        call('Ocorreu um erro ao acessar as credenciais.');
      } else {
        call('Ocorreu um erro ao tentar entrar com o Google.');
      }
    } catch (e) {
      call('Ocorreu um erro ao tentar entrar com o Google.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                onPressed: () => _signInWithGoogle((error) {
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
                  } else {
                    Navigator.of(context).pushReplacementNamed(
                      RoutesName.BROWSER,
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
