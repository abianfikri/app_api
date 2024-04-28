import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_api/model/contact.dart';
import 'package:app_api/service/contact_service.dart';
import 'package:image_picker/image_picker.dart';

class ContactController {
  final contactService = ContactService();

  // Get ALL Data
  Future<List<Contact>> getDataPerson() async {
    try {
      List<dynamic> peopleData = await contactService.fetchPeople();
      List<Contact> people =
          peopleData.map((json) => Contact.fromMap(json)).toList();
      return people;
    } catch (e) {
      print(e);
      throw Exception('Failed to get people');
    }
  }

  // Add Person Data
  Future<Map<String, dynamic>> addPerson(Contact person, File? file) async {
    Map<String, String> data = {
      "nama": person.nama,
      "email": person.email,
      "alamat": person.alamat,
      "no_telpon": person.no_telpon
    };

    try {
      var response = await contactService.addPerson(data, file);
      if (response.statusCode == 201) {
        return {
          'success': true,
          "message": "Data berhasil disimpan",
        };
      } else {
        if (response.headers['content-type']!.contains('application/json')) {
          var decodedJson = jsonDecode(response.body);
          return {
            'success': false,
            "message": decodedJson['message'] ?? 'Terjadi kesalahan',
          };
        }

        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              decodedJson['message'] ?? 'Terjadi kesalahan saat menyimpan data'
        };
      }
    } catch (e) {
      return {"success": false, "message": 'Terjadi kesalahan: $e'};
    }
  }

  // Upload Image
  Future<void> uploadGambar(ImageSource source, File file) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);
      final image = pickedImage;
      if (image != null) {
        file = File(image.path);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
