import 'dart:developer';

import 'package:auth/presentation/cubit/auth_cubit.dart';
import 'package:auth/presentation/cubit/auth_state.dart';
import 'package:common/navigation/app_router.dart';
import 'package:common/utils/cubit_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/loading_animation/loading_animation.dart';
import 'package:dependencies/supabase/supabase.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      lazy: true,
      child: const AuthScreenContent(),
    );
  }
}

class AuthScreenContent extends StatefulWidget {
  const AuthScreenContent({super.key});

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  final supabase = Supabase.instance.client;
  final unfocusNode = FocusNode();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  SafeArea _buildBody() {
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAppTitle(),
            _buildAuthForm(),
          ],
        ),
      ),
    );
  }

  Container _buildAppTitle() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      alignment: const AlignmentDirectional(-1, 0),
      child: const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
        child: Text(
          'POS App',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Align _buildAuthForm() {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundBorderedTextFIeld(
                controller: emailController,
                enabled: true,
                label: 'Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundBorderedTextFIeld(
                controller: passwordController,
                enabled: true,
                label: 'Password',
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: RoundedButtonWidget(
                onTap: () {
                  final String email = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  context.read<AuthCubit>().loginWithEmail(email, password);
                  FocusScope.of(context).requestFocus(unfocusNode);
                },
                title: 'Sign In',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(unfocusNode);
      },
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<AuthCubit, AuthenticateState>(
            builder: (context, state) {
              if (state.status == CubitState.loading) {}
              if (state.status == CubitState.hasData) {}
              if (state.status == CubitState.error) {}
              return _buildBody();
            },
            listener: (context, state) {
              if (state.status == CubitState.loading) {
                log('loading');
                showDialog(
                  context: context,
                  builder: (context) => LoadingAnimationWidget.inkDrop(
                      color: Colors.white, size: 50),
                );
              }
              if (state.status == CubitState.hasData) {
                final Map<String, String> arguments = {
                  'userId': state.userId,
                  'role': state.role,
                  'email': emailController.text.trim()
                };
                log('id ${state.userId} role ${state.role}');
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacementNamed(
                  context,
                  AppRouter.main,
                  arguments: arguments,
                );
              }
              if (state.status == CubitState.error) {
                log('error');
              }
            },
          ),
        ),
      ),
    );
  }
}