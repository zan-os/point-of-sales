import 'package:dependencies/intl/intl.dart';

String formatRupiah(String? value) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp.',
    decimalDigits: 0,
  );
  return formatCurrency.format(int.parse(value ?? '0'));
}