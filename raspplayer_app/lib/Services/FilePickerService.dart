import 'dart:io';

import 'package:file_picker/file_picker.dart';


class FilePickerService {

  //calls the native file picker
  Future<File> getFile() async {
    //restricts the files to audio types
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      File file = File(result.files.single.path);
      //returns the file
      return file;
    }
    //return null on error
    return null;
  }

}