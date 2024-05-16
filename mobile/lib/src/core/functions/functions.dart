import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatNameByCapitalLetter(String? input) {
  if (input == null) return '';
  // Check if the entire input is uppercase. If so, return as is.
  if (input == input.toUpperCase()) {
    return input;
  }
  StringBuffer formattedString = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    if (input[i] == input[i].toUpperCase() && i != 0) {
      formattedString.write(' ');
    }
    formattedString.write(input[i]);
  }

  String result = formattedString.toString();
  return result[0].toUpperCase() + result.substring(1).toLowerCase();
}
