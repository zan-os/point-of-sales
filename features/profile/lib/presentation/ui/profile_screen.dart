import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unfocusNode = FocusNode();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
              child: Container(
                height: 100,
                width: 100,
                color: ColorConstants.primaryYellow,
              ),
            ),
            _buildProfileForm(label: 'Fauzan'),
            _buildProfileForm(label: 'Kasir'),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return RoundedButtonWidget(
      title: 'Sign Out',
      onTap: () => navigatorKey.currentState?.popAndPushNamed('/auth'),
    );
  }

  Padding _buildProfileForm({String label = '-'}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: RoundBorderedTextFIeld(onChange: (p0) {
        
      },
        enabled: false,
        label: label,
      ),
    );
  }
}
