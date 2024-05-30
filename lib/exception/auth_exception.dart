enum AuthResultStatus {
  successful,
  emailAlreadyExist,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowrd,
  tooManyRequests,
  undefined,
  weakPassword,
}

class AuthException {
  static handleException(e) {
    final AuthResultStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "invalid-disabled-field":
        status = AuthResultStatus.userDisabled;
        break;
      case "too-many-request":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowrd;
        break;
      case "email-already-used":
        status = AuthResultStatus.emailAlreadyExist;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformes.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "user with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "The password provided is too week.";
        break;
      case AuthResultStatus.operationNotAllowrd:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExist:
        errorMessage =
            "The email already been registered. Please login or reset password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }
    return errorMessage;
  }
}
