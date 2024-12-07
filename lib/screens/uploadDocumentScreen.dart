import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/bloc/uploadbloc.dart';
import 'package:mini_project/screens/dashboardscreen.dart';


class UploadDocumentsScreen extends StatelessWidget {
  const UploadDocumentsScreen({super.key});

  Future<void> _pickFile({
    required String title,
    required BuildContext context,
  }) async {
    final uploadBloc = context.read<UploadBloc>();
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text("Use Camera"),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.camera);
              if (file != null) {
                uploadBloc.add(PickFile(title: title, file: File(file.path)));
              }
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Use Gallery"),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                uploadBloc.add(PickFile(title: title, file: File(file.path)));
              }
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_present),
            title: const Text("Select PDF"),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result != null && result.files.single.path != null) {
                uploadBloc.add(PickFile(
                  title: title,
                  file: File(result.files.single.path!),
                ));
              }
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Documents'),
        ),
        body: BlocBuilder<UploadBloc, UploadStates>(
          builder: (context, state) {
            final uploadBloc = context.read<UploadBloc>();
            final uploadedFiles = (state is FileUploaded)
                ? state.uploadedFiles
                : uploadBloc.uploadedFiles;

            final uploadProgress =
                uploadedFiles.values.where((file) => file != null).length /
                    uploadedFiles.length;

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 142, 216, 225),
                    Color.fromARGB(255, 204, 242, 244),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Linear Progress Indicator
                        LinearProgressIndicator(
                          value: uploadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 68, 196, 219),
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 20),
                        Flexible(
                          child: ListView(
                            children: uploadedFiles.keys.map((title) {
                              final file = uploadedFiles[title];
                              return ListTile(
                                title: Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: file == null
                                    ? IconButton(
                                        icon: const Icon(Icons.add_a_photo),
                                        color: const Color.fromARGB(
                                            255, 56, 117, 152),
                                        onPressed: () => _pickFile(
                                            title: title, context: context),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          if (file.path.endsWith('.pdf')) {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => Dialog(
                                                child: PDFView(
                                                  filePath: file.path,
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => Dialog(
                                                child: Image.file(
                                                  file,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: file.path.endsWith('.pdf')
                                            ? const Icon(
                                                Icons.picture_as_pdf,
                                                color: Colors.red,
                                              )
                                            : Image.file(
                                                file,
                                                width: 40,
                                                height: 40,
                                              ),
                                      ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: state is AllFilesUploaded
                              ? () {
                                  uploadBloc.add(FinishUploadingFiles());
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Upload Complete"),
                                      content: const Text(
                                          "All files have been uploaded successfully."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            Navigator.pop(ctx); // Close the dialog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),));
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state is AllFilesUploaded
                                ? const Color.fromARGB(255, 56, 112, 142)
                                : Colors.grey,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
