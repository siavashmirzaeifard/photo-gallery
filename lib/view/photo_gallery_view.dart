import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

import '/bloc/app_bloc.dart';
import '/bloc/app_event.dart';
import '/bloc/app_state.dart';
import '/view/main_pop_up_menu_button.dart';
import '/view/storage_image_view.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(
      () => ImagePicker(),
      [key],
    );
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo gallery"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) {
                return;
              }
              context.read<AppBloc>().add(AppEventUploadImage(filePathToUpload: image.path));
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images.map((image) => StorageImageView(image: image)).toList(),
      ),
    );
  }
}
