import 'dart:io';

import 'package:file_picker/file_picker.dart';


class FilePickerService {
  Future<File> getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      File file = File(result.files.single.path);
      return file;
    }
    return null;
  }

  getFiles() async {

  }
}