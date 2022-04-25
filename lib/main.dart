import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_bloc.dart';
import '/bloc/app_event.dart';
import '/dialog/show_error_dialog.dart';
import '/loading/loading_screen.dart';
import '/view/login_view.dart';
import '/view/photo_gallery_view.dart';
import '/view/register_view.dart';
import '/bloc/app_state.dart';
import '/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(context: context, text: "Loading ...");
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showErrorDialog(context: context, authError: authError);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistration) {
              return const RegisterView();
            } else if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
