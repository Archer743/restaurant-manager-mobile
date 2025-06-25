class Validators {
  static const String _validPasswordRegex =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,16}$";
  static const String _validEmailRegex =
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  static const String _validPhoneRegex = r"^\+?[0-9\s\-\(\)./]{7,20}$";

  static final _passwordRegex = RegExp(_validPasswordRegex);
  static final _emailRegex = RegExp(_validEmailRegex);
  static final _phoneRegex = RegExp(_validPhoneRegex);

  static bool isValidPassword(String password) {
    return _passwordRegex.hasMatch(password);
  }

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone);
  }
}
