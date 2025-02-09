import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage
  Future<String?> uploadFile(String filePath, String fileName, String folderName) async {
    try {
      File file = File(filePath);
      if (!await file.exists()) {
        print("File does not exist!");
        return null;
      }

      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("File uploaded successfully! URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print('Upload File Error: $e');
      return null;
    }
  }

  // Upload image from memory (e.g., using ImagePicker or similar)
  Future<String?> uploadImageFromMemory(File fileData, String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      UploadTask uploadTask = storageReference.putFile(fileData);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Image uploaded successfully! URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print('Upload Image Error: $e');
      return null;
    }
  }

  // Download file from Firebase Storage
  Future<File?> downloadFile(String filePath, String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      String localFilePath = '$filePath/$fileName';
      File file = File(localFilePath);

      // Download file to the specified local path
      await storageReference.writeToFile(file);

      print("File downloaded successfully to $localFilePath");
      return file;
    } catch (e) {
      print('Download File Error: $e');
      return null;
    }
  }

  // Get file's download URL
  Future<String?> getDownloadUrl(String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Get Download URL Error: $e');
      return null;
    }
  }

  // Delete a file from Firebase Storage
  Future<void> deleteFile(String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      await storageReference.delete();
      print("File deleted successfully!");
    } catch (e) {
      print('Delete File Error: $e');
    }
  }

  // Get file metadata (e.g., content type, size)
  Future<FullMetadata?> getFileMetadata(String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      FullMetadata metadata = await storageReference.getMetadata();
      print("File metadata: ${metadata.toString()}");
      return metadata;
    } catch (e) {
      print('Get File Metadata Error: $e');
      return null;
    }
  }

  // Check if file exists in Firebase Storage
  Future<bool> fileExists(String fileName, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/$fileName');
      await storageReference.getDownloadURL();
      return true;  // File exists
    } catch (e) {
      print('File not found: $e');
      return false;  // File doesn't exist
    }
  }

  // List all files in a folder (e.g., to display in UI)
  Future<List<Reference>> listFiles(String folderName) async {
    try {
      Reference folderReference = _storage.ref().child(folderName);
      ListResult result = await folderReference.listAll();
      print("Listed ${result.items.length} items in folder: $folderName");

      // Return a list of references for the files
      return result.items;
    } catch (e) {
      print('List Files Error: $e');
      return [];
    }
  }
}
