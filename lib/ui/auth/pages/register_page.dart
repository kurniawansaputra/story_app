import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/components/custom_text_field_widget.dart';
import '../../../core/components/loading_button_widget.dart';
import '../../../core/routes/router.dart';
import '../../../core/static/register.dart';
import '../../../core/validators/validators.dart';
import '../../../data/models/requests/register_request_model.dart';
import '../../../providers/auth/register_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Fill in the form to get started',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Name',
                    validator: validateName,
                    onChanged: (value) => _formKey.currentState?.validate(),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
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
                    child: Consumer<RegisterProvider>(
                      builder: (context, provider, child) {
                        if (provider.resultState is RegisterLoadingState) {
                          return const LoadingButton(
                            text: 'Loading..',
                          );
                        }
                        if (provider.resultState is RegisterLoadedState) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              final message =
                                  (provider.resultState as RegisterLoadedState)
                                      .data
                                      .message;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(message!),
                                ),
                              );
                              provider.resetState();
                              context.go(Routes.login);
                            },
                          );
                        }
                        if (provider.resultState is RegisterErrorState) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                  content: Text((provider.resultState
                                          as RegisterErrorState)
                                      .error),
                                ),
                              );
                            },
                          );
                        }

                        return FilledButton(
                          onPressed: () {
                            final registerRequestModel = RegisterRequestModel(
                              name: _fullNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (_formKey.currentState?.validate() ?? false) {
                              provider.register(registerRequestModel);
                            }
                          },
                          child: const Text('Register'),
                        );
                      },
                    ),
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
