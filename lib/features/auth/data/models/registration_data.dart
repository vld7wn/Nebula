/// Данные регистрации, передаваемые между экранами
class RegistrationData {
  String email;
  String phone;
  String password;
  String firstName;
  String lastName;
  String? avatarUrl;

  RegistrationData({
    this.email = '',
    this.phone = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.avatarUrl,
  });
}
