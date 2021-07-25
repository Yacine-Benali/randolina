class Validators {
  static bool isValidName(String? value) {
    if (value != null) {
      return RegExp(r'^[a-zA-Z\s]+$').hasMatch(value);
    } else {
      return false;
    }
  }

  static bool isValidUsername(String? value) {
    if (value != null) {
      return RegExp(
              r'^(?=.{3,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$')
          .hasMatch(value);
    } else {
      return false;
    }
  }

  static bool isValidPassword(String? value) {
    if (value != null) {
      return RegExp(r'^(?=.*[0-9a-zA-Z]).{6,}$').hasMatch(value);
    } else {
      return false;
    }
  }
}
