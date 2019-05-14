import 'package:binge_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth extends StatefulWidget {
  @override
  _UserAuthState createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback _showForgetPasswordSheet;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
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
    _showForgetPasswordSheet = _showBottomSheet;
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
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 32),
                  child: Text('Welcome',
                      style: Theme.of(context)
                          .textTheme
                          .display2
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
                        signInWithEmailAndPassword(
                                emailController.text, passwordController.text)
                            .then((user) {
                              setState(() {
                                passwordError = null;
                                emailError = null;
                              });
                              Navigator.pop(context);
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
                          Text('Login', style: Theme.of(context).textTheme.button),
                    ),

                    FlatButton(
                      onPressed: () {
                        _showForgetPasswordSheet();
                      },
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .apply(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.0),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet() {
    setState(() {
      _showForgetPasswordSheet = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return Container();
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showForgetPasswordSheet = _showBottomSheet;
            });
          }
        });
  }
}
