import 'dart:io';

import 'package:app_api/controller/contact_controller.dart';
import 'package:app_api/model/contact.dart';
import 'package:app_api/view/home_page.dart';
import 'package:app_api/view/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactEditPage extends StatefulWidget {
  const ContactEditPage({super.key, required this.data});

  final Map data;

  @override
  State<ContactEditPage> createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
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
  void initState() {
    nama.text = widget.data['nama'];
    email.text = widget.data['email'];
    alamat.text = widget.data['alamat'];
    noTelpon.text = widget.data['no_telpon'];
    _imageFile = File(widget.data['gambar']);
    print("Path gambar: ${_imageFile!.path}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Contact"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: nama,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Nama',
                        labelText: 'Nama',
                      ),
                    ),
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
                  Image.network(_imageFile!.path),
                  // _imageFile != null
                  //     ? (widget.data['gambar'] != null
                  //         ? Container(
                  //             width: 300,
                  //             margin: const EdgeInsets.all(10),
                  //             child: Image.network(widget.data['gambar']!),
                  //           )
                  //         : const Text("Belum ada gambar yang dipilih"))
                  //     : Container(
                  //         height: 250,
                  //         margin: const EdgeInsets.all(20),
                  //         child: Image.file(_imageFile!),
                  //       ),
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
                          formKey.currentState!.save();
                          print(widget.data['id']);
                          print(widget.data['nama']);
                          print(widget.data['alamat']);
                          print(widget.data['email']);
                          print(widget.data['gambar']);
                          var result = await controller.updatePerson(
                              widget.data['id'],
                              Contact(
                                  nama: nama.text,
                                  email: email.text,
                                  alamat: alamat.text,
                                  no_telpon: noTelpon.text,
                                  gambar: _imageFile!.path),
                              _imageFile);

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
