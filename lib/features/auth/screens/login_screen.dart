import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../features/wallet/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // ambil input email & password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

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
                          "Masuk ke akun kamu",
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

                            // cek kosong
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email & Password wajib diisi"),
                                ),
                              );
                              return;
                            }

                            // validasi email
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

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login berhasil")),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().contains("verifikasi")
                                        ? "Email belum diverifikasi, cek inbox kamu"
                                        : "Email atau password salah",
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
