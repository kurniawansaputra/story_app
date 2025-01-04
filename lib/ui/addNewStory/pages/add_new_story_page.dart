import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/components/custom_text_field_widget.dart';
import '../../../core/validators/validators.dart';
import '../../../providers/addNewStory/image_picker_provider.dart';
import '../../../providers/addNewStory/image_upload_provider.dart';

class AddNewStoryPage extends StatefulWidget {
  final Function onRefresh;

  const AddNewStoryPage({
    super.key,
    required this.onRefresh,
  });

  @override
  State<AddNewStoryPage> createState() => _AddNewStoryPageState();
}

class _AddNewStoryPageState extends State<AddNewStoryPage> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            16.0,
          ),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                onTap: () {
                  _onGalleryView();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                onTap: () {
                  _onCameraView();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Story'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 180.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child:
                        context.watch<ImagePickerProvider>().imagePath == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 32.0,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    'Tap to upload image',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                                child: _showImage(),
                              ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                CustomTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  keyboardType: TextInputType.multiline,
                  validator: validateDescription,
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (value) => _formKey.currentState?.validate(),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onUpload();
                      }
                    },
                    child: context.watch<ImageUploadProvider>().isUploading
                        ? const SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Add Story"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<ImagePickerProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<ImagePickerProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<ImagePickerProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final imageUploadProvider = context.read<ImageUploadProvider>();

    final imagePickerProvider = context.read<ImagePickerProvider>();
    final imagePath = imagePickerProvider.imagePath;
    final imageFile = imagePickerProvider.imageFile;

    if (imagePath == null || imageFile == null) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            "Select an image",
          ),
        ),
      );
      return;
    }

    final description = _descriptionController.text;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await imageUploadProvider.compressImage(bytes);

    await imageUploadProvider.upload(
      newBytes,
      fileName,
      description,
    );

    if (imageUploadProvider.defaultResponse != null) {
      imagePickerProvider.setImageFile(null);
      imagePickerProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(
        backgroundColor: imageUploadProvider.defaultResponse != null
            ? Colors.green
            : Theme.of(context).colorScheme.error,
        content: Text(
          imageUploadProvider.message,
        ),
      ),
    );

    if (imageUploadProvider.defaultResponse != null) {
      widget.onRefresh();
      context.pop();
    }
  }
}
