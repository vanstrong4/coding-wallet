import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../features/wallet/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Controller untuk input email & password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService auth = AuthService();

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

                        // Logo
                        Center(
                          child: Image.asset("images/ecs.png", height: 180),
                        ),

                        const SizedBox(height: 20),

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

                        // Email
                        CustomTextField(
                          controller: emailController,
                          hint: "Email",
                        ),

                        const SizedBox(height: 20),

                        // Password
                        CustomTextField(
                          controller: passwordController,
                          hint: "Password",
                          obscure: true,
                        ),

                        const SizedBox(height: 30),

                        // Tombol Login
                        CustomButton(
                          text: "Login",
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

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
                              await auth.signIn(email, password);

                              if (!context.mounted) return;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } catch (e) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceFirst(
                                      "Exception: ",
                                      "",
                                    ),
                                  ),
                                ),
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
