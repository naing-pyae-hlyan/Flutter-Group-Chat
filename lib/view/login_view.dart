import 'package:flutter/material.dart';
import 'package:flutter_group_chat/controller/login_controller.dart';
import 'package:flutter_group_chat/view/home_view.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = Get.put(LoginController());
  TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  Future<void> _routeMain() async {
    _loginController.name = _editingController.text.obs;
    Get.off(HomeView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _editingController,
            ),
            SizedBox(height: 32.0),
            RaisedButton.icon(
              icon: Icon(Icons.login),
              label: Text('Sign In'),
              onPressed: () => _routeMain(),
            ),
          ],
        ),
      ),
    );
  }
}
