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

  // Update Person Data
  Future<Map<String, dynamic>> updatePerson(
      int id, Contact person, File? file) async {
    Map<String, String> data = {
      "nama": person.nama,
      "email": person.email,
      "alamat": person.alamat,
      "no_telpon": person.no_telpon
    };

    try {
      var response = await contactService.updatePerson(id, data, file);
      if (response.statusCode == 200) {
        return {
          'success': true,
          "message": "Data berhasil diperbarui",
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
          'message': decodedJson['message'] ??
              'Terjadi kesalahan saat memperbarui data'
        };
      }
    } catch (e) {
      return {"success": false, "message": 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> deletePerson(int id) async {
    try {
      var response = await contactService.deletePerson(id);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data Berhasil dihapus',
        };
      } else {
        if (response.headers['content-type']!.contains('application/json')) {
          var decodedJson = jsonDecode(response.body);
          return {
            'success': false,
            'message': decodedJson['message'] ?? 'Terjadi kesalahan',
          };
        }

        var decodedJson = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              decodedJson['message'] ?? 'Terjadi kesalahan saat menghapus data',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
