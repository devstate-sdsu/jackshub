import 'package:flutter/material.dart';
import 'package:jackshub/src/services/auth.dart';
import 'package:jackshub/src/shared/constants.dart';
import 'package:jackshub/src/shared/loading.dart';

class CreateAccountWithEmailLink extends StatefulWidget {
  final Function toggleView;
  CreateAccountWithEmailLink({ this.toggleView });
  @override
  _CreateAccountWithEmailLinkState createState() => _CreateAccountWithEmailLinkState();
}

class _CreateAccountWithEmailLinkState extends State<CreateAccountWithEmailLink> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Join carrot union'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Jacks Email'),
                validator: (val) => val.isEmpty ? 'Enter your jacks email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _auth.registerWithEmailLink(email);
                    setState(() {
                      error = 'Please check your email for a link';
                    });
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
        // child: RaisedButton(
        //   child: Text('Sign in anonymously'),
        //   onPressed: () async {
        //     dynamic result = await _auth.signInAnonymously();
        //     if (result == null) {
        //       print('error signing in');
        //     } else {
        //       print('sweet success');
        //       print(result.uid);
        //       print(result);
        //     }
        //   }
        // )
      ),
    );
  }
}