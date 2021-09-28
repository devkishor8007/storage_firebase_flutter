import 'package:flutter/material.dart';
import 'package:flux_firex_storage/main.dart';
import 'package:flux_firex_storage/service/auth_service.dart';

class AnonymouslyLogin extends StatefulWidget {
  @override
  _AnonymouslyLoginState createState() => _AnonymouslyLoginState();
}

class _AnonymouslyLoginState extends State<AnonymouslyLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          makeStraightLine(context),
          Center(
            child: InkWell(
              onTap: () async {
                await AuthService.loginAnonymously();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => AuthChecker()),
                    (route) => false);
              },
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.indigo,
                child: Text(
                  "go",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          makeStraightLine(context),
        ],
      ),
    );
  }

  Widget makeStraightLine(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: 10,
        color: Colors.grey,
      ),
    );
  }
}
