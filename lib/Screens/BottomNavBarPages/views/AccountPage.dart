import 'package:flutter/material.dart';

import '../../Authentication/services/auth_service.dart';
import '../../Authentication/widgets/providerWidget.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/Account/account.png'),
            SizedBox(height: 100.0),
            Center(
              child: MaterialButton(
                color: Colors.amber,
                onPressed: () async {
                  try {
                    AuthService auth = Provider.of(context).auth;
                    await auth.signOut();
                  } catch (e) {
                    print(e);
                  }
                },

                //TODO: fix this
                // icon: Icon(
                //   Icons.exit_to_app,
                //   color: Colors.white,
                // ),
                // t: Text(
                //   'Logout',
                //   style: TextStyle(color: Colors.white, fontSize: 20.0),
                // ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
