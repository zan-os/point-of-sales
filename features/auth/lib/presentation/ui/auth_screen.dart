import 'package:common/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final unfocusNode = FocusNode();
  TextEditingController? emailAddressController;
  TextEditingController? passwordController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _buildBody(),
        ),
      ),
    );
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
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: RoundBorderedTextFIeld(
                enabled: true,
                label: 'Email',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: RoundBorderedTextFIeld(
                enabled: true,
                label: 'Password',
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
              child: Builder(builder: (context) {
                return RoundedButtonWidget(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRouter.main),
                  title: 'Sign In',
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
