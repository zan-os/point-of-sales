import 'package:dependencies/intl/intl.dart';

String formatRupiah(int? value) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp.',
    decimalDigits: 0,
  );
  return formatCurrency.format(value ?? 0);
}
