import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/components/custom_text_field_widget.dart';
import '../../../core/components/loading_button_widget.dart';
import '../../../core/routes/router.dart';
import '../../../core/static/login.dart';
import '../../../core/validators/validators.dart';
import '../../../data/prefs/prefs.dart';
import '../../../data/models/requests/login_request_model.dart';
import '../../../providers/auth/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await Prefs().isUserLoggedIn();
    if (isLoggedIn) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24.0,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 60.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    'Welcome to\nMemoirly',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Capture Memories, Share Moments',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    onChanged: (value) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: validatePassword,
                    onChanged: (value) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        if (provider.resultState is LoginLoadingState) {
                          return const LoadingButton(
                            text: 'Loading..',
                          );
                        }
                        if (provider.resultState is LoginLoadedState) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.go(Routes.home);
                          });
                        }
                        if (provider.resultState is LoginErrorState) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  content: Text(
                                      (provider.resultState as LoginErrorState)
                                          .error),
                                ),
                              );
                            },
                          );
                        }

                        return FilledButton(
                          onPressed: () {
                            final loginRequestModel = LoginRequestModel(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (_formKey.currentState?.validate() ?? false) {
                              provider.login(loginRequestModel);
                            }
                          },
                          child: const Text(
                            'Login',
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      GestureDetector(
                        onTap: () {
                          context.push(Routes.register);
                        },
                        child: Text(
                          ' Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
