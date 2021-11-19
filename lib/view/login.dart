import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gao_flutter/providers/api/AuthProvider.dart';
import 'package:gao_flutter/utils/shared_pref.dart';
import 'package:gao_flutter/utils/snackbar.notif.dart';
import 'package:gao_flutter/view/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var errorMsg;
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 14), primary: const Color(0xffA03E99));
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signIn(String email, String password) async {
    var loginStatus = await AuthAPIProvider().login(email, password);

    if (loginStatus) {
      var token = sharedPref().read("token");
      if (token != null) {
        SendNotificationSnackBar('Authentification réussi !', context);
        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()),
                (Route<dynamic> route) => false);
      }
    }
    SendNotificationSnackBar('Votre identifiant est invalide', context);
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        //margin: const EdgeInsets.only(
        //left: 10, top: 50, right: 10, bottom: 0),
        _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xffA03E99),))
            :  ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            const Center(child: Text("Connexion",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              //initialValue: 'Input text',
              decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              //initialValue: 'Input text',
              decoration: const InputDecoration(
                  labelText: "Mot de passe",
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: style,
              onPressed: () {
                print("Login pressed");
                setState(() {
                  _isLoading = true;
                });
                signIn(emailController.text, passwordController.text);
              },
              child: const Text('Se connecter'),
            ),
            errorMsg == null
                ? Container()
                : Text(
              "${errorMsg}",
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Mot de passe oublié ?',
                style: TextStyle(
                  color: Color(0xffA03E99),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],


        )

    );
  }


}
