class Util {
  static String countryCodeToFlag(String code) {
    if (code == 'EN' || code == 'UK') {
      code = 'GB';
    }

    return code.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
  }
}
