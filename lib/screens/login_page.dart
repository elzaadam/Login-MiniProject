import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project/screens/uploadDocumentScreen.dart';

import '../bloc/mainbloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            _buildHeader(context),
            _buildLoginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 142, 216, 225),
            Color.fromARGB(255, 56, 117, 152)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: const Center(
        child: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 30),
          MaterialButton(
            minWidth: double.infinity,
            color: const Color.fromARGB(255, 68, 196, 219),
            onPressed: () {
              BlocProvider.of<MainBloc>(context).add(VerifyAccount(
                username: usernameController.text,
                email: passwordController.text,
              ));
            },
            child: BlocConsumer<MainBloc, MainStates>(
              buildWhen: (previous, current) => current is Loading,
              builder: (context, state) {
                if (state is Loading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text("Login");
                }
              },
              listenWhen: (previous, current) =>
                  current is LoginSuccess || current is LoginFailure,
              listener: (context, state) {
                if (state is LoginSuccess) {
                  _showAlertDialog(
                    context: context,
                    title: "Sign in Successful",
                    message: "Welcome back! You have successfully signed in.",
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UploadDocumentsScreen()),
                      );
                    },
                  );
                } else if (state is LoginFailure) {
                  _showAlertDialog(
                    context: context,
                    title: "Sign in Unsuccessful",
                    message:
                        "The username or password you entered is incorrect.",
                    icon: Icons.error,
                    iconColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      ); // Close dialog
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: iconColor),
              ),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 68, 196, 219),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
