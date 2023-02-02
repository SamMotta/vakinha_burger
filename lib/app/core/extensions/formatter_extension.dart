import 'package:intl/intl.dart';

extension FormatterExtension on double {
  String get currencyBR {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
    );

    return currencyFormatter.format(this);
  }
}
