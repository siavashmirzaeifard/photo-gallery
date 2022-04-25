import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/auth/auth_error.dart';
import '/bloc/app_event.dart';
import '/bloc/app_state.dart';
import '/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    //handle uploading image
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;

      //log user out if we do not have actual user
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      //start loading process
      emit(AppStateLoggedIn(
        isLoading: true,
        user: user,
        images: state.images ?? [],
      ));
      final file = File(event.filePathToUpload);

      //uploading image
      await uploadImage(
        file: file,
        userId: user.uid,
      );

      //after upload is complete, grab the latest file reference
      final images = await _getImages(user.uid);

      //emit the new images and turned off loading
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
        images: images,
      ));
    });

    //handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;

      //log user out if we do not have actual user
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      //start loading
      emit(AppStateLoggedIn(
        isLoading: true,
        user: user,
        images: state.images ?? [],
      ));
      try {
        final folderContents = await FirebaseStorage.instance.ref(user.uid).list();

        //delete user images
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }

        //delete user folder
        await FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});

        //delete user
        await user.delete();
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: state.images ?? [],
          authError: AuthError.from(e),
        ));
      } on FirebaseException {
        //we are not able to delete the firebase storage folder, it means there is no user with this userId
        emit(const AppStateLoggedOut(isLoading: false));
      }
    });

    //handle logging out
    on<AppEventLogout>((event, emit) {
      //start loading
      emit(const AppStateLoggedOut(isLoading: true));
      FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    //handle app initialization state
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
      } else {
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ));
      }
    });

    //handle registration
    on<AppEventRegister>((event, emit) async {
      //start loading
      emit(const AppStateIsInRegistration(isLoading: true));
      try {
        final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AppStateLoggedIn(
          isLoading: false,
          user: credentials.user!,
          images: const [],
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateIsInRegistration(
          isLoading: false,
          authError: AuthError.from(e),
        ));
      }
    });

    //handle go to login
    on<AppEventGoToLogin>((event, emit) {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    //handle login
    on<AppEventLogIn>((event, emit) async {
      //start loading
      emit(const AppStateLoggedOut(isLoading: true));
      try {
        final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        final images = await _getImages(credentials.user!.uid);
        emit(AppStateLoggedIn(
          isLoading: false,
          user: credentials.user!,
          images: images,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(
          isLoading: false,
          authError: AuthError.from(e),
        ));
      }
    });

    //handle go to register
    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegistration(isLoading: false));
    });
  }

  //get user images
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then((listResult) => listResult.items);
}
