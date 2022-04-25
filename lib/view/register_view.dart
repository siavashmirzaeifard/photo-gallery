import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '/bloc/app_event.dart';
import '/extension/if_debugging.dart';
import '/bloc/app_bloc.dart';

class RegisterView extends HookWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: "siavash.mf@gmail.com".ifDebugging);
    final passwordController = useTextEditingController(text: "123456".ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,
                decoration: const InputDecoration(hintText: "Enter your email here ..."),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                keyboardAppearance: Brightness.dark,
                obscuringCharacter: "⊚",
                decoration: const InputDecoration(hintText: "Enter your password here ..."),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        AppEventRegister(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppEventGoToLogin());
                },
                child: const Text("Already registered? Log in here."),
              ),
            ],
          )),
    );
  }
}
