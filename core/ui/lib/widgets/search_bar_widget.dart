import '../ui.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoundedContainerDrawable(
      radius: 50.0,
      padding: 0.0,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          hintStyle: TextStyle(color: ColorConstants.greyColor),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: ColorConstants.primaryYellow,
              child: Icon(
                Icons.search,
                color: ColorConstants.whiteBackground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
