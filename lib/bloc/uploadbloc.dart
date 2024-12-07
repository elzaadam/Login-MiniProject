import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickFile extends UploadEvent {
  final String title;
  final File file;

  PickFile({required this.title, required this.file});

  @override
  List<Object?> get props => [title, file];
}

class FinishUploadingFiles extends UploadEvent {}

// States
abstract class UploadStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadStates {}

class FileUploading extends UploadStates {}

class FileUploaded extends UploadStates {
  final Map<String, File?> uploadedFiles;

  FileUploaded({required this.uploadedFiles});

  @override
  List<Object?> get props => [uploadedFiles];
}

class AllFilesUploaded extends UploadStates {
  final Map<String, File?> uploadedFiles;

  AllFilesUploaded({required this.uploadedFiles});

  @override
  List<Object?> get props => [uploadedFiles];
}

// UploadBloc
class UploadBloc extends Bloc<UploadEvent, UploadStates> {
  // Initial map of files with their titles and null placeholders
  final Map<String, File?> uploadedFiles = {
    "Profile Picture": null,
    "Driving License": null,
    "Certificate": null,
    "Passport": null,
  };

  UploadBloc() : super(UploadInitial()) {
    // Handle PickFile event
    on<PickFile>((event, emit) {
      // Update the uploaded file map with the new file
      uploadedFiles[event.title] = event.file;

      // Emit the FileUploaded state to update the UI
      emit(FileUploaded(uploadedFiles: Map.from(uploadedFiles)));

      // Check if all files are uploaded and emit AllFilesUploaded if complete
      if (uploadedFiles.values.every((file) => file != null)) {
        emit(AllFilesUploaded(uploadedFiles: Map.from(uploadedFiles)));
      }
    });

    // Handle FinishUploadingFiles event
    on<FinishUploadingFiles>((event, emit) {
      // If all files are uploaded, finalize the upload process
      emit(AllFilesUploaded(uploadedFiles: Map.from(uploadedFiles)));
    });
  }
}
