import 'dart:io';

import 'package:app_api/controller/contact_controller.dart';
import 'package:app_api/model/contact.dart';
import 'package:app_api/view/home_page.dart';
import 'package:app_api/view/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PersonAddPage extends StatefulWidget {
  const PersonAddPage({super.key});

  @override
  State<PersonAddPage> createState() => _PersonAddPageState();
}

class _PersonAddPageState extends State<PersonAddPage> {
  final controller = ContactController();
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final email = TextEditingController();
  final alamat = TextEditingController();
  final noTelpon = TextEditingController();

  File? _imageFile;
  final _imagePicker = ImagePicker();

  Future getImage() async {
    try {
      final XFile? pickedImage =
          await _imagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedImage != null) {
          _imageFile = File(pickedImage.path);
        } else {
          const Text("No image selected");
        }
      });
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  CustomTf(
                    nama: nama,
                    hintText: "Masukkan nama",
                    labelText: "Nama",
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Email',
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: alamat,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Pilih Alamat',
                        labelText: 'Alamat',
                      ),
                      readOnly: true,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              onLocationSelected: (selectedAddress) {
                                setState(() {
                                  alamat.text = selectedAddress;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: noTelpon,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan No Telpon',
                        labelText: 'No Telpon',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _imageFile == null
                      ? const Text("Belum ada gambar yang dipilih")
                      : Container(
                          height: 250,
                          margin: const EdgeInsets.all(20),
                          child: Image.file(_imageFile!),
                        ),
                  ElevatedButton(
                    onPressed: getImage,
                    child: const Text("Pilih Gambar"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var result = await controller.addPerson(
                            Contact(
                                nama: nama.text,
                                email: email.text,
                                alamat: alamat.text,
                                no_telpon: noTelpon.text,
                                gambar: _imageFile!.path),
                            _imageFile,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['message'],
                              ),
                            ),
                          );

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false);
                        }
                      },
                      child: Text("Submit"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTf extends StatelessWidget {
  const CustomTf({
    super.key,
    required this.nama,
    required this.hintText,
    required this.labelText,
  });

  final TextEditingController nama;
  final String hintText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 350,
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: nama,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}
