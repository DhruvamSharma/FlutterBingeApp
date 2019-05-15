import 'package:binge_app/auth_bloc.dart';
import 'package:binge_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserSignUp extends StatefulWidget {
  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = authBloc.auth;
  final GoogleSignIn googleSignIn = authBloc.googleSignIn;

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailErrorTemplate = 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)';
  String passwordErrorTemplate = 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)';

  String emailError;
  String passwordError;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Center(child: Image.network('https://firebasestorage.googleapis.com/v0/b/binge-ad250.appspot.com/o/unnamed-2.png?alt=media&token=cfb8e6da-aea2-4760-a378-a562e1aece77', height: 200)),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 32),
                  child: Text('Sign Up',
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Colors.black)),
                ),
                SizedBox(height: 48.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    errorText: emailError,
                    contentPadding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  autofocus: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: passwordError,
                    contentPadding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      padding:
                      EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
                      onPressed: () {
                        signUpWithEmailAndPassword(
                            emailController.text, passwordController.text)
                            .then((user) {
                          setState(() {
                            passwordError = null;
                            emailError = null;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Binge',)));

                        }).catchError((error) {
                          if(error.toString() == emailErrorTemplate){
                            setState(() {
                              emailError = error.message;
                              passwordController.clear();
                              passwordError = null;
                            });
                          } else if (error.toString() == passwordErrorTemplate) {
                            setState(() {
                              emailError = null;
                              passwordError = error.message;
                            });
                          } else {
                            //TODO show error in a snackbar
                          }
                        });
                      },
                      color: Theme.of(context).accentColor,
                      child:
                      Text('Sign Up', style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white
                      )),
                    ),

                  ],
                ),

                SizedBox(height: 24.0),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Already have an account, Sign In',
                      style: Theme.of(context).textTheme.button,
                    )
                ),
                SizedBox(height: 24.0),
                Center(
                  child: RaisedButton(
                    color: Colors.white,
                    onPressed: () {
                      signIn().then((user) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Binge',)));

                      }).catchError((error) {
                        //TODO show error in a snackbar

                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.network('https://media.licdn.com/dms/image/C4D0BAQHiNSL4Or29cg/company-logo_200_200/0?e=2159024400&v=beta&t=0e00tehBFFtuqgUCfAijpOkoBl89jxOTIe_k9HHpi_4',
                          width: 30,
                        ),
                        Text('Sign Up')
                      ],
                    ),
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
