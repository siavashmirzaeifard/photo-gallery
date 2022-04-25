import 'package:flutter/foundation.dart' show immutable;

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

const Map<String, AuthError> authErrorMapping = {
  "user-not-found": AuthErrorUserNotFound(),
  "invalid-email": AuthErrorInvalidEmail(),
  "email-already-in-use": AuthErrorEmailAlreadyInUse(),
  "weak-password": AuthErrorWeakPassword(),
  "operation-not-allowed": AuthErrorOperationNotAllowed(),
  "requires-recent-login": AuthErrorRequireRecentLogin(),
  "no-current-user": AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ?? AuthErrorUnknown(exception);
}

@immutable
class AuthErrorUnknown extends AuthError {
  final FirebaseAuthException innerException;
  const AuthErrorUnknown(this.innerException)
      : super(
          dialogTitle: "Authentication error",
          dialogText: "Unknown authentication error.",
        );
}

// auth/no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: "No current user!",
          dialogText: "No current user with this information was found.",
        );
}

// auth/requires-recent-login
@immutable
class AuthErrorRequireRecentLogin extends AuthError {
  const AuthErrorRequireRecentLogin()
      : super(
          dialogTitle: "Require recent login",
          dialogText:
              "You need to log out and log back in again in order to preform this operation.",
        );
}

//email-password sign in is not allowed, enable it.
// auth/operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: "Operation not allowed",
          dialogText: "You can not register using this method at this moment.",
        );
}

// auth/user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: "User not found",
          dialogText: "The user was not found.",
        );
}

// auth/weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: "Weak password",
          dialogText: "Please choose a stronger password.",
        );
}

// auth/invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: "Invalid email",
          dialogText: "Please check your email and try again.",
        );
}

// auth/email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: "Email already in use",
          dialogText: "Please choose another email.",
        );
}
