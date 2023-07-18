import 'package:common/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:ui/const/colors_constants.dart';
import 'package:ui/widgets/app_bar_widget.dart';
import 'package:ui/widgets/round_bordered_text_field.dart';
import 'package:ui/widgets/rounded_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final String email;
  final String role;
  ProfileScreen({super.key, required this.email, required this.role});

  SafeArea _scaffoldBody() {
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 24),
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.primaryYellow,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: ColorConstants.whiteBackground,
                  size: 70,
                ),
              ),
            ),
            _buildProfileForm(label: email),
            _buildProfileForm(label: role),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Builder(builder: (context) {
      return RoundedButtonWidget(
        title: 'Sign Out',
        onTap: () => Navigator.popAndPushNamed(context, AppRouter.auth),
      );
    });
  }

  Padding _buildProfileForm({String label = '-'}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: RoundBorderedTextFIeld(
        enabled: false,
        label: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child:Scaffold(
        key: navigatorKey,
        appBar: const AppBarWidget(
          isHome: false,
          title: 'Profile',
          enableLeading: false,
        ),
        backgroundColor: Colors.white,
        body: _scaffoldBody(),
      ),
    );
  }
}
