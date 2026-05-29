import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:trendora/presentation/screens/auth/login_screen.dart';
import 'package:trendora/presentation/screens/order/order_tracking_screen.dart';
import 'edit_profile_screen.dart';
import 'manage_address_screen.dart';
import '../order/order_history_screen.dart';
import 'privacy_security_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    /// USER LOGGED OUT
    if (user == null) {
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),

        builder: (context, snapshot) {
          /// LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// NO DATA
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final fullName = data['name'] ?? '';

          final email = data['email'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                /// PROFILE IMAGE
                CircleAvatar(
                  radius: 55,

                  backgroundColor: const Color(0xFFF7D6DF),

                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : "U",

                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA14F62),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// WELCOME TEXT
                Text(
                  "Welcome, $fullName 👋",

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// EMAIL
                Text(
                  email,

                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 40),

                /// ACCOUNT SETTINGS
                Align(
                  alignment: Alignment.centerLeft,

                  child: const Text(
                    "Account Settings",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                /// EDIT PROFILE
                _buildTile(
                  context: context,

                  icon: Icons.person,

                  title: "Edit Profile",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),

                /// MANAGE ADDRESS
                _buildTile(
                  context: context,

                  icon: Icons.location_on,

                  title: "Manage Address",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const ManageAddressScreen(),
                      ),
                    );
                  },
                ),

                /// ORDER HISTORY
                _buildTile(
                  context: context,

                  icon: Icons.shopping_bag,

                  title: "Order History",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),

                /// PRIVACY
                _buildTile(
                  context: context,

                  icon: Icons.lock,

                  title: "Privacy & Security",

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const PrivacySecurityScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                /// LOGOUT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA14F62),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),

                          (route) => false,
                        );
                      }
                    },

                    child: const Text(
                      "Logout",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,

    required IconData icon,

    required String title,

    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: const Color(0xFFA14F62)),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
