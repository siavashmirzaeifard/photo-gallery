import 'package:flutter/foundation.dart' show immutable;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;
  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.images,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  // we need equality here -> because when the user upload a new photo something changed, and AppState should understand what changes happened.
  @override
  bool operator ==(other) {
    if (other is AppStateLoggedIn) {
      return isLoading == other.isLoading &&
          user.uid == other.user.uid &&
          images.length == other.images.length;
    } else {
      return false;
    }
  }

  //isLoading exists in AppState, so we do not need the hashCode for isLoading here
  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => "AppStateLoggedIn, images.length = ${images.length}";
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() => "AppStateLoggedOut, isLoading = $isLoading, authError = $authError";
}

@immutable
class AppStateIsInRegistration extends AppState {
  const AppStateIsInRegistration({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

// helper extensions to get user out of the loggedInState and ...
extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
