import 'package:ui/ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final unfocusNode = FocusNode();
  FocusNode? unfocuseNode;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;
  // State field(s) for city widget.
  TextEditingController? cityController;
  String? Function(BuildContext, String?)? cityControllerValidator;
  // State field(s) for state widget.
  String? stateValue;
  // State field(s) for myBio widget.
  TextEditingController? myBioController;
  String? Function(BuildContext, String?)? myBioControllerValidator;

  @override
  Widget build(BuildContext context) {
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
      onTap: () => Navigator.pop(context),
    );
  }

  Padding _buildProfileForm({String label = '-'}) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        enabled: false,
        controller: yourNameController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: label,
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
        maxLines: null,
      ),
    );
  }
}
