// Flutter imports:
import 'package:flutter/services.dart';

class ValidationHelper {
  // User Name
  static const String _kUserNameIsEmpty = 'Username is required.';

  // First Name

  // Last Name
  static const String _kLastNameIsEmpty = 'Please enter your last name.';

  // Email
  static const String _kEmailIsEmpty = 'Please enter your email address.';
  static const String _kInvalidEmail = 'Please enter valid email address.';

  // Mobile
  static const String _kInvalidMobile = 'Please enter valid phone number.';
  static const String _kMobileIsEmpty = 'Please enter phone number.';

  // Mobile
  static const String _kInvalidOTP = 'Please enter valid OTP.';

  // PingCode
  static const String _kInvalidPinCode = 'Please enter valid pin code number.';

  // OTP
  static const String _kOtpIsEmpty = 'Please enter received OTP.';

  // Password
  static const String _kPasswordIsEmpty = 'Please enter your password';
  static const String _kPasswordContain = 'Password must contain UPPER/lowercase,\n special characters and numbers.';

  static const String _kPasswordLengthValidation = 'Please enter password at least 6 characters.';
  static const String _kPasswordNotMatching = 'Passwords are not matching.';
  static const String _kConfirmPasswordIsEmpty = 'Confirm password is required.';

  // Address
  static const String _kAddressIsEmpty = 'Please enter your address';
  static const String _kAddressLengthValidation = 'Please enter address at least 4 characters.';

  static const String _kPaymentIsEmpty = 'Please enter received OTP.';
  static const String _kPaymentInvalid = 'Please enter valid OTP.';

  static const String _kFirstNameIsEmpty = 'Please enter your first name.';
  static const String _kNameIsEmpty = 'Please enter your name.';

  static const String _kMiddleNameIsEmpty = 'Please enter your middle name.';
  static const String _kBirthdateIsEmpty = 'Please enter your birthdate';

  static const String _kDescriptionIsEmpty = 'Please enter Description';
  static const String _kDescriptionLengthValidation = 'Please enter Description at least 4 characters.';

  static String? validatePassword(
    String? value, {
    int? length,
    String? lengthValidation,
    String? regexpValidation,
    bool isPasswordNotMatching = false,
  }) {
    final passwordLength = length ?? 6;
    if (value!.isEmpty) {
      return _kPasswordIsEmpty;
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])').hasMatch(value)) {
      return regexpValidation ?? _kPasswordContain;
    } else if (value.length <= passwordLength) {
      return lengthValidation ?? _kPasswordLengthValidation;
    } else if (isPasswordNotMatching) {
      return _kPasswordNotMatching;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value, {
    bool isPasswordNotMatching = false,
  }) {
    final String password = value?.trim() ?? '';
    if (isPasswordNotMatching) {
      return _kPasswordNotMatching;
    } else if (password.isEmpty) {
      return _kConfirmPasswordIsEmpty;
    }
    return null;
  }

  static String? validateUserName(String? value) {
    final String userName = value?.trim() ?? '';
    if (userName.isEmpty) {
      return _kUserNameIsEmpty;
    }
    return null;
  }

  static String? validateAddress(String? value) {
    final String address = value?.trim() ?? '';
    if (address.isEmpty) {
      return _kAddressIsEmpty;
    } else if (address.length < 4) {
      return _kAddressLengthValidation;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final RegExp regExp = RegExp(pattern);
    final String email = value?.trim() ?? '';
    if (email.isEmpty) {
      return _kEmailIsEmpty;
    } else if (!regExp.hasMatch(email)) {
      return _kInvalidEmail;
    }
    return null;
  }

  static String? validateMobile(String? value) {
    const String pattern = r'(^[0-9]{10}$)';
    final RegExp regExp = RegExp(pattern);
    final String phoneNumber = value?.trim().replaceAll(' ', '') ?? '';
    if (phoneNumber.isEmpty) {
      return _kMobileIsEmpty;
    } else if (phoneNumber.length > 10) {
      return _kInvalidMobile;
    } else if (!regExp.hasMatch(phoneNumber)) {
      return _kInvalidMobile;
    }
    return null;
  }

  static String? validateOTP(String? value) {
    const String pattern = r'(^[0-9]{6}$)';
    final RegExp regExp = RegExp(pattern);
    final String otp = value?.trim().replaceAll(' ', '') ?? '';
    if (otp.isEmpty) {
      return _kOtpIsEmpty;
    } else if (otp.length > 6) {
      return _kInvalidOTP;
    } else if (!regExp.hasMatch(otp)) {
      return _kInvalidOTP;
    }
    return null;
  }

  static String? validatePinCode(String? value) {
    const String pattern = r'(^[0-9]{6}$)';
    final RegExp regExp = RegExp(pattern);
    final String pinCodeNo = value?.trim().replaceAll(' ', '') ?? '';
    if (pinCodeNo.isEmpty) {
      return null;
    } else if (pinCodeNo.length > 6) {
      return _kInvalidPinCode;
    } else if (!regExp.hasMatch(pinCodeNo)) {
      return _kInvalidPinCode;
    }
    return null;
  }

  static String? validatePayment(String? value) {
    const String pattern = r'(^[0-9]{4}$)';
    final RegExp regExp = RegExp(pattern);
    final String payment = value?.trim().replaceAll(' ', '') ?? '';
    if (payment.isEmpty) {
      return _kPaymentIsEmpty;
    } else if (payment.length > 4) {
      return _kPaymentInvalid;
    } else if (!regExp.hasMatch(payment)) {
      return _kPaymentInvalid;
    }
    return null;
  }

  static String? validateName(String? value) {
    final String name = value?.trim() ?? '';
    if (name.isEmpty) {
      return _kNameIsEmpty;
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    final String firstName = value?.trim() ?? '';
    if (firstName.isEmpty) {
      return _kFirstNameIsEmpty;
    }
    return null;
  }

  static String? validateLastName(String? value) {
    final String lastName = value?.trim() ?? '';
    if (lastName.isEmpty) {
      return _kLastNameIsEmpty;
    }
    return null;
  }

  static String? validateMiddleName(String? value) {
    final String middleName = value?.trim() ?? '';
    if (middleName.isEmpty) {
      return _kMiddleNameIsEmpty;
    }
    return null;
  }

  static String? validateBirthDate(String? value) {
    final String birthdate = value?.trim() ?? '';
    if (birthdate.isEmpty) {
      return _kBirthdateIsEmpty;
    }
    return null;
  }

  static String? validateDescription(String? value) {
    final String description = value?.trim() ?? '';
    if (description.isEmpty) {
      return _kDescriptionIsEmpty;
    } else if (description.length < 4) {
      return _kDescriptionLengthValidation;
    }
    return null;
  }

  static final FilteringTextInputFormatter noSpaceFormatter = FilteringTextInputFormatter.deny(RegExp(r'\s'));
  static final FilteringTextInputFormatter noDigitWithAlphabetFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
}
