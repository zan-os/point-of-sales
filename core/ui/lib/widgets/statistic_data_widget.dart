import '../ui.dart';

class StatisticDataWidget extends StatelessWidget {
  final int tOrder, tDistribution, tNewOrder, tCanceled;
  const StatisticDataWidget({
    super.key,
    this.tOrder = 0,
    this.tDistribution = 0,
    this.tNewOrder = 0,
    this.tCanceled = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tOrder.toString(), 'Total Distributor'),
            _buildStatisticWidget(tDistribution.toString(), 'Total Customer'),
          ],
        ),
        const SizedBox(height: 8.0),
        const Divider(thickness: 1.0),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildStatisticWidget(tNewOrder.toString(), 'New Order'),
            _buildStatisticWidget(tCanceled.toString(), 'Canceled Order'),
          ],
        ),
      ],
    );
  }

  Column _buildStatisticWidget(String count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20.0,
            color: ColorConstants.primaryYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            color: ColorConstants.greyColor,
          ),
        ),
      ],
    );
  }
}
