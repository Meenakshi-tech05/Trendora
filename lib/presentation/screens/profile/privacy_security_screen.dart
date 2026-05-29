import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),

      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.lock), title: Text("Change Password")),

          ListTile(
            leading: Icon(Icons.devices),
            title: Text("Logout from all devices"),
          ),

          ListTile(leading: Icon(Icons.policy), title: Text("Privacy Policy")),

          ListTile(
            leading: Icon(Icons.security),
            title: Text("Secure Payments"),
          ),

          ListTile(
            leading: Icon(Icons.description),
            title: Text("Terms & Conditions"),
          ),
        ],
      ),
    );
  }
}
