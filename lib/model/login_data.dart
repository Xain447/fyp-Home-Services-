class LoginInfo{
  static String _id;
  static String _name;
  static String _email;
  static String _phone;
  static String _password;
  static String _profileImage;

  String get profileImage => _profileImage;

  set setProfileImage(String value) {
    _profileImage = value;
  }

  String get id => _id;

  set setId(String value) {
    _id = value;
  }

  String get name => _name;

  String get password => _password;

  set setPassword(String value) {
    _password = value;
  }

  String get phone => _phone;

  set setPhone(String value) {
    _phone = value;
  }

  String get email => _email;

  set setEmail(String value) {
    _email = value;
  }

  set setName(String value) {
    _name = value;
  }

  Map data = {
    'id': _id,
    'name': _name,
    'email': _email,
    'phone': _phone,
    'password': _password,
  };

}