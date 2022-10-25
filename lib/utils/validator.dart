class Validator {
  Validator();

  String? validateEmail(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please enter a valid email address.';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your id';
    }
    if (value.length < 6) {
      return 'Id should atleast 3 chars';
    } else {
      return null;
    }
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length > 6) {
      return 'Max of 6 Chars only allowed';
    } else {
      return null;
    }
  }
}
