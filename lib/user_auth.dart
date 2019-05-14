import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

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
                  padding: EdgeInsets.only(
                      left: 32,
                      right: 32),
                  child: Text('Welcome',
                      style: Theme.of(context).textTheme.headline),
                ),
                SizedBox(height: 48.0),

                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    contentPadding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                  ),
                ),

                SizedBox(height: 16.0),

                Padding(
                  padding: EdgeInsets.only(
                      left: 32,
                      top: 32
                  ),
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                        left: 32,
                        right: 32,
                        top: 16,
                        bottom: 16
                    ),
                    onPressed: () {

                      signIn().then((user) {
                        print(user);
                      });

                    },
                    color: Theme.of(context).accentColor,
                    child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.button),
                  ),
                ),


                SizedBox(height: 24.0),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: FlatButton(
                    onPressed: () {
                      _showForgetPasswordSheet();
                    },
                    child: Text(
                      'Forgot Password',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .apply(color: Theme.of(context).accentColor),
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
