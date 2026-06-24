import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../features/wallet/screens/home_screen.dart';
import '../../auth/screens/otp_totp_authenticator.dart';
import '../../../data/services/authenticator_service.dart';
import '../screens/setup_authenticator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // ambil input email & password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();
  String generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.lightBlue,
            displayColor: Colors.lightBlue,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // logo evan coding store
                        Center(
                          child: Image.asset("images/ecs.png", height: 180),
                        ),

                        const SizedBox(height: 20),

                        // judul
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue[700],
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Masuk ke wallet kamu",
                          style: TextStyle(color: Colors.lightBlue),
                        ),

                        const SizedBox(height: 30),

                        // input email
                        CustomTextField(
                          controller: emailController,
                          hint: "Email",
                        ),

                        const SizedBox(height: 20),

                        // input password
                        CustomTextField(
                          controller: passwordController,
                          hint: "Password",
                          obscure: true,
                        ),

                        const SizedBox(height: 30),

                        // tombol login
                        CustomButton(
                          text: "Login",
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email & Password wajib diisi"),
                                ),
                              );
                              return;
                            }

                            if (!email.contains("@")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Format email tidak valid"),
                                ),
                              );
                              return;
                            }

                            try {
                              final user = await auth.signIn(email, password);

                              final userDoc = FirebaseFirestore.instance
                                  .collection('wallets')
                                  .doc(user.uid);

                              final doc = await userDoc.get();

                              String? authSecret;

                              if (!doc.exists) {
                                await userDoc.set({
                                  'email': user.email,
                                  'authSecret': null,
                                  'createdAt': Timestamp.now(),
                                });

                                authSecret = null;
                              } else {
                                authSecret = doc.data()?['authSecret'];
                              }

                              if (authSecret == null || authSecret.isEmpty) {
                                authSecret =
                                    AuthenticatorService.generateSecret();

                                await userDoc.update({
                                  'authSecret': authSecret,
                                });

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SetupAuthenticatorScreen(
                                      email: user.email!,
                                      secret: authSecret!,
                                    ),
                                  ),
                                );
                              }

                              final verified = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AuthVerificationScreen(
                                    secret: authSecret!,
                                  ),
                                ),
                              );

                              if (verified == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              } else {
                                await FirebaseAuth.instance.signOut();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
