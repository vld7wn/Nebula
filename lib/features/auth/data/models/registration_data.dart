/// Данные регистрации, передаваемые между экранами
class RegistrationData {
  String email;
  String phone;
  String password;
  String firstName;
  String lastName;
  String? avatarUrl;

  // Phone Auth данные
  String? verificationId;
  int? resendToken;

  RegistrationData({
    this.email = '',
    this.phone = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.avatarUrl,
    this.verificationId,
    this.resendToken,
  });
}
