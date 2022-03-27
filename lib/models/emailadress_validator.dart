import 'package:agrargo/services/validator.dart';

class EmailAddressValidator implements Validator {
  const EmailAddressValidator();

  @override
  void validate(String value) {
    if (!value.endsWith("@google.com")) {
      throw Exception("Email address is not valid!");
    }
  }
}
